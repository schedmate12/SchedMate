<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class TaxSetting extends Model
{
    /* Attributes */

    protected $guarded = ['id'];

    public function scopeActive($query)
    {
        return $query->where('status', 'active');
    }

} /* end of class */
