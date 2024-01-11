<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ProductRating extends Model
{
    use HasFactory;

    protected $table = 'jv_product_ratings';

    protected $fillable = [
        'product_id',
        'customer_id',
        'review',
        'rating'
    ];
}
