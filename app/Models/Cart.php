<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;
use App\Models\Product;

class Cart extends Model
{
    use HasFactory;

    /**
     * Save cart item slot
     * 
     * @return bool
     */
    public static function saveServiceCartItemSlot($cart_id, $cart_item_id, $post_data)
    {
        // dd($post_data);

        return DB::table('jv_customer_cart_service_items')->where([
            'id' => $cart_item_id
        ])->update([
            'weekday_number' => $post_data['weekday_number'],
            'timing' => $post_data['timing']
        ]);
    }

    public static function addCartItemAuth($post_data)
    {
        $uniq_cart_id = bin2hex(random_bytes(20));
        global $userData;

        // check any cart id exist or not
        $sql = "SELECT * FROM jv_customer_cart WHERE customer_id = $userData->id";
        $existing_cart = DB::selectOne($sql);

        if ($post_data['item_type'] == 'product') {

            if (!is_null($existing_cart)) {
                $uniq_cart_id = $existing_cart->uniq_cart_id;

                // check prev cart what product or not
                if ($existing_cart->item_type != 'product') {
                    // remove all from service item and update to product
                    DB::table('jv_customer_cart')->where(['id' => $existing_cart->id])->update(['item_type' => 'product']);

                    $sql = "DELETE FROM jv_customer_cart_service_items WHERE cart_id = $existing_cart->id";
                    DB::statement($sql);
                }

                $product = Product::getProductBySku($post_data['product_sku']);

                // check item exist then update the qty else insert item
                $sql = "SELECT c_i.*
                FROM jv_customer_cart_items AS c_i
                INNER JOIN jv_customer_cart AS c ON c.id = c_i.cart_id
                WHERE c.uniq_cart_id = :uniq_cart_id AND c_i.product_sku = :product_sku";

                $item = DB::selectOne($sql, ['uniq_cart_id' => $existing_cart->uniq_cart_id, 'product_sku' => $post_data['product_sku']]);

                if (!is_null($item)) {
                    // update the qty only
                    DB::table('jv_customer_cart_items')->where([
                        'cart_id' => $item->cart_id,
                        'product_sku' => $item->product_sku
                    ])->update([
                        'qty' => $item->qty + $post_data['product_qty']
                    ]);
                } else {
                    DB::table('jv_customer_cart_items')->insert([
                        'cart_id' => $existing_cart->id,
                        'product_id' => $product->id,
                        'product_sku' => $post_data['product_sku'],
                        'qty'         => $post_data['product_qty'],
                        'unit_price'  => $post_data['product_price']
                    ]);
                }
            } else {
                $cart_id = DB::table('jv_customer_cart')->insertGetId([
                    'uniq_cart_id' => $uniq_cart_id,
                    'customer_id'  => $userData->id,
                    'customer_lat' => $post_data['customer_lat'],
                    'customer_lng' => $post_data['customer_lng'],
                    'item_type'    => $post_data['item_type']
                ]);

                // now add cart item
                $product = Product::getProductBySku($post_data['product_sku']);

                DB::table('jv_customer_cart_items')->insert([
                    'cart_id' => $cart_id,
                    'product_id' => $product->id,
                    'product_sku' => $post_data['product_sku'],
                    'qty'         => $post_data['product_qty'],
                    'unit_price'  => $post_data['product_price']
                ]);
            }
        } else {
            if (!is_null($existing_cart)) {
                $uniq_cart_id = $existing_cart->uniq_cart_id;

                // check prev cart what service or not
                if ($existing_cart->item_type != 'service') {
                    // remove all from product item and update to service
                    DB::table('jv_customer_cart')->where(['id' => $existing_cart->id])->update(['item_type' => 'service']);

                    $sql = "DELETE FROM jv_customer_cart_items WHERE cart_id = $existing_cart->id";
                    DB::statement($sql);
                }

                // check item exist then update the qty else insert item
                $sql = "SELECT c_i.*
                FROM jv_customer_cart_service_items AS c_i
                INNER JOIN jv_customer_cart AS c ON c.id = c_i.cart_id
                WHERE c.uniq_cart_id = :uniq_cart_id AND c_i.service_id = :service_id";

                $item = DB::selectOne($sql, ['uniq_cart_id' => $existing_cart->uniq_cart_id, 'service_id' => $post_data['service_id']]);

                if (!is_null($item)) {
                    // update the qty only
                    DB::table('jv_customer_cart_service_items')->where([
                        'cart_id' => $item->cart_id,
                        'service_id' => $item->service_id
                    ])->update([
                        'qty' => $item->qty + $post_data['qty']
                    ]);
                } else {
                    DB::table('jv_customer_cart_service_items')->insert([
                        'cart_id' => $existing_cart->id,
                        'service_id' => $post_data['service_id'],
                        'qty' => $post_data['qty'],
                        'unit_price'         => $post_data['unit_price']
                    ]);
                }
            } else {
                $cart_id = DB::table('jv_customer_cart')->insertGetId([
                    'uniq_cart_id' => $uniq_cart_id,
                    'customer_id'  => $userData->id,
                    'customer_lat' => $post_data['customer_lat'],
                    'customer_lng' => $post_data['customer_lng'],
                    'item_type'    => $post_data['item_type']
                ]);

                DB::table('jv_customer_cart_service_items')->insert([
                    'cart_id' => $cart_id,
                    'service_id' => $post_data['service_id'],
                    'qty' => $post_data['qty'],
                    'unit_price'         => $post_data['unit_price']
                ]);
            }
        }

        return $uniq_cart_id;
    }

