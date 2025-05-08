<?php

namespace App; 

use Illuminate\Database\Eloquent\Model;

class ServiceReview extends Model
{
    protected $fillable = [
        'booking_id', 'user_id', 'service_id', 'rating', 'review_text'
    ];

    public function booking()
    {
        return $this->belongsTo(Booking::class);
    }

    public function service()
    {
        return $this->belongsTo(BusinessService::class, 'service_id');
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
