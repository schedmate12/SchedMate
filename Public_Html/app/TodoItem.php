<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class TodoItem extends Model
{
    /* Relations */

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    /* Scopes */

    public function scopeStatus($query, $status)
    {
        return $query->where('status', $status);
    }

} /* end of class */
