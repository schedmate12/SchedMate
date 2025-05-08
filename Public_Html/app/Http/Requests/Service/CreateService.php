<?php

namespace App\Http\Requests\Service;

use App\Http\Requests\CoreRequest;

class CreateService extends CoreRequest
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
            'service_id' => 'sometimes|required|exists:business_services,id',
        ];
    }

    public function messages()
    {
        return [];
    }

}
