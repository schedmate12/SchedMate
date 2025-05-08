<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Booking;
use App\CompanySetting;
use Carbon\Carbon;
use Illuminate\Support\Facades\DB;
use App\Notifications\BookingReminder;
use Illuminate\Bus\Queueable;

class BookingNotification extends Command
{
    use Queueable;

    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'booking:notification';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Send a notification before booking. ';

    /**
     * Create a new command instance.
     *
     * @return void
     */
    // @codingStandardsIgnoreLine
    public function __construct(Booking $booking)
    {
        parent::__construct();
    }

    /**
     * Execute the console command.
     *
     * @return mixed
     */
    // @codingStandardsIgnoreLine
    public function handle()
    {
        $company = CompanySetting::first();
        $bookings = Booking::whereIn('status', ['pending', 'approved'])->whereNull('notify_at')->whereBetween('date_time', [Carbon::now()->timezone($company->timezone), Carbon::now()->timezone($company->timezone)->addMinutes(convertToMinutes($company->duration, $company->duration_type))])->get();

        foreach ($bookings as $booking) {
            $booking->user->notify(new BookingReminder($booking));
            $booking->update(['notify_at' => Carbon::now()]);
        }
    }

}
