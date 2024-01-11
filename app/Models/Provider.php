<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;

class Provider extends Model
{
    use HasFactory;

    protected $table = 'users';

    public static function getBookings($provider_id, $filters=[], $search='', $page = 1)
    {
        $offset = (intval($page) - 1) * 10;

        $where = " WHERE 1 AND b.provider_id = $provider_id AND ";

        foreach( $filters as $column => $value ) {
            $where .= sprintf("%s='%s' AND ", $column, $value);
        }

        $where = rtrim($where, ' AND ');

        $sql = "SELECT 
                b.id,
                b.uniq_order_id AS booking_id,
                (
                    SELECT full_name FROM users
                    WHERE id = b.customer_id
                ) AS customer_name,
                b.created_at AS booking_date
            FROM jv_bookings b
            $where
            ORDER BY b.id DESC
            LIMIT 10
            OFFSET $offset";

        $bookings = DB::select($sql);

        foreach($bookings as $booking) {
            // find order items
            $sql = "SELECT 
            i.*,
            s.name AS service_name,
            s.duration AS service_duration
            FROM jv_booking_items AS i
            LEFT JOIN jv_services AS s ON s.id = i.service_id
            WHERE i.order_id = $booking->id";

            $booking->line_items =  DB::select($sql);
        }

        return $bookings;
    }

    /**
     * Get provider available slots
     * 
     * @param int $provider_id
     * @return array
     */
    public static function getSlots($provider_id)
    {
        $sql = "SELECT jv_provider_slots.id, jv_provider_slots.weeekday,
            CASE
                WHEN jv_provider_slots.weeekday = 6 THEN 'Sunday'
                WHEN jv_provider_slots.weeekday = 0 THEN 'Monday'
                WHEN jv_provider_slots.weeekday = 1 THEN 'Tuesday'
                WHEN jv_provider_slots.weeekday = 2 THEN 'Wednesday'
                WHEN jv_provider_slots.weeekday = 3 THEN 'Thursday'
                WHEN jv_provider_slots.weeekday = 4 THEN 'Friday'
                WHEN jv_provider_slots.weeekday = 5 THEN 'Saturday'
            END  AS weeekday_name,
            (
                SELECT GROUP_CONCAT(jv_provider_slot_items.slot_time)
                FROM jv_provider_slot_items
                WHERE jv_provider_slot_items.slot_id = jv_provider_slots.id
                GROUP BY jv_provider_slot_items.slot_id
            )  AS timings
        FROM jv_provider_slots
        WHERE jv_provider_slots.provider_id = $provider_id
        ORDER BY jv_provider_slots.weeekday ASC";

        $slots = DB::select($sql);

        foreach($slots as $slot) {
            $slot->timings = explode(',', $slot->timings);
        }

        return $slots;
    }

    /**
     * Save provider slots
     * 
     * @param string $slots
     * @param int $provider_id
     * @return bool
     */
    public static function saveSlots($weekday_info, $provider_id)
    {
        $weekday_info = json_decode($weekday_info, true);

        DB::transaction(function () use ($weekday_info, $provider_id) {
            foreach( $weekday_info as $weekday ) {

                $sql = "SELECT * FROM jv_provider_slots WHERE weeekday = :weeekday AND provider_id = :provider_id";

                $weekdayInfo = DB::selectOne($sql, [
                    'weeekday' => $weekday['weeekday'],
                    'provider_id'   => $provider_id
                ]);

                if( !is_null($weekdayInfo) ) {

                    $slots = $weekday['timings'];

                    $sql = "DELETE FROM jv_provider_slot_items WHERE slot_id = :slot_id";
                    DB::statement($sql, ['slot_id' => $weekdayInfo->id]);

                    if( !empty($slots) ) {
                        foreach($slots as $slot_time) {
                            DB::table('jv_provider_slot_items')->insert([
                                'slot_id' => $weekdayInfo->id,
                                'slot_time' => $slot_time
                            ]);
                        }
                    }
                }
            }
        });
    }
}