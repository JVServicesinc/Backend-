<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;
use App\Models\Cart;

class Order extends Model
{
    use HasFactory;

    /**
     * Mark order as confirm
     */
    public static function markOrderAsConfirm($order_id)
    {
        if( str_contains($order_id, 'SER') ) {
            $order = self::getBookingDetails($order_id);
            // send message to all connected provider
            $booking_url = env('BOOKING_SERVER_URL') . '/notify-provider?order_id='.$order_id;
            $curlHandle = curl_init($booking_url);
            curl_setopt($curlHandle, CURLOPT_RETURNTRANSFER, true);
            curl_setopt($curlHandle, CURLOPT_SSL_VERIFYPEER, 0);
            curl_exec($curlHandle);
            curl_close($curlHandle);
        } else {
            $order = self::getOrderDetails($order_id);
        }

        // empty cart now
        $sql = "DELETE FROM jv_customer_cart WHERE uniq_cart_id = '$order->customer_cart_id'";
        DB::statement($sql);

        return $order;
    }

    public static function createPaymentIntent($order_id)
    {
        if( str_contains($order_id, 'SER') ) {
            $order = self::getBookingDetails($order_id);
        } else {
            $order = self::getOrderDetails($order_id);
        }

        $customer = DB::selectOne("SELECT * FROM users WHERE id = $order->customer_id");
        $stripe = new \Stripe\StripeClient( env('STRIPE_SECRET_KEY') );

        if( is_null($customer->stripe_customer_id) ) {
            $stripe_customer = $stripe->customers->create([
                'name' => $customer->full_name,
                'email' => $customer->email
            ]);

            $stripe_customer_id = $stripe_customer->id;
        } else {
            $stripe_customer_id = $customer->stripe_customer_id;
        }

        try {
            $payment_intent = $stripe->paymentIntents->create([
                'amount' => $order->total * 100,
                'currency' => 'INR',
                'automatic_payment_methods' => ['enabled' => true],
                'customer' => $stripe_customer_id,
                'description' => 'Payment for order id '.$order_id. ' in jeveux',
                'metadata' => [
                    'order_id' => $order_id
                ]
            ]);

            $ephemeralKey = $stripe->ephemeralKeys->create([
                'customer' => $stripe_customer_id,
            ], [
                'stripe_version' => '2022-08-01',
            ]);

            return [
                'paymentIntent' => $payment_intent->client_secret,
                'ephemeralKey' => $ephemeralKey->secret,
                'customer' => $stripe_customer_id
            ];
        } catch( \Stripe\Exception\ApiErrorException $e  ) {
            return false;
        }
    }

    /**
     * Validate booking otp
     * 
     * @param string $order_id
     * @param string $booking_otp
     * @return bool
     */
    public static function validateBookingOtp($order_id, $booking_otp)
    {
        $booking = self::getBookingDetails($order_id);

        if( $booking->otp != $booking_otp ) {
            return false;
        }

        DB::table('jv_bookings')->where(['uniq_order_id' => $order_id])->update([
            'otp_validated' => 'yes'
        ]);

        return true;
    }

    public static function markOrderAsAccepted($order_id)
    {
        global $userData;

        return DB::table('jv_bookings')->where(['uniq_order_id' => $order_id])->update([
            'provider_id' => $userData->id,
            'order_status' => 'accepted'
        ]);
    }

    public static function markOrderAsRejected($order_id)
    {    
        $booking = self::getBookingDetails($order_id);

        global $userData;

        return DB::table('jv_booking_reject_history')->insert([
            'user_id' => $userData->id,
            'order_id' => $booking->id
        ]);
    }


