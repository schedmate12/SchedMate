<?php

namespace App;

use App\Observers\PageObserver;
use Illuminate\Support\Facades\File;
use Illuminate\Database\Eloquent\Model;

class Page extends Model
{
    protected $appends = [
        'page_image_url'
    ];

    /* Attributes */

    protected static function boot()
    {
        parent::boot();
        static::observe(PageObserver::class);
    }

    /* Accessors */

    public function getPageImageUrlAttribute()
    {
        if(is_null($this->image) || File::exists('user-uploads/page/'.$this->image) == false )
        {
            return asset('img/no-image.jpg');
        }

        return asset_url('page/'.$this->image);
    }

} /* end of class */
