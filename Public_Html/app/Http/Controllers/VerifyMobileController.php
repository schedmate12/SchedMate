<?php

namespace App\Http\Controllers;

use App\User;
use App\Helper\Reply;
use Illuminate\Support\Arr;
use App\Traits\SmsSettings;
use Illuminate\Http\Request;
use App\Notifications\NewUser;
use Illuminate\Notifications\Facades\Vonage;
use Nexmo\Laravel\Facade\Nexmo;
use Exception as GlobalException;
use Nexmo\Client\Exception\Exception;
use App\Http\Requests\Sms\VerifyOTPCode;
use App\Http\Requests\Sms\SendVerificationCode;

class VerifyMobileController extends Controller
{
    use SmsSettings;

    public function __construct()
    {
        parent::__construct();
        $this->setSmsConfigs();
    }

    public function sendVerificationCode(SendVerificationCode $request)
    {
        $user = User::select('id', 'mobile_verified', 'calling_code', 'mobile')->where('id', $this->user->id)->first();


        if ($request->mobile == $user->mobile && $request->calling_code == $user->calling_code && $user->mobile_verified == 1) {
            return Reply::error(__('messages.mobileVerify.changeMobileNumber'));
        }

        $settings = config('vonage.settings');
        $settings = Arr::add($settings, 'number', substr($request->calling_code, 1).$request->mobile);
        $settings = Arr::add($settings, 'brand', $this->smsSettings->nexmo_from);

        try {
            $verification = Vonage::verify()->start($settings);
            session()->put('verify:request_id', $verification->getRequestId());
        } catch (GlobalException $e) {
            return Reply::error($e->getMessage());
        }

        // change user verified status if verified and save mobile details
        $user->calling_code = $request->calling_code;
        $user->mobile = $request->mobile;

        if ($user->mobile_verified) {
            $user->mobile_verified = 0;
        }

        $user->save();

        $calling_codes = $this->getCallingCodes();

        $view = view('partials.front_verify_phone', compact('user', 'calling_codes'))->render();

        if ($request->route()->getName() == 'sendOtpCode.account') {
            $view = view('partials.admin_verify_phone', compact('user', 'calling_codes'))->render();
        }

        return Reply::successWithData(__('messages.mobileVerify.otpSent'), ['view' => $view]);
    }

    public function verifyOtpCode(VerifyOTPCode $request)
    {
        $user = User::select('id', 'email', 'mobile_verified', 'calling_code', 'mobile')->where('id', $this->user->id)->first();

        try {
            Vonage::verify()->check(
                session()->get('verify:request_id'),
                $request->otp
            );

            $user->mobile_verified = 1;

            $user->save();

            session()->remove('verify:request_id');

            if ($request->route()->getName() == 'verifyOtpCode.account') {
                $view = view('partials.admin_verify_phone', compact('user'))->render();
            }
            else {
                $user->notify(new NewUser('123456'));

                $view = view('partials.front_verify_phone', compact('user'))->render();
            }

            return Reply::successWithData(__('messages.mobileVerify.otpVerified'), ['view' => $view]);
        }
        catch (GlobalException $e) {
            if ($e->getCode() == 16) {
                return Reply::error(__('messages.mobileVerify.wrongOtp'));
            }

            if ($e->getCode() == 17) {
                session()->remove('verify:request_id');

                $calling_codes = $this->getCallingCodes();

                $view = view('partials.front_verify_phone', compact('user', 'calling_codes'))->render();

                if ($request->route()->getName() == 'verifyOtpCode.account') {
                    $view = view('partials.admin_verify_phone', compact('user', 'calling_codes'))->render();
                }

                return Reply::error(__('messages.mobileVerify.tooManyWrongOtp'), null, compact('view'));
            }

            if ($e->getCode() == 6) {
                return Reply::error(__('messages.mobileVerify.failed'));
            }
        }
    }

    public function removeSession(Request $request)
    {
        foreach ($request->sessions as $session) {
            if (session()->has($session)) {
                session()->remove($session);
            }
        }

        return Reply::dataOnly([]);
    }

    public function changeMobile()
    {
        $calling_codes = $this->getCallingCodes();
        $user = $this->user;

        $view = view('sections.change_mobile', compact('calling_codes', 'user'))->render();

        return Reply::dataOnly(['view' => $view]);
    }

}
