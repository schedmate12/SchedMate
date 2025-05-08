<?php

namespace App;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;

class AdvertisementBanner extends Model
{
    private $settings;

    public function __construct()
    {
        parent::__construct();
        $this->settings = CompanySetting::first();
    }

    protected $appends = [
        'advertisement_image_url'
    ];

    public function setStartDateTimeAttribute($value)
    {
        $this->attributes['start_date_time'] = Carbon::createFromFormat('Y-m-d H:i a', $value, $this->settings->timezone)->setTimezone('UTC')->format('Y-m-d H:i:s');
    }

    public function setEndDateTimeAttribute($value)
    {
        $this->attributes['end_date_time'] = Carbon::createFromFormat('Y-m-d H:i a', $value, $this->settings->timezone)->setTimezone('UTC')->format('Y-m-d H:i:s');
    }

    public function getStartDateTimeAttribute($value)
    {
        $date = Carbon::createFromFormat('Y-m-d H:i:s', $value, 'UTC')->setTimezone($this->settings->timezone)->format($this->settings->date_format.' '.$this->settings->time_format);

        return $date;
    }

    public function getEndDateTimeAttribute($value)
    {
        $date = Carbon::createFromFormat('Y-m-d H:i:s', $value, 'UTC')->setTimezone($this->settings->timezone)->format($this->settings->date_format.' '.$this->settings->time_format);

        return $date;
    }

    /* Accessors */

    public function getAdvertisementImageUrlAttribute()
    {
        if(is_null($this->image)){
            return asset('img/no-image.jpg');
        }

        return asset_url('advertisementBanner/'.$this->image);
    }

}
