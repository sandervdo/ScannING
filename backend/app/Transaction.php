<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Transaction extends Model
{
    use SoftDeletes;

    protected $fillable = ['description', 'amount', 'requester_id', 'token', 'balance', 'confirmed'];

    public function requester() {
        return $this->belongsTo('App\Client', 'requester_id');
    }

}
