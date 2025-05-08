<?php

namespace App\Http\Controllers\Auth;

use App\Traits\SmtpSettings;
use App\Http\Controllers\Controller;
use Illuminate\Foundation\Auth\SendsPasswordResetEmails;

class ForgotPasswordController extends Controller
{
    /*
    |--------------------------------------------------------------------------
    | Password Reset Controller
    |--------------------------------------------------------------------------
    |
    | This controller is responsible for handling password reset emails and
    | includes a trait which assists in sending these notifications from
    | your application to your users. Feel free to explore this trait.
    |
    */

    use SendsPasswordResetEmails, SmtpSettings;

    /**
     * Create a new controller instance.
     *
     * @return void
     */
    public function __construct()
    {
        parent::__construct();
        view()->share('pageTitle', __('app.resetPassword'));
        $this->middleware('guest');

        $this->setMailConfigs();
    }

    public function showLinkRequestForm()
    {
        if ($this->frontThemeSettings->front_theme == 'theme-1') {
            return view('auth.passwords.email');
        }
        else {
            return view('auth.theme_2.email');
        }

    }

}
