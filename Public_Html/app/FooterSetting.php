<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class FooterSetting extends Model
{
    protected $guarded = ['id'];

    protected $casts = [
        'social_links' => 'array'
    ];
}
