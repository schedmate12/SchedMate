<?php

namespace App\Http\Requests;

use App\Helper\Reply;
use App\CompanySetting;
use Illuminate\Foundation\Http\FormRequest;

class CoreRequest extends FormRequest
{

    public function __construct()
    {
        parent::__construct();
        $this->settings = CompanySetting::first();
    }

    protected function formatErrors(\Illuminate\Contracts\Validation\Validator  $validator)
    {
        return Reply::formErrors($validator);
    }

}