    public static function create_product_order($post_data, $cart)
    {
        DB::beginTransaction();

        try {
            $subtotal = $cart->subtotal;
            $total = $subtotal + $cart->taxes['gst'] + $cart->taxes['qst'];

            $customer_address = DB::selectOne("SELECT * FROM user_address WHERE id = :id", ['id' => $post_data['customer_address_id']]);
            
            $uniq_order_id = strtoupper(uniqid('JV-PRO-'));
            // create order
            $order_data = [
                'uniq_order_id' => $uniq_order_id,
                'customer_cart_id' => $post_data['cart_id'],
                'customer_lat'  => $cart->customer_lat,
                'customer_lng'  => $cart->customer_lng,
                'customer_id'  => $cart->customer_id,
                'subtotal'      => $subtotal,
                'tax_gst'       => $cart->taxes['gst'],
                'tax_qst'       => $cart->taxes['qst'],
                'total'         => $total,
                'billing_address' => json_encode($customer_address),
                'shipping_address'  => json_encode($customer_address)
            ];

            $order_id = DB::table('jv_orders')->insertGetId($order_data);

            foreach($cart->items as $item) {
                DB::table('jv_order_items')->insert([
                    'order_id' => $order_id,
                    'product_id' => $item->product_id,
                    'product_sku' => $item->product_sku,
                    'qty'         => $item->qty,
                    'unit_price'  => $item->unit_price
                ]);
            }

            DB::commit();

            return $uniq_order_id;
        } catch (\Exception $e) {
            DB::rollback();
        }
    }

    public static function create_service_order($post_data, $cart)
    {
        DB::beginTransaction();

        try {
            $subtotal = $cart->subtotal;
            $total = $subtotal + $cart->taxes['gst'] + $cart->taxes['qst'];

            $customer_address = DB::selectOne("SELECT * FROM user_address WHERE id = :id", ['id' => $post_data['customer_address_id']]);
            
            $uniq_order_id = strtoupper(uniqid('JV-SER-'));
            // create order
            $order_data = [
                'uniq_order_id' => $uniq_order_id,
                'otp' => random_int(1987, 9989),
                'customer_cart_id' => $post_data['cart_id'],
                'customer_lat'  => $cart->customer_lat,
                'customer_lng'  => $cart->customer_lng,
                'customer_id'   => $cart->customer_id,
                'subtotal'      => $subtotal,
                'tax_gst'       => $cart->taxes['gst'],
                'tax_qst'       => $cart->taxes['qst'],
                'total'         => $total,
                'billing_address' => json_encode($customer_address),
                'shipping_address'  => json_encode($customer_address)
            ];

            $order_id = DB::table('jv_bookings')->insertGetId($order_data);

            foreach($cart->items as $item) {
                DB::table('jv_booking_items')->insert([
                    'order_id' => $order_id,
                    'service_id' => $item->service_id,
                    'qty'         => $item->qty,
                    'unit_price'  => $item->unit_price
                ]);
            }

            DB::commit();

            return $uniq_order_id;
        } catch (\Exception $e) {
            DB::rollback();
        }
    }

    /**
     * Create order
     * 
     * @param array $post_data
     */
    public static function create_order($post_data)
    {
        $cart = Cart::getCartItems($post_data['cart_id']);

        if($cart->item_type == 'product') {
            return self::create_product_order($post_data, $cart);
        } else {
            return self::create_service_order($post_data, $cart);
        }
    }

    /**
     * Get order details
     * 
     * @param string $order_id
     */
    public static function getOrderDetails($order_id)
    {
        $sql = "SELECT * FROM jv_orders WHERE uniq_order_id = :uniq_order_id";
        $order = DB::selectOne($sql, ['uniq_order_id' => $order_id]);

        if( !is_null($order) ) {
            // find order items
            $sql = "SELECT 
                jv_order_items.*,
                p.name AS product_name,
                p.slug As product_slug,
                p.image_url AS product_image_url
            FROM jv_order_items 
            LEFT JOIN jv_product AS p ON p.id = jv_order_items.product_id
            WHERE jv_order_items.order_id = $order->id";

            $order_items = DB::select($sql);

            foreach($order_items as $item) {
                $item->product_image_url = asset('public/uploads/products/'.$item->product_image_url);
            }

            $order->line_items = $order_items;

            // find customer
            $sql = "SELECT * FROM users WHERE id = $order->customer_id";

            $order->customer = DB::selectOne($sql);
        }

        return $order;
    }

