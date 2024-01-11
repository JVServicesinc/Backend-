<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class StoreCategoryController extends Controller
{
    public function getStoreCategories(Request $request)
    {
        $sql = "SELECT 
            id,
            sub_name AS name,
            image
        FROM storecategories
        WHERE status = 1";

        $categories = DB::select($sql);

        foreach($categories as $category)
        {
            $category->image_url = asset($category->image);
        }

        return response()->json([
            'status' => true,
            'data' => $categories
        ]);
    }
}