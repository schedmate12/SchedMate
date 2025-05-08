<?php

namespace App;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;
use App\Observers\BookingTimeObserver;
use Illuminate\Support\Facades\Auth;

class BookingTime extends Model
{

    /* Attributes */

    protected $guarded = ['id'];
    private $settings;

    public function __construct()
    {
        parent::__construct();
        $this->settings = CompanySetting::first();
    }

    protected static function boot()
    {
        parent::boot();
        static::observe(BookingTImeObserver::class);
    }

    /* Accessor */

    public function getStartTimeAttribute($value)
    {
        return Carbon::createFromFormat('H:i:s', $value)->setTimezone($this->settings->timezone)->format($this->settings->time_format);
    }

    public function getEndTimeAttribute($value)
    {
        return Carbon::createFromFormat('H:i:s', $value)->setTimezone($this->settings->timezone)->format($this->settings->time_format);
    }

    public function getUtcStartTimeAttribute()
    {
        return Carbon::createFromFormat('H:i:s', $this->attributes['start_time']);
    }

    public function getUtcEndTimeAttribute()
    {
        return Carbon::createFromFormat('H:i:s', $this->attributes['end_time']);
    }

    public function setStartTimeAttribute($value)
    {
        /* @phpstan-ignore-next-line */
        $this->attributes['start_time'] = Carbon::parse($value, $this->locations->timezone->zone_name)->setTimezone('UTC')->format('H:i:s');
    }

    public function setEndTimeAttribute($value)
    {
        /* @phpstan-ignore-next-line */
        $this->attributes['end_time'] = Carbon::parse($value, $this->locations->timezone->zone_name)->setTimezone('UTC')->format('H:i:s');
    }

    public function locations()
    {
        return $this->belongsTo(Location::class, 'location_id', 'id');
    }

} /* end of class */


