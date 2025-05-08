<?php

namespace App;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;
use DateTime;

class EmployeeSchedules extends Model
{
    private $settings;

    public function __construct()
    {
        parent::__construct();
        $this->settings = CompanySetting::first();
    }

    protected $dates = ['start_time', 'end_time'];

    public function employee()
    {
        return $this->belongsTo(User::class);
    }

    public function getStartTimeAttribute($value)
    {
        if($this->validateDate($value)){
            return Carbon::createFromFormat('H:i:s', $value)->setTimezone(CompanySetting::first()->timezone);
        }

        return '';
    }

    public function getEndTimeAttribute($value)
    {
        if($this->validateDate($value)){
            return Carbon::createFromFormat('H:i:s', $value)->setTimezone(CompanySetting::first()->timezone);
        }

        return '';
    }

    public function getLocationStartTimeAttribute()
    {
        /* @phpstan-ignore-next-line */
        return Carbon::createFromFormat('H:i:s', $this->attributes['start_time'])->setTimezone($this->location->timezone->zone_name);
    }

    public function getLocationEndTimeAttribute()
    {
        /* @phpstan-ignore-next-line */
        return Carbon::createFromFormat('H:i:s', $this->attributes['end_time'])->setTimezone($this->location->timezone->zone_name);
    }

    public function getUtcStartTimeAttribute()
    {
        return Carbon::createFromFormat('H:i:s', $this->attributes['start_time']);
    }

    public function getUtcEndTimeAttribute()
    {
        return Carbon::createFromFormat('H:i:s', $this->attributes['end_time']);
    }
    
    /* Mutator */

    public function validateDate($format = 'H:i:s')
    {
        $d = DateTime::createFromFormat('H:i:s', $format);
        return $d && $d->format($format);
    }

    public function location()
    {
        return $this->belongsTo(Location::class, 'location_id', 'id');
    }

}
