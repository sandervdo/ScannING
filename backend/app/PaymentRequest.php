<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class PaymentRequest extends Model
{
    use SoftDeletes;

    protected $fillable = ['description', 'amount', 'requester', 'token'];
}
