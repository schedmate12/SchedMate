<?php

namespace App\Http\Requests\Coupon;

use App\Http\Requests\CoreRequest;

class UpdateRequest extends CoreRequest
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
            'title' => 'required|regex:/(^[A-Za-z0-9]+$)+/|unique:coupons,title,'.$this->route('coupon'),
            'start_time' => 'required',
        ];

        if($this->get('amount') == null && $this->get('percent') == null ){
            $rules['amount'] = 'required';
        }

        return $rules;
    }

    public function messages()
    {
        return [
            'title.required' => __('app.coupon').' '.__('app.code').' '.__('errors.fieldRequired'),
        ];
    }

}
