<?php

namespace App;

use App\Observers\CategoryObserver;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\File;

class Category extends Model
{

    /* Attributes */

    protected static function boot()
    {
        parent::boot();
        static::observe(CategoryObserver::class);
    }

    protected $guarded = ['id'];

    protected $appends = [
        'category_image_url'
    ];

    /* Relations */

    public function services()
    {
        return $this->hasMany(BusinessService::class);
    }

    /* Scopes */

    public function scopeActive($query)
    {
        return $query->where('status', 'active');
    }

    /* Accessors */

    public function getCategoryImageUrlAttribute()
    {
        if(is_null($this->image) || File::exists('user-uploads/category/'.$this->image) == false )
        {
            return asset('img/no-image.jpg');
        }

        return asset_url('category/'.$this->image);
    }

} /* end of class */
