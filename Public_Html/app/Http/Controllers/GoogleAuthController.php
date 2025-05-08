<?php

namespace App\Http\Controllers;

use App\CompanySetting;
use App\Services\Google;
use Illuminate\Http\Request;
use Froiden\Envato\Helpers\Reply;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Session;

class GoogleAuthController extends Controller
{

    public function index(Request $request, Google $google)
    {
        if (!$request->code) {
            return redirect($google->createAuthUrl());
        }

        $google->authenticate($request->code);
        $account = $google->service('Oauth2')->userinfo->get();

        $googleAccount = CompanySetting::first();

        if ($googleAccount->google_id) {
            Session::flash('message', __('menu.googleCalendar').' '. __('app.account').' '. __('app.connected').' '. __('app.successfully'));
        }
        else {
            Session::flash('message', __('menu.googleCalendar').' '. __('app.account').' '. __('app.update').' '. __('app.successfully'));
        }

        $googleAccount->google_id = $account->id;
        $googleAccount->name = $account->name;
        $googleAccount->token = $google->getAccessToken();
        $googleAccount->update();

        return redirect()->route('admin.settings.index', '#googleCalendar');
    }

    // @codingStandardsIgnoreLine
    public function destroy($id, Google $google)
    {
        $googleAccount = CompanySetting::first();
        $googleAccount->google_id = null;
        $googleAccount->name = null;
        $googleAccount->token = null;
        $googleAccount->update();

        $google->revokeToken($googleAccount->token);

        return Reply::success(__('messages.recordDeleted'));
    }

}
