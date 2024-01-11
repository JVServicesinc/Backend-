<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;

class ProductGallery extends Model
{
    use HasFactory;

    protected $table = 'jv_product_gallery';

    /**
     * Add product gallery image
     * 
     * @param array $data
     * @param int $product_id
     */
    public static function addProuctGallery($images, $product_id)
    {
        foreach($images as $image) {
            $fileName = uniqid() . '.' . $image->getClientOriginalExtension();
            $image->move(public_path('uploads/product-gallery'), $fileName);
            DB::table('jv_product_gallery')->insert([
                'product_id' => $product_id,
                'image_url'  => $fileName
            ]);
        }
    }
}
