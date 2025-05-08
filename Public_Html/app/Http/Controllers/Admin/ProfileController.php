<?php

namespace App\Http\Controllers\Admin;

use App\Address;
use App\User;
use App\Helper\Files;
use App\Helper\Reply;
use App\Http\Controllers\Controller;
use App\Http\Requests\Setting\ProfileSetting;

class ProfileController extends Controller
{

    public function __construct()
    {
        parent::__construct();
        view()->share('pageTitle', __('menu.profile'));
    }

    public function index()
    {
        $user = $this->user;
        return view('admin.profile.index', compact('user'));
    }

    public function store(ProfileSetting $request)
    {
        $user = User::find($this->user->id);
        $user->name = $request->name;
        $user->email = $request->email;
        $user->rtl = $request->rtl;

        if($request->password != ''){
            $user->password = $request->password;
        }

        if ($request->has('mobile')) {
            if ($user->mobile !== $request->mobile || $user->calling_code !== $request->calling_code) {
                $user->mobile_verified = 0;
            }

            $user->mobile = $request->mobile;
            $user->calling_code = $request->calling_code;
        }

        if ($request->image_delete == 'yes') {
            Files::deleteFile($user->image, 'avatar');
            $user->image = null;
        }


        if ($request->hasFile('image')) {
            $user->image = Files::upload($request->image, 'avatar');
        }

        $user->save();

        $address = Address::firstOrNew(['user_id' => $user->id]);
        $address->house_no = $request->house_no;
        $address->address_line = $request->address_line;
        $address->city = $request->city;
        $address->state = $request->address_line;
        $address->pin_code = $request->pin_code;
        $address->country_id = $request->country_id;

        $address->save();

        return Reply::redirect(route('admin.settings.index'), __('messages.updatedSuccessfully'));
    }

}
