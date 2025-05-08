<?php

namespace App\Http\Requests\Sms;

use App\Http\Requests\CoreRequest;

class SendVerificationCode extends CoreRequest
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
        return [
            'calling_code' => 'required',
            'mobile' => 'required'
        ];
    }

}
