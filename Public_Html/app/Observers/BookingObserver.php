<?php

namespace App\Observers;

use App\Booking;
use Carbon\Carbon;
use App\BookingTime;
use App\CompanySetting;
use App\Services\Google;
use App\BookingNotifaction;
use Google_Service_Calendar_Event;
use App\Notifications\BookingStatusChange;

class BookingObserver
{

    public function creating(Booking $booking)
    {
        $booking->event_id = $this->googleCalendarEvent($booking);
    }

    public function updating(Booking $booking)
    {
        if ($booking->isDirty('status'))
        {
            if(!is_null($booking->deal_id) && $booking->date_time == ''){
                $booking->date_time = Carbon::now()->setTimezone(CompanySetting::first()->timezone)->format('Y-m-d H:i:s');
            }

        }

        $booking->event_id = $this->googleCalendarEvent($booking);
    }

    public function updated(Booking $booking)
    {
        if ($booking->isDirty('status')){
            $booking->user->notify(new BookingStatusChange($booking));
        }

    }

    /**
     * Handle the currency "deleting" event.
     *
     * @param  \App\Booking  $booking
     * @return void
     */
    public function deleting(Booking $booking)
    {
        $google = new Google();
        $company = CompanySetting::first();

        if (($company->google_calendar == 'active') && $company->google_id) {
            // Create event
            $google->connectUsing($company->token);
            try {
                if ($booking->event_id) {
                    $google->service('Calendar')->events->delete('primary', $booking->event_id);
                }
            } catch (\Google\Service\Exception $th) {

                $company->google_id = null;
                $company->name = null;
                $company->token = null;
                $company->update();
                $google->revokeToken($company->token);
            }
        }
    }

    protected function googleCalendarEvent($booking)
    {
        $google = new Google();
        $company = CompanySetting::first();

        if (($company->google_calendar == 'active') && $company->google_id) {

            $currency_symbol = $company->currency->currency_symbol;

            $description = __('app.booking').' '.__('app.id').':- #' . $booking->id . ', ';
            $description = $booking->order_id ? $description . __('app.payment').' '.__('app.id').':- ' . $booking->order_id . ', ' : $description;
            $description = $description .  __('app.subTotal').':- ' . $currency_symbol.' '.$booking->original_amount . ', ' . __('app.discount').':- ' . $currency_symbol.' '.$booking->discount . ', ' . __('app.tax').':- ' . $currency_symbol.' '.$booking->tax_amount . ', ' . __('app.total').':- ' . $currency_symbol.' '.$booking->amount_to_pay . ' ';

            $bookingTime = BookingTime::where('day', strtolower($booking->date_time->format('l')))->first();

            // for more colors check this url https://lukeboyle.com/blog-posts/2016/04/google-calendar-api---color-id
                $color = 0;

            switch ($booking->status) {
            case 'pending':
                $color = 5;
                break;
            case 'approved':
                $color = 7;
                break;
            case 'in progress':
                $color = 9;
                break;
            case 'completed':
                $color = 2;
                break;
            case 'canceled':
                $color = 11;
                break;
            default:
                $color = 0;
                break;
            }

            // Create event
            $google->connectUsing($company->token);

            $bookingNotifactions = BookingNotifaction::get();
            $reminders = [];

            foreach ($bookingNotifactions as $bookingNotifaction) {

                $duration = convertToMinutes($bookingNotifaction->duration, $bookingNotifaction->duration_type);

                $reminders[] = array('method' => 'email', 'minutes' => $duration);
                $reminders[] = array('method' => 'popup', 'minutes' => $duration);
            }

            $event = new Google_Service_Calendar_Event(array(
                'summary' => $booking->user->name . ' (' . __('app.' . $booking->status) . ')',
                'description' => $description,
                'colorId' => $color,
                'start' => array(
                    'dateTime' => $booking->date_time,
                    'timeZone' => $company->timezone,
                ),
                'end' => array(
                    'dateTime' => $booking->date_time->addMinutes($bookingTime->slot_duration),
                    'timeZone' => $company->timezone,
                ),
                'reminders' => array(
                    'useDefault' => false,
                    'overrides' => $reminders,
                ),
            ));

            try {
                if ($booking->event_id) {
                    $results = $google->service('Calendar')->events->patch('primary', $booking->event_id, $event);
                }
                else {
                    $results = $google->service('Calendar')->events->insert('primary', $event);
                }

                return $results->id;
            } catch (\Google\Service\Exception $th) {

                $company->google_id = null;
                $company->name = null;
                $company->token = null;
                $company->update();

                $google->revokeToken($company->token);
            }
        }

        return $booking->event_id;
    }

}
