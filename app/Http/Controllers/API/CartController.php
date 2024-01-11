<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use App\Models\Cart;

class CartController extends Controller
{
    public function cart_items( Request $request )
    {
        $uniq_cart_id = $request->get('cart_id');

        return response()->json([
            'status'  => true,
            'data'    => Cart::getCartItems($uniq_cart_id)
        ]);
    }

    public function sync_cart(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'cart_id' => 'required'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status'  => false,
                'message' => 'Validation error',
                'errors'  => $validator->errors()->all()
            ], 422);
        }

        Cart::syncUserCart($request->input('cart_id'));

        return response()->json([
            'status'  => true,
            'message' => 'Cart sync successfully'
        ]);
    }

    public function add_cart_item(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'customer_lat' => 'required',
            'customer_lng' => 'required',
            'item_type'    => [
                'required',
                function ($attribute, $value, $fail)  {
                    if( $value == 'product' ) {
                        if( empty(request()->input('product_sku', '')) ||  empty(request()->input('product_qty', '')) || empty(request()->input('product_price', '')) ) {
                            $fail('product_sku and product_qty and product_price can not be empty');
                        }
                    } else {
                        if( empty(request()->input('service_id', '')) ||  empty(request()->input('qty', '')) || empty(request()->input('unit_price', '')) ) {
                            $fail('service_id and qty and unit_price can not be empty');
                        }
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

        $data = [
            'customer_lat' => $request->input('customer_lat'),
            'customer_lng' => $request->input('customer_lng'),
            'item_type'    => $request->input('item_type'),
            'product_sku'  => $request->input('product_sku'),
            'product_qty'  => $request->input('product_qty'),
            'product_price' => $request->input('product_price'),
            'service_id'    => $request->input('service_id'),
            'qty'           => $request->input('qty'),
            'unit_price'    => $request->input('unit_price')
        ];

        $uniq_cart_id = Cart::addCartItem($data);

        return response()->json([
            'status'  => true,
            'data'    => [
                'cart_id' => $uniq_cart_id
            ],
            'message' => 'Cart created successfully'
        ]);
    }

    public function add_auth_cart_item(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'customer_lat' => 'required',
            'customer_lng' => 'required',
            'item_type'    => [
                'required',
                function ($attribute, $value, $fail)  {
                    if( $value == 'product' ) {
                        if( empty(request()->input('product_sku', '')) ||  empty(request()->input('product_qty', '')) || empty(request()->input('product_price', '')) ) {
                            $fail('product_sku and product_qty and product_price can not be empty');
                        }
                    } else {
                        if( empty(request()->input('service_id', '')) ||  empty(request()->input('qty', '')) || empty(request()->input('unit_price', '')) ) {
                            $fail('service_id and qty and unit_price can not be empty');
                        }
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

        $data = [
            'customer_lat' => $request->input('customer_lat'),
            'customer_lng' => $request->input('customer_lng'),
            'item_type'    => $request->input('item_type'),
            'product_sku'  => $request->input('product_sku'),
            'product_qty'  => $request->input('product_qty'),
            'product_price' => $request->input('product_price'),
            'service_id'    => $request->input('service_id'),
            'qty'           => $request->input('qty'),
            'unit_price'    => $request->input('unit_price')
        ];

        $uniq_cart_id = Cart::addCartItemAuth($data);

        return response()->json([
            'status'  => true,
            'data'    => [
                'cart_id' => $uniq_cart_id
            ],
            'message' => 'Cart created successfully'
        ]);
    }

    public function remove_cart_item($cart_id, $cart_item_id)
    {
        Cart::removeCartItem($cart_id, $cart_item_id);

        return response()->json([
            'status'  => true,
            'message' => 'Item removed successfully'
        ]);
    }

    public function update_cart_item(Request $request, $cart_id)
    {
        $validator = Validator::make($request->all(), [
            'item_type'    => [
                'required',
                function ($attribute, $value, $fail)  {
                    if( $value == 'product' ) {
                        if( empty(request()->input('product_sku', '')) ||  empty(request()->input('product_qty', '')) || empty(request()->input('product_price', '')) ) {
                            $fail('product_sku and product_qty and product_price can not be empty');
                        }
                    } else {
                        if( empty(request()->input('service_id', '')) ||  empty(request()->input('qty', '')) || empty(request()->input('unit_price', '')) ) {
                            $fail('service_id and qty and unit_price can not be empty');
                        }
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

        Cart::updateCartItem($request->all(),  $cart_id);

        return response()->json([
            'status'  => true,
            'message' => 'Cart updated successfully'
        ]);
    }

    public function update_cart_service_item_slot(Request $request, $cart_id, $cart_item_id)
    {
        $post_data = $request->all();
        $post_data['cart_item_id'] = $cart_item_id;

        $validator = Validator::make($post_data, [
            'weekday_number' => 'required',
            'timing' => 'required',
            'cart_item_id' => [
                function ($attribute, $value, $fail) {
                    $sql = "SELECT * FROM jv_customer_cart_service_items WHERE id = $value";
                    $item = \Illuminate\Support\Facades\DB::selectOne($sql);

                    if( is_null($item) ) {
                        $fail('No item exist with this cart item id');
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

        Cart::saveServiceCartItemSlot(
            $cart_id,
            $cart_item_id,
            [
                'weekday_number' => $request->input('weekday_number'),
                'timing' => $request->input('timing')
            ]
        );

        return response()->json([
            'status'  => true,
            'message' => 'slot saved successfully'
        ]);
    }
}
