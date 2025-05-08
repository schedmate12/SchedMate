<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class ItemTax extends Model
{

    public function taxes()
    {
        return $this->belongsToMany(Tax::class);
    }

    public function tax()
    {
        return $this->belongsTo(Tax::class);
    }

}
