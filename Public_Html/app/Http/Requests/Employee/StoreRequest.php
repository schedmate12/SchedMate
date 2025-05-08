<?php

namespace App\Http\Requests\Employee;

use App\Http\Requests\CoreRequest;

class StoreRequest extends CoreRequest
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
            'email' => 'required|email|unique:users,email',
            'password' => 'required|min:8',
            'mobile' => 'required',
            'location' => 'required',
            'calling_code' => 'required_with:mobile',
            'house_no' => 'required',
            'address_line' => 'required',
            'city' => 'required',
            'state' => 'required',
            'pin_code' => 'required',
            'role_id' => 'required|exists:roles,id',
            'country_id' => 'required'
        ];
    }

    public function messages()
    {
        return [
            'role_id.exists' => __('app.role').' '.__('errors.fieldRequired')
        ];
    }

}
