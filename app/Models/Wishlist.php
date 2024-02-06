<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;

class Wishlist extends Model
{
    use HasFactory;

    protected $table = "jv_wishlist";

    protected $fillable = [
        'customer_id', 'type', 'ref_id'
    ];

    public static function getWishlists($type, $customer_id)
    {
        if($type == 'product') {
            $sql = "SELECT w.id AS wishlist_id, p.*
            FROM jv_wishlist AS w
            INNER JOIN jv_product AS p ON p.id = w.ref_id
            WHERE w.customer_id =  $customer_id AND w.type = 'product'";

            $products = DB::select($sql);

            foreach($products as $product) {
                $product->image_url = asset('public/uploads/products/'.$product->image_url);
            }

            return $products;
        }

        if( $type == 'service' ) {

        }
    }
}
