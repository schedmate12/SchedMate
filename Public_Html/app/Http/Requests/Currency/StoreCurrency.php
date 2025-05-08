<?php

namespace App\Http\Requests\Currency;

use App\Http\Requests\CoreRequest;

class StoreCurrency extends CoreRequest
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
            'currency_name' => 'required',
            'currency_symbol' => 'required',
            'currency_code' => 'required'
        ];
    }

}
