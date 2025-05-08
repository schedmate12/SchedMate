<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use App\Observers\BookingItemObserver;

class BookingItem extends Model
{
    protected $guarded = ['id'];

    protected static function boot()
    {
        parent::boot();
        static::observe(BookingItemObserver::class);
    }

    /* Relations */

    public function businessService()
    {
        return $this->belongsTo(BusinessService::class);
    }

    public function product()
    {
        return $this->belongsTo(Product::class);
    }

    public function booking()
    {
        return $this->belongsTo(Booking::class);
    }

} /* end of class */
