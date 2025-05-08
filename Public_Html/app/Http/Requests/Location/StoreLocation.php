<?php

namespace App\Http\Requests\Location;

use App\Http\Requests\CoreRequest;

class StoreLocation extends CoreRequest
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
            'lat' => 'required',
            'lng' => 'required',
            'country_id' => 'required',
            'timezone_id' => 'required'
        ];
    }

    public function attributes()
    {
        return [
            'country_id' => 'country',
            'timezone_id' => 'timezone',
        ];
    }

}
