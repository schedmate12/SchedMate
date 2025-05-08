<?php

namespace App;

use App\Observers\BookingObserver;
use Carbon\Carbon;
use DateTime;
use Illuminate\Database\Eloquent\Model;

class Booking extends Model
{
    /* Attributes */
    protected $dates = ['date_time'];
    protected $guarded = ['id'];

    protected static function boot()
    {
        parent::boot();
        static::observe(BookingObserver::class);
    }

    /* Relations */
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function feedback()
    {
        return $this->belongsTo(CustomerFeedback::class);
    }

    public function deal()
    {
        return $this->belongsTo(Deal::class);
    }

    public function users()
    {
        return $this->belongsToMany(User::class);
    }

    public function coupon()
    {
        return $this->belongsTo(Coupon::class);
    }

    public function employees()
    {
        return $this->belongsToMany(User::class, 'employee_id');
    }

    public function items()
    {
        return $this->hasMany(BookingItem::class);
    }

    public function payment()
    {
        return $this->hasOne(Payment::class)->whereNotNull('paid_on');
    }

    public function completedPayment()
    {
        return $this->hasOne(Payment::class)->where('status', 'completed')->whereNotNull('paid_on');
    }

    /* Accessor */
    public function getDateTimeAttribute($value)
    {
        if($this->validateDate($value)){
            return Carbon::createFromFormat('Y-m-d H:i:s', $value, 'UTC')->setTimezone(CompanySetting::first()->timezone)->format(CompanySetting::first()->date_format.' '.CompanySetting::first()->time_format);
        }

        return '';
    }

    public function getTimeAttribute()
    {
        return Carbon::createFromFormat('Y-m-d H:i:s', $this->attributes['date_time'], 'UTC')->setTimezone(CompanySetting::first()->timezone)->format(CompanySetting::first()->time_format);
    }

    public function getDateAttribute()
    {
        return Carbon::createFromFormat('Y-m-d H:i:s', $this->attributes['date_time'], 'UTC')->setTimezone(CompanySetting::first()->timezone)->format(CompanySetting::first()->date_format);
    }

    public function getUtcDateTimeAttribute()
    {
        return Carbon::createFromFormat('Y-m-d H:i:s', $this->attributes['date_time']);
    }

    /* Mutator */
    public function setDateTimeAttribute($value)
    {
        $this->attributes['date_time'] = Carbon::parse($value, CompanySetting::first()->timezone)->setTimezone('UTC');
    }

    /* Validations */

    public function validateDate($date, $format = 'Y-m-d H:i:s')
    {
        $d = DateTime::createFromFormat($format, $date);
        return $d && $d->format($format) == $date;
    }

    public function amountPaid()
    {
        $payment = Payment::where('booking_id', $this->id)->where('status', 'completed')->sum('amount_paid');

        if ($payment) {
            return $payment;
        }

        return 0;
    }

    public function amountDue()
    {
        $paidAmount = Payment::where('booking_id', $this->id)->where('status', 'completed')->sum('amount_paid');
        $totalAmount = $this->amount_to_pay;

        $remainingAmount = $totalAmount - $paidAmount;

        if($remainingAmount < 0){
            return 0;
        }
        else{
            return $remainingAmount;
        }

    }

    public function bookingPayments()
    {
        return $this->hasMany(Payment::class);
    }

} /* end of class */
