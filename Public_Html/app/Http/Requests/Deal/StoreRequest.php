<?php

namespace App\Http\Requests\Deal;

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
        $rules = [
            'title'                 => 'required',
            'slug'                  => 'required|unique:deals,slug',
            'applied_between_dates' => 'required',
            'open_time'             => 'required',
            'close_time'            => 'required',
            'locations'             => 'required',
            'services'              => 'required',
            'discount'              => 'required',
            'discount_type'         => 'required',
            'customer_uses_time'    => 'required|numeric|min:1',
            'open_time'             => 'required',
            'close_time'            => 'required',
        ];
        return $rules;
    }

    public function messages()
    {
        return [
            'title.required' => __('app.title').' '.__('errors.fieldRequired'),
            'customer_uses_time.required' => __('messages.the').' '.__('app.customer_uses_time').' '.__('messages.field_is_required'),
            'original_amount.required' => __('messages.the').' '.__('app.originalPrice').' '.__('messages.field_is_required'),
            'discount_amount.required' => __('messages.the').' '.__('app.dealPrice').' '.__('messages.field_is_required'),
            'discount_amount.required' => __('messages.the').' '.__('app.dealPrice').' '.__('messages.field_is_required'),
        ];
    }

}
