<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class SearchController extends Controller
{
    public function index(Request $request)
    {
        $search_str = trim(htmlspecialchars($request->get('q', '')));

        $product_search_sql = "SELECT
            id,
            name,
            slug,
            sku
        FROM jv_product
        WHERE slug LIKE '%".$search_str."%' AND is_archived = 0
        LIMIT 5";

        if( $search_str == '' ) {
            $products = [];
        } else {
            $products = DB::select($product_search_sql);
        }

        $services = [];
        
        return response()->json([
            'status'  => true,
            'data'    => [
                'products' => $products,
                'services' => $services
            ]
        ]);
    }
}