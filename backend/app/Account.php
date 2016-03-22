<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Account extends Model
{
    use SoftDeletes;

    protected $fillable = ['owner', 'iban', 'balance'];

    public function client()
    {
      return $this->belongsTo('App\Client');
    }
}
