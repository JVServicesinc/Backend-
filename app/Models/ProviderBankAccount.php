<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ProviderBankAccount extends Model
{
    use HasFactory;

    /**
     * The table associated with the model.
     *
     * @var string
     */
    protected $table = 'provider_bank_accounts';

    protected $fillable = ['user_id', 'bank_name', 'account_number', 'ifsc_code', 'transit_no', 'institution_no'];
}
