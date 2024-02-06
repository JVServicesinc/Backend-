<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Product;
use App\Models\ProductCategory;
use App\Models\ProductRating;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class ProductController extends Controller
{
    public function compare_products(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'product_ids'     => [
                'required',
                function ($attribute, $value, $fail)  {

                    $parts = explode(',', $value);

                    if( count($parts) < 2 ) {
                        $fail('minimum 2 product is required for compare');
                    }
                }
            ]
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status'  => false,
                'message' => 'Validation error',
                'errors'  =>$validator->errors()->all()
            ], 422);
        }

        return response()->json([
            'status' => true,
            'data'   => Product::compareProducts($request->input('product_ids'))
        ]);
    }

    public function delete_rating(Request $request, $product_id, $rating_id)
    {
        $post_data = $request->all();
        $post_data['product_id'] = $product_id;
        $post_data['rating_id'] = $rating_id;

        $validator = Validator::make($post_data, [
            'product_id'     => 'required',
            'rating_id'      => 'required'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status'  => false,
                'message' => 'Validation error',
                'errors'  =>$validator->errors()->all()
            ], 422);
        }

        ProductRating::destroy($rating_id);

        return response()->json([
            'status' => true,
            'data'   => 'rating deleted successfully'
        ]);
    }

    public function update_rating(Request $request, $product_id, $rating_id)
    {
        $post_data = $request->all();
        $post_data['product_id'] = $product_id;

        $validator = Validator::make($post_data, [
            'product_id'     => 'required',
            'rating'         => [
                'required',
                function ($attribute, $value, $fail)  {
                    if( $value < 1 || $value > 5 ) {
                        $fail('Rating must be between 1 and 5');
                    }
                }
            ]
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status'  => false,
                'message' => 'Validation error',
                'errors'  =>$validator->errors()->all()
            ], 422);
        }

        ProductRating::where('id', $rating_id)->update($post_data);

        return response()->json([
            'status' => true,
            'data'   => 'rating updated successfully'
        ]);
    }

    public function add_rating(Request $request, $product_id)
    {
        $post_data = $request->all();
        $post_data['product_id'] = $product_id;

        $validator = Validator::make($post_data, [
            'product_id'     => [
                'required',
                function ($attribute, $value, $fail)  {
                    // check if review already given or not
                    $sql = "SELECT * FROM jv_product_ratings WHERE product_id = :product_id AND customer_id = :customer_id";

                    global $userData;

                    $rating = \Illuminate\Support\Facades\DB::selectOne($sql, [
                        'product_id' => $value,
                        'customer_id' => $userData->id
                    ]);

                    if( !is_null($rating) ) {
                        $fail('Rating already given for this product');
                    }
                }
            ],
            'rating'         => [
                'required',
                function ($attribute, $value, $fail)  {
                    if( $value < 1 || $value > 5 ) {
                        $fail('Rating must be between 1 and 5');
                    }
                }
            ]
        ], [
            'product_id.exists' => 'No product exist with this id'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status'  => false,
                'message' => 'Validation error',
                'errors'  =>$validator->errors()->all()
            ], 422);
        }

        global $userData;
        $post_data['customer_id'] = $userData->id;
        
        ProductRating::create($post_data);

        return response()->json([
            'status' => true,
            'data'   => 'rating added successfully'
        ]);
    }

    public function get_product_categories()
    {
        $product_categories = ProductCategory::getCategories();
        return response()->json([
            'status' => true,
            'data'   => $product_categories
        ]);
    }

    public function get_product_by_category($id)
    {
        return response()->json([
            'status' => true,
            'data'   => Product::getProductsByCategoryId($id)
        ]);
    }

    public function get_trending_products()
    {
        return response()->json([
            'status' => true,
            'data'   => Product::getTrendingProducts()
        ]);
    }

    public function get_product_details($id)
    {
        $product =  Product::getProductById($id);
        $product->ratings = Product::getProductRatings($id);
        $product->reviews = Product::getProductReviews($id);
        
        return response()->json([
            'status' => true,
            'data'   => $product
        ]);
    }
}