    /**
     * Init stripe payment
     * 
     * @param string $order_id
     * @param string $success_url
     * @param string $cancel_url
     * @return string
     */
    public static function initPayment($order_id, $success_url, $cancel_url)
    {
        $stripe = new \Stripe\StripeClient(env('STRIPE_SECRET_KEY'));
        $line_items = [];

        if( str_contains($order_id, 'PRO') ) {
            $order = self::getOrderDetails($order_id);
            $sql = "SELECT * FROM users WHERE id = $order->customer_id";
            $customer = DB::selectOne($sql);
            $order_item_type = 'product';

            foreach($order->line_items as $item) {
                $line_items[] = [
                    'price_data' => [
                        'currency' => 'CAD',
                        'product_data' => [
                            'name' => $item->product_name
                        ],
                        'unit_amount' => $item->unit_price * 100,
                        'tax_behavior' => 'exclusive'
                    ],
                    'quantity' => $item->qty,
                    'tax_rates' => ['txr_1O906tSJdxCyQkYTbZ0r9CIp', 'txr_1O907WSJdxCyQkYTXgJWJmqk']
                ];
            }
        } else {
            $order = self::getBookingDetails($order_id);
            $sql = "SELECT * FROM users WHERE id = $order->customer_id";
            $customer = DB::selectOne($sql);
            $order_item_type = 'service';

            foreach($order->line_items as $item) {
                $line_items[] = [
                    'price_data' => [
                        'currency' => 'CAD',
                        'product_data' => [
                            'name' => $item->service_name
                        ],
                        'unit_amount' => $item->unit_price * 100,
                        'tax_behavior' => 'exclusive'
                    ],
                    'quantity' => $item->qty,
                    'tax_rates' => ['txr_1O906tSJdxCyQkYTbZ0r9CIp', 'txr_1O907WSJdxCyQkYTXgJWJmqk']
                ];
            }
        }

        $checkout_session = $stripe->checkout->sessions->create([
            'client_reference_id' => $order_id,
            'customer_email' => $customer->email,
            'line_items' => $line_items,
            'mode' => 'payment',
            'currency' => 'CAD',
            'metadata' => [
                'item_type' => $order_item_type
            ],
            'success_url' => $success_url,
            'cancel_url' => $cancel_url,
            'invoice_creation' => [
                'enabled' => true
            ]
        ]);

        return $checkout_session->url;
    }

    /**
     * Update order payment webhook data
     * 
     * @param object $stripe_webhook_data
     */
    public static function updateOrderPaymentInfo($stripe_webhook_data)
    {
        $order_id = $stripe_webhook_data->client_reference_id;
        $stripe_data = [
            'stripe_invoice_id'     => $stripe_webhook_data->invoice,
            'stripe_customer_id'    => $stripe_webhook_data->customer,
            'currency'              => $stripe_webhook_data->currency,
            'payment_method_types'  => $stripe_webhook_data->payment_method_types
        ];
        
        if( $stripe_webhook_data->metadata->item_type == 'service' ) {
            $order = self::getBookingDetails($order_id);

            DB::table('jv_bookings')->where('uniq_order_id', $order_id)->update([
                'payment_status' => 'paid',
                'stripe_payment_ref' => json_encode($stripe_data)
            ]);

            DB::table('jv_customer_cart')->where('customer_id', $order->customer_id)->delete();
        } else {
            $order = self::getOrderDetails($order_id);

            DB::table('jv_orders')->where('uniq_order_id', $order_id)->update([
                'payment_status' => 'paid',
                'stripe_payment_ref' => json_encode($stripe_data)
            ]);

            DB::table('jv_customer_cart')->where('customer_id', $order->customer_id)->delete();
        }
    }

    /**
     * Get total order count for customer
     * 
     * @param int $customer_id
     * @return int
     */
    public static function getTotalOrderCountForCustomer($customer_id)
    {
        $sql = "SELECT IFNULL(COUNT(*), 0) AS total FROM jv_orders WHERE customer_id = $customer_id";
        $result = DB::selectOne($sql);
        return $result->total;
    }

