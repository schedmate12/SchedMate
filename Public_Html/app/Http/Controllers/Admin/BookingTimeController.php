<?php

namespace App\Http\Controllers\Admin;

use Carbon\Carbon;
use App\BookingTime;
use App\Helper\Reply;
use App\Http\Controllers\Controller;
use App\Http\Requests\BookingTime\UpdateBookingTime;
use App\Location;

class BookingTimeController extends Controller
{

    public function edit(BookingTime $bookingTime)
    {
        $this->bookingTime = $bookingTime;
        $location = Location::with('timezone')->where('id', $this->bookingTime->location_id)->first();
        $this->locationTimezone = $location->timezone->zone_name;
        return view('admin.booking-time.edit', $this->data);
    }

    public function update(UpdateBookingTime $request, $id)
    {
        $bookingTime = BookingTime::find($id);

        if ($request->start_time) {
            $bookingTime->start_time = Carbon::createFromFormat($this->settings->time_format, $request->start_time)->format('H:i:s');
        }

        if ($request->end_time) {
            $bookingTime->end_time = Carbon::createFromFormat($this->settings->time_format, $request->end_time)->format('H:i:s');
        }

        if($request->multiple_booking){
            $bookingTime->multiple_booking = $request->multiple_booking;
        }

        if($request->multiple_booking === 'yes'){
            $bookingTime->max_booking = $request->max_booking;
        }

        if($request->slot_duration){
            $bookingTime->slot_duration = $request->slot_duration;
        }

        if($request->max_booking_per_day){
            $bookingTime->max_booking_per_day = $request->max_booking_per_day;
        }

        if($request->max_booking_per_slot){
            $bookingTime->max_booking_per_slot = $request->max_booking_per_slot;
        }

        $bookingTime->status = $request->status;

        $bookingTime->save();

        return Reply::success(__('messages.updatedSuccessfully'));
    }

}
