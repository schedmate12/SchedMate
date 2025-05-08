<?php

namespace App\Notifications;

use App\SmsSetting;
use App\SmtpSetting;
use App\Traits\SmsSettings;
use App\Traits\SmtpSettings;
use Illuminate\Bus\Queueable;
use Illuminate\Notifications\Notification;
use Illuminate\Notifications\Messages\MailMessage;

class TestEmail extends Notification
{
    use Queueable, SmtpSettings, SmsSettings;

    /**
     * Create a new notification instance.
     *
     * @return void
     */
    public function __construct()
    {
        $this->smsSetting = SmsSetting::first();
        $this->smsSetting = SmtpSetting::first();

        $this->setSmsConfigs();
        $this->setMailConfigs();
    }

    /**
     * Get the notification's delivery channels.
     *
     * @param  mixed  $notifiable
     * @return array
     */
    // @codingStandardsIgnoreLine
    public function via($notifiable)
    {
        $via = array();
        array_push($via, 'mail');
        return $via;
    }

    /**
     * Get the mail representation of the notification.
     *
     * @param  mixed  $notifiable
     * @return \Illuminate\Notifications\Messages\MailMessage
     */
    // @codingStandardsIgnoreLine
    public function toMail($notifiable)
    {
        return (new MailMessage)
            ->subject(__('email.test.subject'))
            ->line(__('email.test.text'))
            ->line(__('email.thankyouNote'));
    }

}
