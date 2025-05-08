<?php

namespace App\Traits;

use App\CompanySetting;
use Illuminate\Support\Facades\Config;

trait GoogleOAuth
{

    public function setGoogleoAuthConfig()
    {

        $settings = CompanySetting::select('google_client_id', 'google_client_secret')->first();
        Config::set('services.google.client_id', $settings->google_client_id);
        Config::set('services.google.client_secret', $settings->google_client_secret);
        Config::set('services.google.redirect_uri', route('googleAuth'));
    }

}



