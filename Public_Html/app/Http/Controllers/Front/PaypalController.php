<?php
namespace App\Http\Controllers\Front;

use App\User;
use App\Booking;
use App\CompanySetting;
use Illuminate\Http\Request;
use App\Notifications\NewBooking;
use App\PaymentGatewayCredentials;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\Session;
use Illuminate\Support\Facades\Redirect;
use App\Notifications\BookingConfirmation;
use Illuminate\Support\Facades\Notification;

/** All Paypal Details class **/
// use \Config;
use Carbon\Carbon;
use PayPal\Api\Item;
use PayPal\Api\Payer;
use PayPal\Api\Amount;
use PayPal\Api\Payment;
use PayPal\Api\ItemList;
use PayPal\Rest\ApiContext;
use PayPal\Api\Transaction;
use PayPal\Api\RedirectUrls;
use PayPal\Api\PaymentExecution;
use PayPal\Auth\OAuthTokenCredential;
use Illuminate\Support\Facades\Cookie;

class PaypalController extends Controller
{
    // @codingStandardsIgnoreLine
    private $_api_context;

    /**
     * Create a new controller instance.
     *
     * @return void
     */
    public function __construct()
    {
        parent::__construct();

        $credential = PaymentGatewayCredentials::first();
        config(['paypal.settings.mode' => $credential->paypal_mode]);
        /** setup PayPal api context **/
        $paypal_conf = Config::get('paypal');
        $this->_api_context = new ApiContext(new OAuthTokenCredential($credential->paypal_client_id, $credential->paypal_secret));
        $this->_api_context->setConfig($paypal_conf['settings']);
        $this->pageTitle = 'Paypal';
    }

    /**
     * Show the application paywith paypalpage.
     *
     * @return \Illuminate\Http\Response
     */
    public function payWithPaypal()
    {
        return view('paywithpaypal', $this->data);
    }

    /**
     * Store a details of payment with paypal.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function paymentWithpaypal(Request $request, $bookingId = null)
    {
        if ($bookingId == null) {
            $invoice = Booking::where(['user_id' => $this->user->id])->latest()->first();
        }
        else {
            $invoice = Booking::where(['id' => $bookingId, 'user_id' => $this->user->id])->first();
        }

        $setting = CompanySetting::first();
        $currency = $setting->currency;

            $payer = new Payer();
            $payer->setPaymentMethod('paypal');

            $item_1 = new Item();

            $item_1->setName('Payment for invoice #'.$invoice->id) /** item name **/
                ->setCurrency($currency->currency_code)
                ->setQuantity(1)
                ->setPrice($invoice->amount_to_pay); /** unit price **/

            $item_list = new ItemList();
            $item_list->setItems(array($item_1));

            $amount = new Amount();
            $amount->setCurrency($currency->currency_code)
                ->setTotal($invoice->amount_to_pay);

            $transaction = new Transaction();
            $transaction->setAmount($amount)->setItemList($item_list)->setDescription( 'payment for invoice #'. $invoice->id);

            $redirect_urls = new RedirectUrls();
            $redirect_urls->setReturnUrl(route('front.status'))->setCancelUrl(route('front.status', ['cancel']));

            $payment = new Payment();
            $payment->setIntent('Sale')
                ->setPayer($payer)
                ->setRedirectUrls($redirect_urls)
                ->setTransactions(array($transaction));

            $credential = PaymentGatewayCredentials::first();

        try {
            config(['paypal.secret' => $credential->paypal_secret]);
            $payment->create($this->_api_context);
        } catch (\PayPal\Exception\PayPalConnectionException $ex) {
            if (Config::get('app.debug')) {
                Session::put('error', __('messages.connectionTimeout'));
                return $this->redirectToErrorPage($bookingId);
                // echo "Exception: " . $ex->getMessage() . PHP_EOL;die;
                /** $err_data = json_decode($ex->getData(), true); **/
                /** exit; **/
            } else {
                Session::put('error', __('messages.inconvenientError'));
                return $this->redirectToErrorPage($bookingId);
            }
        }

        foreach($payment->getLinks() as $link) {
            if($link->getRel() == 'approval_url') {
                $redirect_url = $link->getHref();
                break;
            }
        }

        /** add payment ID to session **/
        Session::put('paypal_payment_id', $payment->getId());

