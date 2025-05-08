<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class FrontThemeSetting extends Model
{
    /* Accessors */

    public function getLogoUrlAttribute()
    {
        if(is_null($this->logo)) {
            return asset('img/logo.png');
        }

        return asset_url('front-logo/'.$this->logo);
    }

    public function getFaviconUrlAttribute()
    {
        if(is_null($this->favicon)){
            return asset('favicon/apple-icon-57x57.png');
        }
        
        return asset_url('favicon/'.$this->favicon);
    }

} /* end of class */
