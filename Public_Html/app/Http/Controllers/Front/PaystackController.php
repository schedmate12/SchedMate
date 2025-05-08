<?php

namespace App\Http\Controllers\Front;

use App\User;
use App\Payment;
use App\Booking;
use App\Helper\Reply;
use App\CompanySetting;
use Illuminate\Http\Request;
use App\Notifications\NewBooking;
use App\PaymentGatewayCredentials;
use Illuminate\Support\Facades\Auth;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Cookie;
use Illuminate\Support\Facades\Session;
use App\Notifications\BookingConfirmation;
use Illuminate\Support\Facades\Notification;

class PaystackController extends Controller
{

    public function paymentWithPaystack(Request $request, $bookingId = null)
    {
        $transaction_id = $request['reference']['reference'];
        $secret_key = PaymentGatewayCredentials::first()->paystack_secret_id;

        // Verify transaction from paystack...
        $curl = curl_init();

        curl_setopt_array($curl, array(
            CURLOPT_URL => 'https://api.paystack.co/transaction/verify/'.$transaction_id,
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_ENCODING => '',
            CURLOPT_MAXREDIRS => 10,
            CURLOPT_TIMEOUT => 30,
            CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
            CURLOPT_CUSTOMREQUEST => 'GET',
            CURLOPT_HTTPHEADER => array(
            'Authorization: Bearer '.$secret_key,
            'Cache-Control: no-cache',
            ),
        ));

        $response = curl_exec($curl);
        $err = curl_error($curl);
        curl_close($curl);

        if ($err) {
            return $this->redirectToPayment($bookingId, 'Payment fail');
        }
        else {

            if ($bookingId == null || $bookingId == 'bookingId') {
                $invoice = Booking::where(['user_id' => Auth::user()->id ])->latest()->first();
            }
            else {
                $invoice = Booking::where(['id' => $bookingId, 'user_id' => Auth::user()->id])->first();
            }

            $setting = CompanySetting::with('currency')->first();
            $currency = $setting->currency;
            
            $response_data = json_decode($response);
            $payment_status = $response_data->data->status;

            $payment = new Payment();
            $payment->booking_id = $invoice->id;
            $payment->currency_id = $currency->id;
            $payment->amount = $invoice->amount_to_pay;
            $payment->gateway = 'Paystack';
            $payment->transaction_id = $transaction_id;
            $payment->paid_on = $response_data->data->paid_at;
            $payment->status = $payment_status == 'success' ? 'completed' : 'pending';
            $payment->save();

            $invoice->payment_gateway = 'Paystack';
            $invoice->payment_status = $payment_status == 'success' ? 'completed' : 'pending';
            $invoice->save();

            // send email notifications
            $admins = User::allAdministrators()->get();
            Notification::send($admins, new NewBooking($invoice));

            $user = User::findOrFail($invoice->user_id);
            $user->notify(new BookingConfirmation($invoice));

            Session::put('success', __('messages.paymentSuccessAmount') .currencyFormatter($invoice->amount_to_pay));

            if ($request->return_url == 'booking_url') {

                return Reply::redirect(route('admin.bookings.index'));

            }elseif ($request->return_url == 'backend') {

                return Reply::redirect(route('admin.calendar'));
            }
            return $this->redirectToPayment($bookingId, 'Payment success');
        }

    }

    public function redirectToPayment($id, $message)
    {
        if ($id == null) {
            if ($this->frontThemeSettings->front_theme == 'theme-2') {
                return response(Reply::redirect(route('front.payment.success'), $message));
            }

            return Reply::redirect(route('front.payment.success'), $message);
        }

        if ($this->frontThemeSettings->front_theme == 'theme-2') {
            return response(Reply::redirect(route('front.payment.success'), $id, $message))->withCookie(Cookie::forget('bookingDetails'))->withCookie(Cookie::forget('couponData'))->withCookie(Cookie::forget('products'));
        }

        return Reply::redirect(route('front.payment.success', $id), $message);
    }

    public function redirectToErrorPage($id, $message)
    {
        if ($id == null) {
            if ($this->frontThemeSettings->front_theme == 'theme-2') {
                return response(Reply::redirect(route('front.payment.fail'), $message))->withCookie(Cookie::forget('bookingDetails'))->withCookie(Cookie::forget('couponData'))->withCookie(Cookie::forget('products'));
            }

            return Reply::redirect(route('front.payment.fail'), $message);
        }

        if ($this->frontThemeSettings->front_theme == 'theme-2') {
            return response(Reply::redirect(route('front.payment.fail'), $id, $message))->withCookie(Cookie::forget('bookingDetails'))->withCookie(Cookie::forget('couponData'))->withCookie(Cookie::forget('products'));
        }

        return Reply::redirect(route('front.payment.fail', $id), $message);
    }

}