    public static function getAllOrders($limit = 10, $offset = 0, $search_key = '')
    {
        // find total record
        $sql = "SELECT IFNULL(COUNT(*), 0) AS total FROM jv_orders";
        $data = DB::selectOne($sql);
        $totalRecordData = $data->total;

        $where_clause = " WHERE 1 ";

        if( $search_key != '' ) {
            $where_clause .= " AND (
                o.uniq_order_id LIKE '%".trim( htmlspecialchars($search_key) )."%'
                OR
                u.full_name LIKE '%".trim( htmlspecialchars($search_key) )."%'
            ) ";
        }

        // find total filtered records
        $sql = "SELECT IFNULL(COUNT(o.id), 0) AS total 
        FROM jv_orders AS o
        INNER JOIN users AS u ON u.id = o.customer_id
        $where_clause";
        $data = DB::selectOne($sql);
        $recordsFiltered = $data->total;

        $sql = "SELECT
            o.id,
            o.uniq_order_id AS order_id,
            u.full_name AS customer_name,
            CONCAT('$', o.subtotal) AS subtotal,
            CONCAT('$', (o.tax_gst + o.tax_qst)) AS total_tax,
            CONCAT('$', o.total) AS total,
            o.order_status AS status,
            o.created_at
        FROM jv_orders AS o
        INNER JOIN users AS u ON u.id = o.customer_id
        $where_clause 
        ORDER BY
            o.id
        DESC
        LIMIT $limit
        OFFSET $offset";

        $orders = DB::select($sql);

        foreach($orders as $order) {
            if($order->status == 'pending') {
                $order->status = '<span class="badge badge-warning">Pending</span>';
                $order->created_at = (new \DateTimeImmutable($order->created_at))->format('l jS F Y \a\t h:i A');
            }

            $action_links = '';
            $view_url = route("orders.show", $order->order_id);
            $action_links .= '<a class="mr-2" href="'.$view_url.'" title="View Bookings"><i class="fas fa-eye text-secondary"></i></a>';
            $order->action_links = $action_links;
        }

        return [
            'recordsTotal' => $totalRecordData,
            'recordsFiltered' => $recordsFiltered,
            'data' => $orders
        ];
    }

    /**
     * Get orders
     * 
     * @param int $page_no
     * @param int $limit
     */
    public static function getOrders($customer_id, $page_no, $limit)
    {
        $limit = $limit;
        $offset = ( $page_no - 1 ) * $limit;

        $sql = "SELECT *, (
            SELECT COUNT(*) FROM jv_order_items
            WHERE order_id = jv_orders.id
            GROUP BY jv_order_items.order_id
        ) AS total_order_items
        FROM jv_orders
        WHERE customer_id = $customer_id
        LIMIT $limit
        OFFSET $offset";

        $orders = DB::select($sql);

        foreach($orders as $order) {            
            // find order items
            $sql = "SELECT 
            jv_order_items.*,
            p.name AS product_name,
            p.slug As product_slug,
            get_image_url(p.image_url) AS product_image_url
            FROM jv_order_items 
            LEFT JOIN jv_product AS p ON p.id = jv_order_items.product_id
            WHERE jv_order_items.order_id = $order->id";

            $order->line_items = DB::select($sql);
        }

        return $orders; 
    }

    /**
     * Get booking details
     * 
     * @param int $booking_order_id
     */
    public static function getBookingDetails($booking_order_id)
    {
        $sql = "SELECT * FROM jv_bookings WHERE uniq_order_id = :uniq_order_id";
        $order = DB::selectOne($sql, ['uniq_order_id' => $booking_order_id]);

        if( !is_null($order) ) {
            // find order items
            $sql = "SELECT 
            i.*,
            s.name AS service_name,
            s.duration AS service_duration,
            s.description AS service_desp,
            get_image_url(s.image) AS service_image
            FROM jv_booking_items AS i
            LEFT JOIN jv_services AS s ON s.id = i.service_id
            WHERE i.order_id = $order->id";

            $order->billing_address = json_decode($order->billing_address);
            $order->shipping_address = json_decode($order->shipping_address);

            $order_items = DB::select($sql);

            $order->line_items = $order_items;

            // find customer
            $sql = "SELECT * FROM users WHERE id = $order->customer_id";

            $order->customer = DB::selectOne($sql);
        }

        return $order;
    }
}
