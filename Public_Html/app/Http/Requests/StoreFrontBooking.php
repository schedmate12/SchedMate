<?php

namespace App\Http\Requests;

use App\GoogleCaptchaSetting;
use Illuminate\Support\Facades\Auth;

class StoreFrontBooking extends CoreRequest
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
        $rules = [];
        $google_captcha = GoogleCaptchaSetting::first();

        if(auth()->guest()){
            $rules = [
                'first_name' => 'required',
                'last_name' => 'required',
                'email' => 'required|email|unique:users,email',
                'phone' => 'required|numeric',
                'house_no' => 'required|numeric',
                'address_line' => 'required',
                'city' => 'required',
                'state' => 'required',
                'pin_code' => 'required',
                'country_id' => 'required',
            ];
        }
        else {
            $rules = [
                'house_no' => 'required|numeric',
                'address_line' => 'required',
                'city' => 'required',
                'state' => 'required',
                'pin_code' => 'required',
                'country_id' => 'required',
            ];
        }

        if($google_captcha->status == 'active' && Auth::check() != 'true')
        {
            $rules['recaptcha'] = 'required';
        }

        return $rules;
    }

    public function messages()
    {
        return [
            'email.unique' => __('front.emailRegistered')
        ];
    }

}
