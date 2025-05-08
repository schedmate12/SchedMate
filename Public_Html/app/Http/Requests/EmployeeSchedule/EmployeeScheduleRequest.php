<?php

namespace App\Http\Requests\EmployeeSchedule;

use App\Http\Requests\CoreRequest;

class EmployeeScheduleRequest extends CoreRequest
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
                'startT'. $this->id => 'required',
                'endT'. $this->id => 'required|after:startT'
            ];

            return $rules;
    }

    public function messages()
    {
        return [
            'startTime.required' => __('app.StartTime').' '.__('errors.fieldRequired'),
            'endTime.required' => __('app.endTime').' '.__('errors.fieldRequired'),
            'endTime.after' => 'The end date Time must be a date after or equal to start date Time.',
        ];
    }

}
