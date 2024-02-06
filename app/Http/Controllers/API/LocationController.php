<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class LocationController extends Controller
{
    public function get_street_address_by_lat_lng(Request $request)
    {
        $lat = $request->get('lat');
        $lng = $request->get('lng');

        $ch = curl_init() ;  
        
        $url  = 'https://maps.googleapis.com/maps/api/geocode/json';

        $params = http_build_query([
            'latlng' => sprintf('%s,%s', $lat, $lng),
            'key' => env('GOOGLE_MAPS_API_KEY')
        ]);

        //set cURL options  
        curl_setopt($ch, CURLOPT_URL, sprintf('%s?%s', $url, $params));
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        $result = curl_exec($ch);
        
        // close cURL resource  
        curl_close($ch);

        $result = json_decode($result);

        if($result->status == 'OK') {
            return response()->json([
                'status'  => true,
                'data'    => [
                    'address'   => $result->results[0]->formatted_address
                ]
            ]);
        }

        return response()->json([
            'status'  => false,
            'message' => 'Server error'
        ], 500);
    }
}
   