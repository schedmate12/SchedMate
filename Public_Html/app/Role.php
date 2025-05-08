<?php

namespace App;

use Laratrust\Models\LaratrustRole;
use Illuminate\Database\Eloquent\Builder;

class Role extends LaratrustRole
{

    /* Attributes */

    protected $guarded = [];

    protected static function boot()
    {
        parent::boot();
        static::addGlobalScope('withoutCustomerRole', function (Builder $builder) {
            $builder->where('name', '<>', 'customer');
        });
    }

    /*  Relations */

    public function getRoleCount()
    {
        return $this->hasMany(User::class);
    }

    /* Accessors */

    public function getMemberCountAttribute()
    {
        return $this->users->count();
    }

    public function employee()
    {
        return $this->belongsToMany(User::class);
    }

} /* end of class */