    /**
     * Add item to the cart
     * 
     * @param array $post_data
     */
    public static function addCartItem($post_data)
    {
        $uniq_cart_id = bin2hex(random_bytes(20));

        $cart_id = DB::table('jv_customer_cart')->insertGetId([
            'uniq_cart_id' => $uniq_cart_id,
            'customer_lat' => $post_data['customer_lat'],
            'customer_lng' => $post_data['customer_lng'],
            'item_type'    => $post_data['item_type']
        ]);

        if ($post_data['item_type'] == 'product') {
            // now add cart item
            $product = Product::getProductBySku($post_data['product_sku']);

            DB::table('jv_customer_cart_items')->insert([
                'cart_id' => $cart_id,
                'product_id' => $product->id,
                'product_sku' => $post_data['product_sku'],
                'qty'         => $post_data['product_qty'],
                'unit_price'  => $post_data['product_price']
            ]);
        } else {
            DB::table('jv_customer_cart_service_items')->insert([
                'cart_id' => $cart_id,
                'service_id' => $post_data['service_id'],
                'qty' => $post_data['qty'],
                'unit_price'         => $post_data['unit_price']
            ]);
        }

        return $uniq_cart_id;
    }

    public static function updateCartItem($post_data, $cart_id)
    {
        // find cart
        $sql = "SELECT * FROM jv_customer_cart WHERE uniq_cart_id = :uniq_cart_id";
        $cart = DB::selectOne($sql, ['uniq_cart_id' => $cart_id]);

        DB::transaction(function () use ($cart, $post_data, $cart_id) {
            if ($post_data['item_type'] == 'product') {
                // remove any product if exist
                $sql = "DELETE FROM jv_customer_cart_service_items WHERE cart_id = $cart->id";
                DB::statement($sql);

                DB::table('jv_customer_cart')->where(['uniq_cart_id' => $cart_id])->update([
                    'item_type' => 'product'
                ]);

                // check exist it cart or not
                $sql = "SELECT c_i.*
                    FROM jv_customer_cart_items AS c_i
                    INNER JOIN jv_customer_cart AS c ON c.id = c_i.cart_id
                    WHERE c.uniq_cart_id = :uniq_cart_id AND c_i.product_sku = :product_sku";

                $item = DB::selectOne($sql, ['uniq_cart_id' => $cart_id, 'product_sku' => $post_data['product_sku']]);

                if (!is_null($item)) {
                    // update the qty only

                    if ($post_data['product_qty'] == 0) {
                        DB::table('jv_customer_cart_items')->where([
                            'cart_id' => $cart->id,
                            'product_sku' => $item->product_sku
                        ])->delete();
                    } else {
                        DB::table('jv_customer_cart_items')->where([
                            'cart_id' => $cart->id,
                            'product_sku' => $item->product_sku
                        ])->update([
                            'qty' => $post_data['product_qty']
                        ]);
                    }
                } else {
                    // add new cart item
                    $product = Product::getProductBySku($post_data['product_sku']);

                    DB::table('jv_customer_cart_items')->insert([
                        'cart_id' => $cart->id,
                        'product_id' => $product->id,
                        'product_sku' => $post_data['product_sku'],
                        'qty'         => $post_data['product_qty'],
                        'unit_price'  => $post_data['product_price']
                    ]);
                }
            } else {

                // remove any product if exist
                $sql = "DELETE FROM jv_customer_cart_items WHERE cart_id = $cart->id";
                DB::statement($sql);

                DB::table('jv_customer_cart')->where(['uniq_cart_id' => $cart_id])->update([
                    'item_type' => 'service'
                ]);

                // check item exist in the cart or not
                $sql = "SELECT c_i.* 
                FROM jv_customer_cart_service_items AS c_i
                INNER JOIN jv_customer_cart AS c ON c.id = c_i.cart_id
                WHERE c.uniq_cart_id = :uniq_cart_id AND c_i.service_id = :service_id";

                $item = DB::selectOne($sql, ['uniq_cart_id' => $cart_id, 'service_id' => $post_data['service_id']]);

                if (!is_null($item)) {
                    // check qty
                    if ($post_data['qty'] == 0) {
                        DB::table('jv_customer_cart_service_items')->where([
                            'cart_id' => $cart->id,
                            'service_id' => $post_data['service_id']
                        ])->delete();
                    } else {
                        DB::table('jv_customer_cart_service_items')->where([
                            'cart_id' => $cart->id,
                            'service_id' => $post_data['service_id']
                        ])->update([
                            'qty' => $post_data['qty']
                        ]);
                    }
                } else {
                    DB::table('jv_customer_cart_service_items')->insert([
                        'cart_id' => $cart->id,
                        'service_id' => $post_data['service_id'],
                        'qty' => $post_data['qty'],
                        'unit_price'         => $post_data['unit_price']
                    ]);
                }
            }
        });
    }

