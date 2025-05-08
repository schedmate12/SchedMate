<?php

namespace App\Http\Requests\FrontTheme;

use App\Http\Requests\CoreRequest;

class StoreImagesRequest extends CoreRequest
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
            'images' => 'nullable',
            'images.*' => 'required_with:images|mimes:jpeg,png,jpg'
        ];
    }

}
