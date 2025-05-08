<?php

namespace App\Observers;

use App\BookingTime;
use App\BusinessService;
use App\Helper\SearchLog;
use App\Location;
use Carbon\Carbon;
use Illuminate\Support\Facades\File;

class BusinessServiceObserver
{

    public function created(BusinessService $service)
    {
        SearchLog::createSearchEntry($service->id, 'Service', $service->name, 'admin.business-services.edit');
        $bookingTime = BookingTime::where('location_id', $service->location_id)->first();

        if (is_null($bookingTime)) {
            // seed booking times
            $location = Location::with('timezone')->where('id', $service->location_id)->first();
            $booking_times = [];
            $weekdays = [
                'monday',
                'tuesday',
                'wednesday',
                'thursday',
                'friday',
                'saturday',
                'sunday',
            ];

            foreach ($weekdays as $weekday) {
                $booking_times[] = [
                    'location_id' => $service->location_id,
                    'day' => $weekday,
                    'start_time' => Carbon::parse('09:00:00', $location->timezone->zone_name)->setTimezone('UTC'),
                    'end_time' => Carbon::parse('18:00:00', $location->timezone->zone_name)->setTimezone('UTC'),
                ];
            }

            BookingTime::insert($booking_times);
        }

    }

    public function updating(BusinessService $service)
    {
        SearchLog::updateSearchEntry($service->id, 'Service', $service->name, 'admin.business-services.edit');

        $currentLocationId = BusinessService::findOrFail($service->id)->location_id;

        $serviceCount = BusinessService::where('location_id', $currentLocationId)->get();

        if($serviceCount->count() == 1)
        {
            $bookingTimes = BookingTime::where('location_id', $currentLocationId)->get();

            if($bookingTimes->count() > 0)
            {
                foreach($bookingTimes as $bookingTime)
                {
                    $bookingTime->delete();
                }

                $bookingTime = BookingTime::where('location_id', $service->location_id)->first();

                if (is_null($bookingTime)) {
                    // seed booking times
                    $location = Location::with('timezone')->where('id', $service->location_id)->first();
                    /* dd($location); */
                    $booking_times = [];
                    $weekdays = [
                        'monday',
                        'tuesday',
                        'wednesday',
                        'thursday',
                        'friday',
                        'saturday',
                        'sunday',
                    ];

                    foreach ($weekdays as $weekday) {
                        $booking_times[] = [
                            'location_id' => $service->location_id,
                            'day' => $weekday,
                            'start_time' => Carbon::parse('09:00:00', $location->timezone->zone_name)->setTimezone('UTC'),
                            'end_time' => Carbon::parse('18:00:00', $location->timezone->zone_name)->setTimezone('UTC'),
                        ];
                    }

                    BookingTime::insert($booking_times);
                }
            }
        }
    }

    public function deleted(BusinessService $service)
    {
        SearchLog::deleteSearchEntry($service->id, 'admin.business-services.edit');

        // Delete images folder from user-uploads/service directory
        File::deleteDirectory(public_path('user-uploads/service/'.$service->id));
    }

}
