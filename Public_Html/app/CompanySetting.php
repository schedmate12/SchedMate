<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use App\Observers\CompanySettingObserver;

class CompanySetting extends Model
{

    /* Attributes */

    protected $appends = [
        'logo_url',
        'formatted_phone_number',
        'formatted_address',
        'formatted_website'
    ];

    protected static function boot()
    {
        parent::boot();

        static::observe(CompanySettingObserver::class);

    }

    /* Relations */

    public function currency()
    {
        return $this->belongsTo(Currency::class);
    }

    /* Accessors */

    public function getLogoUrlAttribute()
    {
        if (is_null($this->logo)) {
            return asset('img/logo.png');
        }

        return asset_url('logo/' . $this->logo);
    }

    public function getFormattedPhoneNumberAttribute()
    {
        return $this->phoneNumberFormat($this->company_phone);
    }

    public function getFormattedAddressAttribute()
    {
        return nl2br(str_replace('\\r\\n', "\r\n", $this->address));
    }

    public function getFormattedWebsiteAttribute()
    {
        return preg_replace('/^https?:\/\//', '', $this->website);
    }

    /* Formats */
    public function phoneNumberFormat($number)
    {
        // Allow only Digits, remove all other characters.
        $number = preg_replace('/[^\d]/', '', $number);

        // get number length.
        $length = strlen($number);

        // if number = 10
        if ($length == 10) {

            if (preg_match('/^1?(\d{3})(\d{3})(\d{4})$/', $number, $matches)) {
                $result = $matches[1] . '-' . $matches[2] . '-' . $matches[3];
                return $result;
            }
        }

        return $number;
    }

} /* end of class */
