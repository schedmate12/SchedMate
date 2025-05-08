<?php

namespace App\Observers;

use App\BookingTime;
use App\EmployeeSchedules;

class BookingTimeObserver
{

    /**
     * Handle the booking time "created" event.
     *
     * @param  \App\BookingTime  $bookingTime
     * @return void
     */
    // @codingStandardsIgnoreLine
    public function created(BookingTime $bookingTime)
    {

    }

    /**
     * Handle the booking time "updated" event.
     *
     * @param  \App\BookingTime  $bookingTime
     * @return void
     */
    public function updated(BookingTime $bookingTime)
    {
        $bookingDay = BookingTime::where('id', $bookingTime->id)->first();
        $schedule = EmployeeSchedules::where('days', $bookingDay->day)->get();

        if ($bookingTime->isDirty('status')){
            if($bookingTime->status == 'enabled'){

                foreach($schedule as $schedules){
                    $schedules->is_working = 'yes';
                    $schedules->update();
                }
            } else {
                foreach($schedule as $schedules){
                    $schedules->is_working = 'no';
                    $schedules->update();
                }
            }
        }
    }

    /**
     * Handle the booking time "deleted" event.
     *
     * @param  \App\BookingTime  $bookingTime
     * @return void
     */
    // @codingStandardsIgnoreLine
    public function deleted(BookingTime $bookingTime)
    {
        //
    }

    /**
     * Handle the booking time "restored" event.
     *
     * @param  \App\BookingTime  $bookingTime
     * @return void
     */
    // @codingStandardsIgnoreLine
    public function restored(BookingTime $bookingTime)
    {
        //
    }

    /**
     * Handle the booking time "force deleted" event.
     *
     * @param  \App\BookingTime  $bookingTime
     * @return void
     */
    // @codingStandardsIgnoreLine
    public function forceDeleted(BookingTime $bookingTime)
    {
        //
    }

}
