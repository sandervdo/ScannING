<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Account extends Model
{
    use SoftDeletes;

    protected $fillable = ['owner', 'iban', 'balance'];

    protected $hidden = ['created_at', 'updated_at', 'deleted_at'];

    public function client()
    {
        return $this->hasOne('App\Client', 'account_id');
    }
}
