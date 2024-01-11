<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class UserAddress extends Model
{
    use HasFactory;

    /**
     * The table associated with the model.
     *
     * @var string
     */
    protected $table = 'user_address';

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'user_id',
        'first_name',
        'last_name',
        'company_name',
        'country_name',
        'street_address',
        'city',
        'province',
        'zip_code',
        'country_code',
        'phone',
        'email',
        'additional_information',
        'locality',
        'landmark',
        'landmark_type',
        'apartment'
    ];
}
