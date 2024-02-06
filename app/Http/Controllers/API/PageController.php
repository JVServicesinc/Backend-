<?php

namespace App\Http\Controllers\API;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\DB;

class PageController extends Controller
{
    public function index(Request $request)
    {
        $page_slug = $request->get('page_slug');
        $sql = "SELECT * FROM settings WHERE `key` = :page_slug";        
        $page_data = DB::selectOne($sql, ['page_slug' => $page_slug]);

        return response()->json([
            'status'  => true,
            'data'    => [
                'page_slug' => $page_slug,
                'page_content' => !is_null($page_data) ? $page_data->value : null
            ]
        ]);
    }
}