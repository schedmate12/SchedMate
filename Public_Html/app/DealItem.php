<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class DealItem extends Model
{
    /* Relations */

    public function businessService()
    {
        return $this->belongsTo(BusinessService::class);
    }

    public function deal()
    {
        return $this->belongsTo(Deal::class);
    }

} /* end of class  */
