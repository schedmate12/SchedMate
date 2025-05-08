<?php

namespace App\Http\Requests\FrontTheme;

use App\Http\Requests\CoreRequest;

class StoreTheme extends CoreRequest
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
            'primary_color' => 'required',
            'secondary_color' => 'required',
            'favicon'       => 'dimensions:max_width=256px,max_height=256px',
        ];
    }

}
