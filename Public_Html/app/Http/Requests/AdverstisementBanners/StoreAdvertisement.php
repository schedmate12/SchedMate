<?php

namespace App\Http\Requests\AdvertisementBanner;

use App\Http\Requests\CoreRequest;

class StoreAdvertisement extends CoreRequest
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
            'position' => 'required',
            'applied_between_dates' => 'required',
            'image' => 'required',
        ];
    }

    public function messages()
    {
        return [
            'position.required' => __('app.position').' '.__('errors.fieldRequired'),
            'applied_between_dates.required' => __('app.appliedBetweenDateTime').' '.__('errors.fieldRequired'),
            'image.required' => __('app.image').' '.__('errors.fieldRequired'),
        ];
    }

}
