<?php

namespace App\Http\Requests\Payment;

use App\Http\Requests\CoreRequest;

class UpdateCredentialSetting extends CoreRequest
{

    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */
    public function authorize()
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array
     */
    public function rules()
    {
        if (!$this->has('paypal_status')) {
            $this->request->add(['paypal_status' => 'deactive']);
        }

        if (!$this->has('stripe_status')) {
            $this->request->add(['stripe_status' => 'deactive']);
        }

        if (!$this->has('paystack_status')) {
            $this->request->add(['paystack_status' => 'deactive']);
        }

        if (!$this->has('razorpay_status')) {
            $this->request->add(['razorpay_status' => 'deactive']);
        }

        if (!$this->has('show_payment_options')) {
            $this->request->add(['show_payment_options' => 'hide']);
        }

        return [
           'paypal_client_id' => 'required_if:paypal_status,active',
           'paypal_secret' => 'required_if:paypal_status,active',
           'paypal_mode' => 'required|in:sandbox,live',
           'paystack_public_id' => 'required_if:paystack_status,active',
           'paystack_secret_id' => 'required_if:paystack_status,active',
           'stripe_client_id' => 'required_if:stripe_status,active',
           'stripe_secret' => 'required_if:stripe_status,active',
           'razorpay_key' => 'required_if:razorpay_status,active',
           'razorpay_secret' => 'required_if:razorpay_status,active',
        ];
    }

    /**
     * Get custom messages for validator errors.
     *
     * @return array
     */
    public function messages()
    {
        return [
            '*.required_if' => __('errors.payment.requiredIf')
        ];
    }

}