    /**
     * Get cart items
     * 
     * @param string $uniq_cart_id
     * @return object
     */
    public static function getCartItems($uniq_cart_id)
    {
        $sql = "SELECT id, uniq_cart_id AS cart_id, customer_id, customer_lat, customer_lng, item_type 
        FROM jv_customer_cart
        WHERE uniq_cart_id = :uniq_cart_id";

        $cart = DB::selectOne($sql, ['uniq_cart_id' => $uniq_cart_id]);

        if (!is_null($cart)) {

            if ($cart->item_type == 'product') {
                $sql = "SELECT 
                c_i.id AS cart_item_id,
                c_i.product_id,
                c_i.product_sku,
                c_i.qty,
                c_i.unit_price,
                (c_i.qty * c_i.unit_price) AS line_amount,
                p.name,
                p.slug,
                p.image_url
                FROM jv_customer_cart_items AS c_i
                INNER JOIN jv_product AS p ON p.sku = c_i.product_sku
                WHERE c_i.cart_id = $cart->id";

                $items = DB::select($sql);

                if (!empty($items)) {
                    foreach ($items as $item) {
                        $item->image_url = env('IMAGEKIT_URL_ENDPOINT') . $item->image_url;
                    }

                    $cart->items = $items;

                    // find cart subtotal
                    $sql = "SELECT IFNULL(SUM(i.qty * i.unit_price), 0) AS subtotal 
                    FROM jv_customer_cart_items i
                    INNER JOIN jv_customer_cart c ON c.id = i.cart_id
                    WHERE c.id = $cart->id
                    GROUP BY i.cart_id";

                    $result = DB::selectOne($sql);

                    $subtotal = $result->subtotal;

                    $cart->subtotal = $subtotal;
                    $cart->convenience_fee = round($subtotal * (21 / 100), 2);
                    $cart->taxes = [
                        'gst' => round(($cart->subtotal +  $cart->convenience_fee) * (5 / 100), 2),
                        'qst' => round(($cart->subtotal +  $cart->convenience_fee) * (9.975 / 100), 2)
                    ];

                    $cart->total = round($cart->subtotal +  $cart->convenience_fee + $cart->taxes['gst'] + $cart->taxes['qst'], 2);
                } else {
                    $cart->items = [];
                }
            } else {
                $sql = "SELECT
                    c_i.id,
                    c_i.id AS cart_item_id,
                    c_i.service_id,
                    c_i.qty,
                    c_i.unit_price,
                    c_i.weekday_number,
                    CASE
                        WHEN c_i.weekday_number = 6 THEN 'Sunday'
                        WHEN c_i.weekday_number = 0 THEN 'Monday'
                        WHEN c_i.weekday_number = 1 THEN 'Tuesday'
                        WHEN c_i.weekday_number = 2 THEN 'Wednesday'
                        WHEN c_i.weekday_number = 3 THEN 'Thursday'
                        WHEN c_i.weekday_number = 4 THEN 'Friday'
                        WHEN c_i.weekday_number = 5 THEN 'Saturday'
                    END  AS weeekday_name,
                    c_i.timing,
                    s.name AS service_name,
                    s.duration AS service_duration,
                    s.image
                FROM jv_customer_cart_service_items AS c_i
                INNER JOIN jv_services AS s ON s.id = c_i.service_id
                WHERE c_i.cart_id = $cart->id";

                $items = DB::select($sql);

                if (!empty($items)) {
                    // find media urls for services
                    foreach ($items as $item) {
                        $item->image_url = env('IMAGEKIT_URL_ENDPOINT') . $item->image;
                    }

                    $cart->items = $items;

                    // find cart subtotal
                    $sql = "SELECT IFNULL(SUM(i.qty * i.unit_price), 0) AS subtotal 
                    FROM jv_customer_cart_service_items i
                    INNER JOIN jv_customer_cart c ON c.id = i.cart_id
                    WHERE c.id = $cart->id
                    GROUP BY i.cart_id";

                    $result = DB::selectOne($sql);

                    if (!is_null($result)) {
                        $subtotal = $result->subtotal;
                    } else {
                        $subtotal = 0;
                    }

                    $cart->subtotal = $subtotal;
                    $cart->convenience_fee = round($subtotal * (21 / 100), 2);
                    $cart->taxes = [
                        'gst' => round(($cart->subtotal +  $cart->convenience_fee) * (5 / 100), 2),
                        'qst' => round(($cart->subtotal +  $cart->convenience_fee) * (9.975 / 100), 2)
                    ];

                    $cart->total = round($cart->subtotal +  $cart->convenience_fee + $cart->taxes['gst'] + $cart->taxes['qst'], 2);
                } else {
                    $cart->items = [];
                }
            }
        }

        return $cart;
    }

