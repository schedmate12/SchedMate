<?php
/**
 * Created by PhpStorm.
 * User: DEXTER
 * Date: 24/05/17
 * Time: 11:29 PM
 */

namespace App\Traits;

use App\SmtpSetting;
use App\CompanySetting;
use Illuminate\Support\Facades\Config;
use Illuminate\Mail\MailServiceProvider;

trait SmtpSettings
{

    public function setMailConfigs()
    {
        $smtpSetting = SmtpSetting::first();
        $settings = CompanySetting::first();

        if (!in_array(\config('app.env'), ['development','demo']))
        {
            Config::set('mail.driver', $smtpSetting->mail_driver);
            Config::set('mail.host', $smtpSetting->mail_host);
            Config::set('mail.port', $smtpSetting->mail_port);
            Config::set('mail.username', $smtpSetting->mail_username);
            Config::set('mail.password', $smtpSetting->mail_password);
            Config::set('mail.encryption', $smtpSetting->mail_encryption);
        }

        Config::set('mail.reply_to.name', $settings->company_name);
        Config::set('mail.reply_to.address', $settings->company_email);
        Config::set('app.name', $settings->company_name);
        Config::set('app.logo', $settings->logo_url);

        // SES and other mail services which require email from verified sources
        if (\config('mail.verified') === true) {
            // Config::set('mail.from.name', $smtpSetting->mail_from_name);
            Config::set('mail.from.address', $smtpSetting->mail_from_email);
        }
        else {
            Config::set('mail.from.address', $settings->company_email);
        }

        (new MailServiceProvider(app()))->register();
        $_ENV['APP_URL'] = $settings->website;
    }

}
