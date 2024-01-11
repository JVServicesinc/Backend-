<?php

namespace App\Http\Controllers\API;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Validator;
use App\Models\Order;

class OrderController extends Controller
{

    public function reject_booking(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'order_id' => [
                'required',
                function ($attribute, $value, $fail)  {
                    $sql = "SELECT * FROM jv_bookings WHERE uniq_order_id = :uniq_cart_id";

                    $order = \Illuminate\Support\Facades\DB::selectOne($sql, ['uniq_cart_id' => $value]);
                    if( is_null($order) ) {
                        $fail('no booking exist with this id');
                    }
                }
            ]
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status'  => false,
                'message' => 'Validation error',
                'errors'  => $validator->errors()->all()
            ], 422);
        }

        Order::markOrderAsRejected(
            $request->input('order_id')
        );

        return response()->json([
            'status'  => true,
            'message'    => 'booking rejected successfully'
        ]);
    }

    public function accept_booking(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'order_id' => [
                'required',
                function ($attribute, $value, $fail)  {
                    $sql = "SELECT * FROM jv_bookings WHERE uniq_order_id = :uniq_cart_id";

                    $order = \Illuminate\Support\Facades\DB::selectOne($sql, ['uniq_cart_id' => $value]);
                    if( is_null($order) ) {
                        $fail('no booking exist with this id');
                    }

                    if( !is_null($order) && !is_null($order->provider_id) ) {
                        $fail('booking already accecpted');
                    }
                }
            ]
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status'  => false,
                'message' => 'Validation error',
                'errors'  => $validator->errors()->all()
            ], 422);
        }

        Order::markOrderAsAccepted(
            $request->input('order_id')
        );

        return response()->json([
            'status'  => true,
            'message'    => 'booking accecpted successfully'
        ]);
    }

    public function validate_booking_otp(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'order_id' => [
                'required',
                function ($attribute, $value, $fail)  {
                    $sql = "SELECT * FROM jv_bookings WHERE uniq_order_id = :uniq_cart_id";

                    $order = \Illuminate\Support\Facades\DB::selectOne($sql, ['uniq_cart_id' => $value]);
                    if( is_null($order) ) {
                        $fail('no booking exist with this id');
                    }
                }
            ],
            'otp' => ['required']
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status'  => false,
                'message' => 'Validation error',
                'errors'  => $validator->errors()->all()
            ], 422);
        }

        $result = Order::validateBookingOtp(
            $request->input('order_id'),
            $request->input('otp')
        );

        if( !$result ) {
            return response()->json([
                'status'  => false,
                'message' => 'Validation error',
                'errors'  => [
                    'otp dose not match'
                ]
            ], 422);
        }

        return response()->json([
            'status'  => true,
            'message'    => 'otp validated successfully'
        ]);
    }

    public function order_confirm(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'order_id' => [
                'required',
                function ($attribute, $value, $fail)  {

                    if( str_contains($value, 'SER') ) {
                        $sql = "SELECT * FROM jv_bookings WHERE uniq_order_id = :uniq_cart_id";
                    } else {
                        $sql = "SELECT * FROM jv_orders WHERE uniq_order_id = :uniq_cart_id";
                    }

                    $order = \Illuminate\Support\Facades\DB::selectOne($sql, ['uniq_cart_id' => $value]);
                    if( is_null($order) ) {
                        $fail('no order exist with this id');
                    }
                }
            ]
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status'  => false,
                'message' => 'Validation error',
                'errors'  => $validator->errors()->all()
            ], 422);
        }

        $order = Order::markOrderAsConfirm(
            $request->input('order_id')
        );

        return response()->json([
            'status'  => true,
            'message'    => 'order confirmed successfully',
            'data'      => $order
        ]);
    }

    public function payment_intent($order_id)
    {
        return response()->json([
            'status'  => true,
            'data'    => Order::createPaymentIntent($order_id)
        ]);
    }

    public function create_order(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'cart_id' => [
                'required',
                function ($attribute, $value, $fail)  {
                    $sql = "SELECT * FROM jv_customer_cart WHERE uniq_cart_id = :uniq_cart_id AND customer_id = :customer_id";
                    global $userData;
                    $user = \Illuminate\Support\Facades\DB::selectOne($sql, ['uniq_cart_id' => $value, 'customer_id' => $userData->id]);
                    if( is_null($user) ) {
                        $fail('Invalid cart id');
                    }
                }
            ],
            'customer_address_id' => [
                'required',
                function ($attribute, $value, $fail)  {
                    $sql = "SELECT * FROM user_address WHERE id = :id AND user_id = :user_id";
                    global $userData;
                    $user = \Illuminate\Support\Facades\DB::selectOne($sql, ['id' => $value, 'user_id' => $userData->id]);
                    if( is_null($user) ) {
                        $fail('Invalid address id');
                    }
                }
            ],
            'success_url'         => 'required',
            'cancel_url'          => 'required'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status'  => false,
                'message' => 'Validation error',
                'errors'  => $validator->errors()->all()
            ], 422);
        }

        try {
            $order_id = Order::create_order($request->all());
            $payment_url = Order::initPayment($order_id, $request->post('success_url'), $request->post('cancel_url'));

            return response()->json([
                'status'  => true,
                'data'    => [
                    'payment_url' => $payment_url,
                    'order_id' => $order_id
                ]
            ]);
        } catch( \Exception $e ) {

        }
    }

    public function list_orders(Request $request)
    {
        global $userData;

        $page_no = $request->get('page', 1);
        $limit = $request->get('limit', 10);

        if( $limit > 20 ) {
            $limit = 20;
        }

        $customer_id = $userData->id;

        $data = [
            'total_order_count' => Order::getTotalOrderCountForCustomer($customer_id),
            'limit'         => $limit,
            'page'          => $page_no,
            'order_list'    =>  Order::getOrders($customer_id, $page_no, $limit)
        ];

        return response()->json([
            'status'  => true,
            'data'    => $data
        ]);
    }

    
    public function order_details($uniq_order_id)
    {
        return response()->json([
            'status'  => true,
            'data'    => Order::getOrderDetails($uniq_order_id)
        ]);
    }
}
