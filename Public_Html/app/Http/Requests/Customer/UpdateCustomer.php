<?php

namespace App\Http\Requests\Customer;

use App\Http\Requests\CoreRequest;

class UpdateCustomer extends CoreRequest
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
            'name' => 'required',
            'email' => 'required|email|unique:users,email,'.$this->route('customer'),
            'house_no' => 'required',
            'address_line' => 'required',
            'city' => 'required',
            'state' => 'required',
            'pin_code' => 'required',
            'country_id' => 'required',
        ];
    }

}
