<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Support\Facades\DB;

class Coupon extends Model
{
    use HasFactory, SoftDeletes;

    protected $table = 'coupons';
    protected $dates = ['deleted_at'];
    protected $fillable = [
        'code', 'image', 'discount_type', 'discount', 'expire_date', 'desp'
    ];
    
    protected $casts = [
        'discount'  => 'double',
        'status'    => 'integer',
    ];

    public static function getCoupons()
    {
        $sql = "SELECT 
            *,
            get_image_url(image) AS image_url
        FROM coupons
        WHERE deleted_at IS NULL";

        return DB::select($sql);
    }
}
