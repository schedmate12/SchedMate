<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class ZoomSetting extends Model
{
    protected $fillable = ['api_key', 'secret_key', 'purchase_code', 'supported_until', 'purchase_code', 'meeting_app'];
}