    /**
     * Sync user cart
     * 
     * @param string $uniq_cart_id
     */
    public static function syncUserCart($uniq_cart_id)
    {
        global $userData;
        $customer_id = $userData->id;

        // check if any cart exist for 
        $sql = "SELECT * FROM jv_customer_cart WHERE customer_id = $customer_id";
        $existing_cart = DB::selectOne($sql);
        if (!is_null($existing_cart)) {

            // current cart item
            $sql = "SELECT * FROM jv_customer_cart WHERE uniq_cart_id = :uniq_cart_id";
            $current_cart = DB::selectOne($sql, ['uniq_cart_id' => $uniq_cart_id]);

            if ($current_cart->item_type == 'product' && $existing_cart->item_type == 'service') {
                // delete service one
                $sql = "DELETE FROM jv_customer_cart WHERE uniq_cart_id = :uniq_cart_id";
                DB::statement($sql, ['uniq_cart_id' => $existing_cart->uniq_cart_id]);

                return DB::table('jv_customer_cart')->where(['uniq_cart_id' => $current_cart->uniq_cart_id])->update([
                    'customer_id' => $customer_id
                ]);
            } else if ($current_cart->item_type == 'service' && $existing_cart->item_type == 'product') {
                // delete product one
                $sql = "DELETE FROM jv_customer_cart WHERE uniq_cart_id = :uniq_cart_id";
                DB::statement($sql, ['uniq_cart_id' => $existing_cart->uniq_cart_id]);

                return DB::table('jv_customer_cart')->where(['uniq_cart_id' => $current_cart->uniq_cart_id])->update([
                    'customer_id' => $customer_id
                ]);
            } else if ($current_cart->item_type == 'product' && $existing_cart->item_type == 'product') {

                // find current items which are not exit in old cart item
                $merged_items = DB::select("call merge_user_cart_product($existing_cart->id, $current_cart->id)");

                DB::transaction(function () use ($customer_id, $uniq_cart_id, $merged_items) {
                    // delete old one
                    $sql = "DELETE FROM jv_customer_cart WHERE customer_id = $customer_id";
                    DB::statement($sql);

                    // find current cart item
                    $sql = "SELECT * FROM jv_customer_cart WHERE uniq_cart_id = :uniq_cart_id";
                    $cart = DB::selectOne($sql, ['uniq_cart_id' => $uniq_cart_id]);

                    // delete current hash item
                    $sql = "DELETE FROM jv_customer_cart_items WHERE cart_id = $cart->id";
                    DB::statement($sql);

                    DB::table('jv_customer_cart')->where(['uniq_cart_id' => $uniq_cart_id])->update([
                        'customer_id' => $customer_id
                    ]);

                    foreach ($merged_items as $item) {
                        DB::table('jv_customer_cart_items')->insert([
                            'cart_id' => $cart->id,
                            'product_id' => $item->product_id,
                            'product_sku' => $item->product_sku,
                            'qty'         => $item->product_qty,
                            'unit_price'  => $item->unit_price
                        ]);
                    }
                });
            } else {

                // find current items which are not exit in old cart item
                $merged_items = DB::select("call merge_user_cart_service($existing_cart->id, $current_cart->id)");

                DB::transaction(function () use ($customer_id, $uniq_cart_id, $merged_items) {
                    // delete old one
                    $sql = "DELETE FROM jv_customer_cart WHERE customer_id = $customer_id";
                    DB::statement($sql);

                    // find current cart item
                    $sql = "SELECT * FROM jv_customer_cart WHERE uniq_cart_id = :uniq_cart_id";
                    $cart = DB::selectOne($sql, ['uniq_cart_id' => $uniq_cart_id]);

                    // delete current hash item
                    $sql = "DELETE FROM jv_customer_cart_service_items WHERE cart_id = $cart->id";
                    DB::statement($sql);

                    DB::table('jv_customer_cart')->where(['uniq_cart_id' => $uniq_cart_id])->update([
                        'customer_id' => $customer_id
                    ]);

                    foreach ($merged_items as $item) {
                        DB::table('jv_customer_cart_service_items')->insert([
                            'cart_id' => $cart->id,
                            'service_id' => $item->service_id,
                            'qty'         => $item->item_qty,
                            'unit_price'  => $item->unit_price
                        ]);
                    }
                });
            }
        } else {
            return DB::table('jv_customer_cart')->where(['uniq_cart_id' => $uniq_cart_id])->update([
                'customer_id' => $customer_id
            ]);
        }
    }

    /**
     * Remove cart item
     * 
     * @param string $uniq_cart_id
     * @param int $cart_item_id
     */
    public static function removeCartItem($uniq_cart_id, $cart_item_id)
    {
        // find cart
        $sql = "SELECT * FROM jv_customer_cart WHERE uniq_cart_id =:uniq_cart_id";
        $cart = DB::selectOne($sql, ['uniq_cart_id' => $uniq_cart_id]);

        if ($cart->item_type == 'product') {
            return DB::table('jv_customer_cart_items')->delete($cart_item_id);
        } else {
            return DB::table('jv_customer_cart_service_items')->delete($cart_item_id);
        }
    }
}
