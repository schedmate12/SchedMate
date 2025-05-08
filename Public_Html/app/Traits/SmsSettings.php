<?php
/**
 * Created by PhpStorm.
 * User: DEXTER
 * Date: 24/05/17
 * Time: 11:29 PM
 */

namespace App\Traits;

use App\SmsSetting;
use App\CompanySetting;
use Illuminate\Support\Facades\Config;
use Illuminate\Notifications\NexmoChannelServiceProvider;
use Illuminate\Notifications\VonageChannelServiceProvider;

trait SmsSettings
{

    public function setSmsConfigs()
    {
        $smsSetting = SmsSetting::first();
        $settings = CompanySetting::first();

        $company = explode(' ', trim($settings->company_name));

        Config::set('services.vonage.key', $smsSetting->nexmo_key);
        Config::set('services.vonage.secret', $smsSetting->nexmo_secret);
        Config::set('services.vonage.sms_from', $smsSetting->nexmo_from);

        Config::set('vonage.api_key', $smsSetting->nexmo_key);
        Config::set('vonage.api_secret', $smsSetting->nexmo_secret);

        Config::set('services.msg91.key', $smsSetting->msg91_key);
        Config::set('services.msg91.from', $smsSetting->msg91_from);

        Config::set('app.name', $settings->company_name);
        Config::set('app.logo', $settings->logo_url);

        (new VonageChannelServiceProvider(app()))->register();
    }

}