        Session::put('invoice_id', $invoice->id);

        // Save details in database and redirect to paypal
        $clientPayment = new \App\Payment();
        $clientPayment->booking_id = $invoice->id;
        $clientPayment->currency_id = $currency->id;
        $clientPayment->amount = $invoice->amount_to_pay;
        $clientPayment->transaction_id = $payment->getId();
        $clientPayment->gateway = 'PayPal';
        $clientPayment->save();

        if(isset($redirect_url)) {
            /** redirect to paypal **/
            return Redirect::away($redirect_url);
        }

        \session()->put('error', __('messages.unknownError'));
        return $this->redirectToErrorPage($bookingId);
    }

    public function getPaymentStatus(Request $request, $status=null)
    {
        /** Get the payment ID before session clear **/
        $payment_id = Session::get('paypal_payment_id');
        $invoice_id = Session::get('invoice_id');
        $clientPayment = \App\Payment::where('transaction_id', $payment_id)->first();
        $setting = CompanySetting::first();
        $currency = $setting->currency;
        /** clear the session payment ID **/
        Session::forget('paypal_payment_id');

        if (empty($request->PayerID) || empty($request->token) || $status == 'cancel') {
            \session()->put('error', 'Payment failed');
            return $this->redirectToErrorPage($clientPayment->booking_id);
        }

        $payment = Payment::get($payment_id, $this->_api_context);

        /** PaymentExecution object includes information necessary **/
        /** to execute a PayPal account payment. **/
        /** The payer_id is added to the request query parameters **/
        /** when the user is redirected from paypal back to your site **/
        $execution = new PaymentExecution();
        $execution->setPayerId(request()->get('PayerID'));

        try {
            /**Execute the payment **/
            $result = $payment->execute($execution, $this->_api_context);

            if ($result->getState() == 'approved') {

                /** it's all right **/
                /** Here Write your database logic like that insert record or value in database if you want **/
                $clientPayment->status = 'completed';
                $clientPayment->paid_on = Carbon::now();
                $clientPayment->save();

                $invoice = Booking::findOrFail($invoice_id);
                $invoice->payment_gateway = 'PayPal';
                $invoice->save();

                // send email notifications
                $admins = User::allAdministrators()->get();
                Notification::send($admins, new NewBooking($invoice));

                $user = User::findOrFail($invoice->user_id);
                $user->notify(new BookingConfirmation($invoice));

                Session::put('success', __('messages.paymentSuccessAmount') .currencyFormatter($invoice->amount_to_pay));
                return $this->redirectToPayment($invoice_id);
            }
        } catch (\Exception $ex) {
            Session::put('error', 'Payment failed');
            return $this->redirectToErrorPage($clientPayment->booking_id);
        }

        Session::put('error', 'Payment failed');

        return $this->redirectToErrorPage($clientPayment->booking_id);
    }

    public function redirectToPayment($id)
    {
        if ($id == null) {
            if ($this->frontThemeSettings->front_theme == 'theme-2') {
                return redirect()->route('front.payment.success')->withCookie(Cookie::forget('bookingDetails'))->withCookie(Cookie::forget('couponData'))->withCookie(Cookie::forget('products'));
            }

            return redirect()->route('front.payment.success');
        }

        if ($this->frontThemeSettings->front_theme == 'theme-2') {
            return redirect()->route('front.payment.success', $id)->withCookie(Cookie::forget('bookingDetails'))->withCookie(Cookie::forget('couponData'))->withCookie(Cookie::forget('products'));
        }

        return redirect()->route('front.payment.success', $id);
    }

    public function redirectToErrorPage($id)
    {
        if ($id == null) {
            if ($this->frontThemeSettings->front_theme == 'theme-2') {
                return redirect()->route('front.payment.fail')->withCookie(Cookie::forget('bookingDetails'))->withCookie(Cookie::forget('couponData'))->withCookie(Cookie::forget('products'));
            }

            return redirect()->route('front.payment.fail');
        }

        if ($this->frontThemeSettings->front_theme == 'theme-2') {
            return redirect()->route('front.payment.fail', $id)->withCookie(Cookie::forget('bookingDetails'))->withCookie(Cookie::forget('couponData'))->withCookie(Cookie::forget('products'));
        }

        return redirect()->route('front.payment.fail', $id);
    }

}
