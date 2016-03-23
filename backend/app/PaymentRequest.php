<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class PaymentRequest extends Model
{
    use SoftDeletes;

    protected $fillable = ['description', 'amount', 'requester_id', 'token', 'confirmed'];

    protected $hidden = ['created_at', 'updated_at', 'deleted_at'];

    public function requester() {
        return $this->belongsTo('App\Client');
    }
}
