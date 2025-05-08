<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Membership extends Model
{ 
    protected $fillable = [
        'name', 'price', 'duration_days', 'discount_percent', 'description','status'
    ];
}