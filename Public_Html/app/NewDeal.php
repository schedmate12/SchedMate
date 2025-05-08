<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class NewDeal extends Model
{
    protected $fillable = ['image','location_id','link','status'];

    protected $appends = [
        'new_deal_image_url'
    ];

    public function location()
    {
        return $this->belongsTo(Location::class);
    }

    /* Accessors */

    public function getNewDealImageUrlAttribute()
    {
        if (!$this->image) {
            return asset('img/no-image.jpg');
        }

        return asset_url('newDeal/' . $this->image);

    }

}
