<?php

namespace App\Http\Controllers;

use App\Invoice;
use App\Payment;
use Carbon\Carbon;
use Stripe\Stripe;
use Stripe\Webhook;
use App\ClientPayment;
use Illuminate\Http\Request;
use App\PaymentGatewayCredentials;
use Illuminate\Routing\Controller;

class StripeWebhookController extends Controller
{

    public function verifyStripeWebhook(Request $request)
    {
        $stripeCredentials = PaymentGatewayCredentials::first();

        Stripe::setApiKey($stripeCredentials->stripe_secret);

        // You can find your endpoint's secret in your webhook settings
        $endpoint_secret = $stripeCredentials->stripe_webhook_secret;

        $payload = @file_get_contents('php://input');
        $sig_header = $_SERVER['HTTP_STRIPE_SIGNATURE'];
        $event = null;

        try {
            $event = Webhook::constructEvent(
                $payload, $sig_header, $endpoint_secret
            );
        } catch(\UnexpectedValueException $e) {
            // Invalid payload
            return response('Invalid Payload', 400);
        } catch(\Stripe\Error\SignatureVerification $e) {
            // Invalid signature
            return response('Invalid signature', 400);
        }

        $payload = json_decode($request->getContent(), true);

        $eventId = $payload['id'];
        $eventCount = ClientPayment::where('event_id', $eventId)->count();

        // Do something with $event
        if ($payload['type'] == 'invoice.payment_succeeded' && $eventCount == 0)
        {
              $planId = $payload['data']['object']['lines']['data'][0]['plan']['id'];
              $customerId = $payload['data']['object']['customer'];
              $amount = $payload['data']['object']['lines']['data'][0]['amount'];
              $transactionId = $payload['data']['object']['lines']['data'][0]['id'];
              $invoiceId = $payload['data']['object']['lines']['data'][0]['plan']['metadata']['invoice_id'];

              $previousClientPayment = ClientPayment::where('plan_id', $planId)
                  ->where('transaction_id', $transactionId)
                  ->whereNull('event_id')
                  ->first();

            if($previousClientPayment)
              {
                $previousClientPayment->event_id = $eventId;
                $previousClientPayment->save();
            }
            else {
                $invoice = Invoice::find($invoiceId);

                $payment = new Payment();
                $payment->project_id = $invoice->project_id;
                $payment->currency_id = $invoice->currency_id;
                $payment->amount = $amount / 100;
                $payment->event_id = $eventId;
                $payment->gateway = 'Stripe';
                $payment->paid_on = Carbon::now();
                $payment->status = 'completed';
                $payment->save();
            }
        }

        return response('Webhook Handled', 200);
    }

}
