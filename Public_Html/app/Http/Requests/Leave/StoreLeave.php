<?php

namespace App\Http\Requests\Leave;

use Illuminate\Support\Arr;
use App\Http\Requests\CoreRequest;

class StoreLeave extends CoreRequest
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
            'startdate' => 'required|'.$this->date_picker_format,
            'enddate' => 'required|'.$this->date_picker_format.'|after_or_equal:startdate',
            'reason' => 'required',
        ];

        if(request('half_day') == 'true'){
            $rules = Arr::add($rules, 'starttime', 'required');
            $rules = Arr::add($rules, 'endtime', 'required');
        }

        if(auth()->user()->hasRole('administrator') && request()->id == '') {
            $rules = Arr::add($rules, 'employee', 'required');
        }

        return $rules;
    }

    public function messages()
    {
        return [
            'employee.required' => __('app.employee').' '. __('app.name').' '.__('errors.fieldRequired'),
            'startdate.required' => __('app.startDate').' '.__('errors.fieldRequired'),
            'enddate.required' => __('app.endDate').' '.__('errors.fieldRequired'),
            'enddate.after_or_equal ' => 'The end date must be a date after or equal to start date.',
            'starttime.required' => __('app.startTime').' '.__('errors.fieldRequired'),
            'endtime.required' => __('app.endTime').' '.__('errors.fieldRequired'),
            'endtime.after' => 'The end date Time must be a Time after or equal to start date Time.',

        ];
    }

}
