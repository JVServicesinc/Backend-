<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;

class ServiceSlots extends Model
{
    use HasFactory;

    protected $table = 'jv_service_slots';

    protected $fillable = [
        'service_id', 'weekday_number', 'timing'
    ];

    /**
     * Get service timings
     * 
     * @param int $service_id
     * @param int $weekday_number
     * @return array
     */
    public static function getServiceTimings($service_id, $weekday_number = null)
    {
        $where_clause =  "WHERE service_id = $service_id";

        if( !is_null($weekday_number) && ( 0 <= $weekday_number || $weekday_number < 7 ) ) {
            $where_clause .= " AND weekday_number = $weekday_number";
        }

        $sql = "SELECT
            id,
            service_id,
            CASE
                WHEN weekday_number = 0 THEN 'Monday'
                WHEN weekday_number = 1 THEN 'Tuesday'
                WHEN weekday_number = 2 THEN 'Wednesday'
                WHEN weekday_number = 3 THEN 'Thursday'
                WHEN weekday_number = 4 THEN 'Friday'
                WHEN weekday_number = 5 THEN 'Saturday'
                WHEN weekday_number = 6 THEN 'Sunday'
            END AS weekday_name,
            TIME_FORMAT(timing, '%h:%i %p') AS timing
        FROM jv_service_slots
        $where_clause
        ORDER BY weekday_number ASC,  timing ASC";

        return DB::select($sql);
    }
}
