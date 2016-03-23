<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Client extends Model
{
    use SoftDeletes;

    protected $fillable = ['name', 'account_id', 'avatar'];

    protected $hidden = ['created_at', 'updated_at', 'deleted_at'];

    public function account()
    {
      return $this->hasOne('App\Account', 'id', 'account_id');
    }
}
