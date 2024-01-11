<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;

class Booking extends Model
{
    use HasFactory;

    protected $table = 'jv_bookings';

    /**
     * Get bookings
     * 
     * @param int $limit
     * @param int $offset
     * @param string $search_key
     * @return array
     */
    public static function getBookings($limit = 200, $offset = 0, $search_key = '')
    {
        // find total record
        $sql = "SELECT IFNULL(COUNT(*), 0) AS total FROM jv_bookings";
        $data = DB::selectOne($sql);
        $totalRecordData = $data->total;

        $where_clause = " WHERE 1 ";

        if( $search_key != '' ) {
            $where_clause .= " AND (
                b.uniq_order_id LIKE '%".trim( htmlspecialchars($search_key) )."%'
                OR
                u.full_name LIKE '%".trim( htmlspecialchars($search_key) )."%'
            ) ";
        }

        // find total filtered records
        $sql = "SELECT IFNULL(COUNT(b.id), 0) AS total 
        FROM jv_bookings AS b
        INNER JOIN users AS u ON u.id = b.customer_id
        $where_clause";
        $data = DB::selectOne($sql);
        $recordsFiltered = $data->total;

        $sql = "SELECT
           b.id,
           b.uniq_order_id AS booking_id,
           u.full_name AS customer_name,
           CONCAT('$', b.subtotal) AS subtotal,
           CONCAT('$', (b.tax_gst + b.tax_qst)) AS total_tax,
           CONCAT('$', b.total) AS total,
           b.order_status AS status,
           b.created_at
        FROM jv_bookings AS b
        INNER JOIN users AS u ON u.id = b.customer_id
        $where_clause 
        ORDER BY
            b.id
        DESC
        LIMIT $limit
        OFFSET $offset";

        $bookings = DB::select($sql);
        
        foreach($bookings as $booking) {
            if($booking->status == 'pending') {
                $booking->status = '<span class="badge badge-warning">Pending</span>';
                $booking->created_at = (new \DateTimeImmutable($booking->created_at))->format('l jS F Y \a\t h:i A');
            }

            $action_links = '';
            $view_url = route("bookings.show", $booking->id);
            $action_links .= '<a class="mr-2" href="'.$view_url.'" title="View Bookings"><i class="fas fa-eye text-secondary"></i></a>';
            $booking->action_links = $action_links;
        }

        return [
            'recordsTotal' => $totalRecordData,
            'recordsFiltered' => $recordsFiltered,
            'data' => $bookings
        ];
    }

    /**
     * Get booking by id
     * 
     * @param int $booking_id
     * @return object
     */
    public static function getBookingById($booking_id)
    {
        $sql = "SELECT * FROM jv_bookings WHERE id = $booking_id";
        $booking = DB::selectOne($sql);

        if( !is_null($booking) ) {
            // find booking
            $sql = "SELECT 
                i.id,
                i.service_id,
                i.qty,
                i.unit_price,
                s.name
            FROM jv_booking_items AS i
            LEFT JOIN jv_services AS s ON s.id = i.service_id
            WHERE order_id = $booking_id";

            $booking->line_items = DB::select($sql);

            // find customer
            $sql = "SELECT * FROM users WHERE id = $booking->customer_id";

            $booking->customer = DB::selectOne($sql);
        }

        return $booking;
    }
}
