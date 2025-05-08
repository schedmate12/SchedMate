<?php

namespace App;

use App\Observers\LocationObserver;
use Illuminate\Database\Eloquent\Model;

class Location extends Model
{
    /* Attributes */

    protected static function boot()
    {
        parent::boot();
        static::observe(LocationObserver::class);
    }

    /* Relations */

    public function services()
    {
        return $this->hasMany(BusinessService::class);
    }

    public function products()
    {
        return $this->hasMany(Product::class);
    }

    public function deals()
    {
        return $this->belongsToMany(Deal::class);
    }
    
    public function newDeals()
    {
        return $this->belongsToMany(NewDeal::class);
    }

    public function country()
    {
        return $this->belongsTo(Country::class);
    }

    public function timezone()
    {
        return $this->belongsTo(Timezone::class, 'timezone_id');
    }

    public function user()
    {
        return $this->belongsToMany(User::class, 'location_user');
    }

} /* end of class */
