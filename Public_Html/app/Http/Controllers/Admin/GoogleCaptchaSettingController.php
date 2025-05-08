<?php

namespace App\Http\Controllers\Admin;

use App\Helper\Reply;
use App\GoogleCaptchaSetting;
use App\Http\Controllers\Controller;
use App\Http\Requests\GoogleCaptcha\UpdateGoogleCaptchaSetting;

class GoogleCaptchaSettingController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */

    public function index()
    {
        $this->key = request()->key;
        return view('admin.front-settings.verify-recaptcha-v3', $this->data);
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\GoogleCaptchaSetting  $googleCaptchaSetting
     * @return \Illuminate\Http\Response
     */
    // @codingStandardsIgnoreLine
    public function update(UpdateGoogleCaptchaSetting $request)
    {
        $google_capcha_setting = GoogleCaptchaSetting::first();

        if($request->version == 'v3') {
            $google_capcha_setting->v3_site_key = $request->google_captcha3_site_key;
            $google_capcha_setting->v3_secret_key = $request->google_captcha3_secret;
            $google_capcha_setting->v3_status = 'active';
            $google_capcha_setting->v2_status = 'inactive';
        }
        else {
            $google_capcha_setting->v2_site_key = $request->google_captcha2_site_key;
            $google_capcha_setting->v2_secret_key = $request->google_captcha2_secret;
            $google_capcha_setting->v2_status = 'active';
            $google_capcha_setting->v3_status = 'inactive';
        }

        if($request->google_captcha_status == 'inactive') {
            $google_capcha_setting->v2_status = 'inactive';
            $google_capcha_setting->v3_status = 'inactive';
            $google_capcha_setting->status = 'inactive';
        }
        else {
            $google_capcha_setting->status = 'active';
        }

        $google_capcha_setting->save();

        return Reply::redirect(route('admin.settings.index'), __('messages.updatedSuccessfully'));
    }

}
