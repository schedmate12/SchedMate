<?php

namespace App;

use App\Observers\ProductObserver;
use Illuminate\Support\Facades\File;
use Illuminate\Database\Eloquent\Model;

class Product extends Model
{
    /* Attributes */

    protected static function boot()
    {
        parent::boot();
        static::observe(ProductObserver::class);
    }

    protected $appends = [
        'product_image_url',
        'discounted_price'
    ];

    public function location()
    {
        return $this->belongsTo(Location::class);
    }

    public function items()
    {
        return $this->hasMany(BookingItem::class);
    }

    public function productTaxes()
    {
        return $this->hasMany(ItemTax::class, 'product_id', 'id');
    }

    /* Scopes */

    public function scopeActive($query)
    {
        return $query->where('status', 'active');
    }

    /* Accessors */

    public function getProductImageUrlAttribute()
    {
        if(is_null($this->default_image) || File::exists('user-uploads/product/'.$this->id.'/'.$this->default_image) == false ) {
            return asset('img/no-image.jpg');
        }

        return asset_url('product/'.$this->id.'/'.$this->default_image);
    }

    public function getImageAttribute($value)
    {
        if (is_array(json_decode($value, true))) {
            return json_decode($value, true);
        }

        return $value;
    }

    public function getDiscountedPriceAttribute()
    {
        if($this->discount > 0){
            if($this->discount_type == 'fixed'){
                return ($this->price - $this->discount);
            }
            elseif($this->discount_type == 'percent'){
                $discount = (($this->discount / 100) * $this->price);
                return round(($this->price - $discount), 2);
            }
        }

        return $this->price;
    }

    public function getTotalTaxPercentAttribute()
    {
        if (!$this->productTaxes) {
            return 0;
        }

        $taxPercent = 0;

        foreach ($this->productTaxes as $key => $tax) {
            $taxPercent += $tax->tax->percent;
        }

        return $taxPercent;
    }

}
