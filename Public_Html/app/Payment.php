<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Payment extends Model
{
    /* Attributes */

    protected $dates = ['paid_on'];

    public function booking()
    {
        return $this->belongsTo(Booking::class, 'booking_id');
    }

} /* end of class  */
