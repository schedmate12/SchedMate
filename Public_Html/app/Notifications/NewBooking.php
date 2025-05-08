<?php

namespace App\Notifications;

use App\Booking;
use App\SmsSetting;
use App\CompanySetting;
use App\Traits\SmsSettings;
use App\Traits\SmtpSettings;
use Illuminate\Bus\Queueable;
use Illuminate\Support\HtmlString;
use Illuminate\Notifications\Notification;
use Illuminate\Notifications\Messages\MailMessage;
use Illuminate\Notifications\Messages\NexmoMessage;
use Illuminate\Notifications\Messages\VonageMessage;

class NewBooking extends Notification
{
    use Queueable, SmtpSettings, SmsSettings;

    /**
     * Create a new notification instance.
     *
     * @return void
     */
    public function __construct(Booking $booking)
    {
        $this->booking = $booking;
        $this->smsSetting = SmsSetting::first();
        $this->settings = CompanySetting::first();

        $this->setMailConfigs();
        $this->setSmsConfigs();
    }

    /**
     * Get the notification's delivery channels.
     *
     * @param  mixed  $notifiable
     * @return array
     */
    public function via($notifiable)
    {
        $via = ['mail'];

        if ($this->smsSetting->nexmo_status == 'active' && $notifiable->mobile_verified == 1) {
            array_push($via, 'vonage');
        }

        if ($this->smsSetting->msg91_status == 'active' && $notifiable->mobile_verified == 1) {
            array_push($via, 'msg91');
        }

        return $via;
    }

    /**
     * Get the mail representation of the notification.
     *
     * @param  mixed  $notifiable
     * @return \Illuminate\Notifications\Messages\MailMessage
     */
    public function toMail($notifiable)
    {
        $booking = $this->booking;

        if(!is_null($this->booking->deal_id)){
            $pdf = app('dompdf.wrapper');
            $pdf->loadView('admin.booking.receipt', compact('booking') );
            $filename = __('app.receipt').' #'.$this->booking->id;
        }

        $mail = new MailMessage();

        $mail->subject(__('email.newBooking.subject').' '.config('app.name').'!')
            ->greeting(__('email.hello').' '.ucwords($notifiable->name).'!')
            ->line(__('email.newBooking.text'))
            ->line(__('app.booking').' #'.$this->booking->id);

        if(is_null($this->booking->deal_id)){
            $mail->line(__('app.booking').' '.__('app.date').' - '.$this->booking->date_time);
        }

        $mail->action(__('email.viewBooking'), route('admin.bookings.show', [$this->booking->id]))
            ->line(__('email.thankyouNote'));

        if(!is_null($this->booking->deal_id)){
            $mail->attachData($pdf->output(), $filename);
        }

            return $mail->salutation(new HtmlString(__('email.regards').',<br>'.config('app.name')));

    }

    /**
     * Get the array representation of the notification.
     *
     * @param  mixed  $notifiable
     * @return array
     */
    // @codingStandardsIgnoreLine
    public function toArray($notifiable)
    {
        return [
            //
        ];
    }

    /**
     * Get the Nexmo / SMS representation of the notification.
     *
     * @param  mixed  $notifiable
     * @return VonageMessage
     */
    // @codingStandardsIgnoreLine
    public function toVonage($notifiable)
    {

        if(is_null($this->booking->deal_id)){
            return (new VonageMessage)
                ->content(
                __('email.newBooking.text')."\n".
                __('app.booking').' #'.$this->booking->id."\n".
                __('app.booking').' '.__('app.date').' - '.$this->booking->date_time->format($this->settings->date_format.' '.$this->settings->time_format))->unicode();
        }
        else
        {
            return (new VonageMessage)
                ->content(
                __('email.newBooking.text')."\n".
                __('app.booking').' #'.$this->booking->id."\n")
                ->unicode();
        }
    }

    // @codingStandardsIgnoreLine
    public function toMsg91($notifiable)
    {

        if(is_null($this->booking->deal_id)){
            return (new \Craftsys\Notifications\Messages\Msg91SMS)
                ->from($this->smsSetting->msg91_from)
                ->content(
                __('email.newBooking.text')."\n".
                __('app.booking').' #'.$this->booking->id."\n".
                __('app.booking').' '.__('app.date').' - '.$this->booking->date_time->format($this->settings->date_format.' '.$this->settings->time_format));
        }
        else
        {
            return (new \Craftsys\Notifications\Messages\Msg91SMS)
                ->from($this->smsSetting->msg91_from)
                ->content(
                __('email.newBooking.text')."\n".
                __('app.booking').' #'.$this->booking->id."\n");
        }

    }

}
