<?php

namespace App\Http\Requests\GoogleMapKey;

use App\Http\Requests\CoreRequest;

class StoreMapKey extends CoreRequest
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
            'google_map_api_key' => 'required',
        ];
    }

}
