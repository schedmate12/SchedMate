<?php

namespace App;

use App\Observers\ModuleObserver;
use Illuminate\Database\Eloquent\Model;

class Module extends Model
{

    /* Attributes */

    protected $guarded = ['id'];

    protected static function boot()
    {
        parent::boot();
        static::observe(ModuleObserver::class);
    }

    /* Relations */

    public function permissions()
    {
        return $this->hasMany(Permission::class);
    }

} /* end of class */
