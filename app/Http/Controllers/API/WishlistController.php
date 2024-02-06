<?php

namespace App\Http\Controllers\API;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use App\Http\Controllers\Controller;
use App\Models\Wishlist;
use App\Models\Product;

class WishlistController extends Controller
{
    public function check_product_or_service_exit(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'type'     => 'required',
            'ref_id'  => 'required'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status'  => false,
                'message' => 'Validation error',
                'errors'  => $validator->errors()->all()
            ], 422);
        }

        global $userData;

        return response()->json([
            'status'  => true,
            'data' => [
                'is_exist' => Product::isProductWishlisted( 
                    $request->input('ref_id'),
                    $userData->id,
                    $request->input('type')
                )
            ]
        ]);
    }

    public function create_wishlist(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'type'     => 'required',
            'ref_id'  => [
                'required',
                function ($attribute, $value, $fail)use($request)  {
                    // try to find user by email or mobile
                    $sql = "SELECT * FROM jv_wishlist WHERE type = :type AND ref_id = :ref_id";
                    $item = \Illuminate\Support\Facades\DB::selectOne($sql, ['ref_id' => $value, 'type' => $request->input('type') ]);
    
                    if( !is_null($item) ) {
                        $fail('Item already exist');
                    }
                }
            ],
            
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status'  => false,
                'message' => 'Validation error',
                'errors'  => $validator->errors()->all()
            ], 422);
        }

        $data = $request->all();

        global $userData;

        $data['customer_id'] = $userData->id;

        Wishlist::create($data);

        return response()->json([
            'status'  => true,
            'message' => 'item added to wishlist successfully'
        ]);
    }

    public function wishlists(Request $request)
    {
        $type = $request->get('type', 'product');
        global $userData;
        $customer_id = $userData->id;

        return response()->json([
            'status'  => true,
            'data'    => Wishlist::getWishlists($type, $customer_id)
        ]);
    }

    public function remove_wishlist($id)
    {
        Wishlist::destroy($id);

        return response()->json([
            'status'  => true,
            'message'    => 'Item removed from wishlist'
        ]);
    }
}
