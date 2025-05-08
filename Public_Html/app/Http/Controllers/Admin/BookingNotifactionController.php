<?php

namespace App\Http\Controllers\Admin;

use App\BookingNotifaction;
use Froiden\Envato\Helpers\Reply;
use App\Http\Controllers\Controller;
use App\Http\Requests\BookingNotifaction\Store;

class BookingNotifactionController extends Controller
{

    public function store(Store $request)
    {

        BookingNotifaction::whereNotNull('id')->delete();

        foreach ($request->duration as $key => $duration) {
            $booking = new BookingNotifaction();
            $booking->duration = $duration;
            $booking->duration_type = $request->duration_type[$key];
            $booking->save();
        }

        return Reply::success(__('messages.googleCalendarNotifactionSaved'));
    }

    public function destroy($id)
    {
        $bookingNotifaction = BookingNotifaction::findOrFail($id);
        $bookingNotifaction->delete();
        return Reply::success(__('messages.googleCalendarNotifactionDeleted'));
    }

}
