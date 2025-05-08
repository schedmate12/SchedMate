<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Coupon extends Model
{

    /* Attributes */

    protected $dates = ['start_date_time', 'end_date_time', 'created_at'];

    /* Relations */

    public function customers()
    {
        return $this->hasMany(CouponUser::class, 'coupon_id');
    }

    /* Scopes */

    public function scopeActive($query)
    {
        return $query->where('status', 'active');
    }

} /* end of class */
