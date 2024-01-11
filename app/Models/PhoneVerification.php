<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class PhoneVerification extends Model
{
    use HasFactory;

    protected $fillable = [
        'country_code',
        'contact_number',
        'token'
    ];

    public static function getExistingPhoneVerification($contact_number){
        return PhoneVerification::where([
            'contact_number' => $contact_number
        ])->first();
    }
}
