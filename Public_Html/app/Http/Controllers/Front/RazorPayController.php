<?php
namespace App\Http\Controllers\Front;

use App\User;
use App\Booking;
use App\Payment;
use Carbon\Carbon;
use App\Helper\Reply;
use Razorpay\Api\Api;
use Illuminate\Http\Request;
use App\Notifications\NewBooking;
use App\PaymentGatewayCredentials;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Cookie;
use App\Notifications\BookingConfirmation;
use Illuminate\Support\Facades\Notification;
use Illuminate\Support\Facades\Session;

class RazorPayController extends Controller
{

    /**
     * Create a new controller instance.
     *
     * @return void
     */
    public function __construct()
    {
        parent::__construct();

        $razorPayCredentials = PaymentGatewayCredentials::first();

        /** setup RazorPay credentials **/
        $this->api = new Api($razorPayCredentials->razorpay_key, $razorPayCredentials->razorpay_secret);
        $this->pageTitle = 'RazorPay';
    }

    /**
     * Store a details of payment with paypal.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function paymentWithRazorPay(Request $request)
    {
        $bookingId = $request->booking_id;
        $paymentId = $request->payment_id;
        $response = $request->response;

        if ($bookingId == null) {
            $booking = Booking::where([ 'user_id' => Auth::user()->id ])->latest()->first();
        }
        else {
            $booking = Booking::where(['id' => $bookingId, 'user_id' => $this->user->id])->first();
        }
        
        $payment = $this->api->payment->fetch($paymentId);

        $amount = round($booking->amount_to_pay * 100);

        if ($amount == $payment->amount && $payment->status == 'authorized') {
            $currency = $this->settings->currency;

            $razorpay_response = $payment->capture([
                'amount' => round($payment->amount, 0),
                'currency' => $currency->currency_code
            ]);

            if ($razorpay_response->error_code) {
                return Reply::error($razorpay_response->error_description);
            }

            // create payment
            $payment = new Payment();

            $payment->booking_id = $booking->id;
            $payment->currency_id = $currency->id;
            $payment->amount = $booking->amount_to_pay;
            $payment->gateway = 'RazorPay';
            $payment->transaction_id = $paymentId;
            $payment->paid_on = Carbon::now();
            $payment->status = 'completed';

            $payment->save();

            // update booking
            $booking->payment_gateway = 'RazorPay';
            $booking->payment_status = 'completed';
            $booking->save();

            // send email notifications
            $admins = User::allAdministrators()->get();
            Notification::send($admins, new NewBooking($booking));

            $user = User::findOrFail($booking->user_id);
            $user->notify(new BookingConfirmation($booking));

            Session::put('success', __('messages.paymentSuccessAmount') .currencyFormatter($booking->amount_to_pay));

            if ($this->frontThemeSettings->front_theme == 'theme-2') {
                return response(Reply::redirect(route('front.payment.success'), $bookingId))->withCookie(Cookie::forget('bookingDetails'))->withCookie(Cookie::forget('couponData'))->withCookie(Cookie::forget('products'));
            }

            return Reply::redirect(route('front.payment.success', $bookingId), __('front.headings.paymentSuccess'));
        }
    }

}
