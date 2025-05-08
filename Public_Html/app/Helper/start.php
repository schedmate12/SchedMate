<?php

use App\CompanySetting;
use Illuminate\Support\Str;
use App\CurrencyFormatSetting;

if (!function_exists('asset_url')) {

    // @codingStandardsIgnoreLine
    function asset_url($path)
    {
        $path = 'user-uploads/' . $path;
        $storageUrl = $path;

        if (!Str::startsWith($storageUrl, 'http')) {
            return url($storageUrl);
        }

        return $storageUrl;
    }

}

// Format currency
if (!function_exists('currencyFormatter')) {

    function currencyFormatter($amount=0)
    {

        $formats = currencyFormatSetting();
        $currency_symbol = globalSetting()->currency->currency_symbol;

        $currency_position = $formats->currency_position;
        $no_of_decimal = !is_null($formats->no_of_decimal) ? $formats->no_of_decimal : '0';
        $thousand_separator = !is_null($formats->thousand_separator) ? $formats->thousand_separator : '';
        $decimal_separator = !is_null($formats->decimal_separator) ? $formats->decimal_separator : '0';
        $amount = number_format($amount, $no_of_decimal, $decimal_separator, $thousand_separator);

        switch ($currency_position) {
        case 'right':
            $amount = $currency_symbol . $amount;
                break;
        case 'left_with_space':
            $amount = $amount . ' ' . $currency_symbol;
                break;
        case 'right_with_space':
            $amount = $currency_symbol . ' ' . $amount;
                break;
        default:
            $amount = $amount . $currency_symbol;
                break;
        }

        return $amount;
    }

}

// Create cache format currency settings to reduce database load
if (!function_exists('currency_format_setting')) {

    function currencyFormatSetting()
    {
        if (!cache()->has('currency_format_setting')) {
            $setting = CurrencyFormatSetting::first();
            cache(['currency_format_setting' => $setting], 60 * 60 * 24);
        }

        return cache('currency_format_setting');
    }

}

// Create cache global settings to reduce database load
if (!function_exists('global_setting')) {

    function globalSetting()
    {
        if (!cache()->has('global_setting')) {
            $setting = CompanySetting::first();
            cache(['global_setting' => $setting], 60 * 60 * 24);
        }

        return cache('global_setting');
    }

}

// Convert into Minutes of given Duration and Duration Type
if (!function_exists('convertToMinutes')) {

    function convertToMinutes($duration,$duration_type)
    {
        $durationTypeVal = 1; // Minutes value

        switch ($duration_type) {
        case 'minutes':
            $durationTypeVal = 1;
            break;
        case 'hours':
            $durationTypeVal = 60;
            break;
        case 'days':
            $durationTypeVal = 24 * 60;
            break;
        case 'weeks':
            $durationTypeVal = 7 * 24 * 60;
            break;
        default:
            $durationTypeVal = 1;
            break;
        }

        return ($duration * $durationTypeVal);
    }

}
