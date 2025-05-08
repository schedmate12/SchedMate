<?php

namespace App\Http\Controllers\Auth;

use App\Booking;
use Carbon\Carbon;
use Illuminate\Http\Request;
use App\GoogleCaptchaSetting;
use Froiden\Envato\Traits\AppBoot;
use App\Traits\SocialAuthSettings;
use App\Http\Controllers\Controller;
use App\Notifications\NewUser;
use App\Role;
use App\Social;
use App\User;
use Illuminate\Support\Facades\Cookie;
use Illuminate\Foundation\Auth\AuthenticatesUsers;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;
use Laravel\Socialite\Facades\Socialite;

class LoginController extends Controller
{
    /*
    |--------------------------------------------------------------------------
    | Login Controller
    |--------------------------------------------------------------------------
    |
    | This controller handles authenticating users for the application and
    | redirecting them to your home screen. The controller uses a trait
    | to conveniently provide its functionality to your applications.
    |
    */

    use AuthenticatesUsers, AppBoot, SocialAuthSettings;

    /**
     * Where to redirect users after login.
     *
     * @var string
     */
    protected $redirectTo = '/account/dashboard';

    /**
     * Create a new controller instance.
     *
     * @return void
     */
    public function __construct()
    {
        parent::__construct();
        view()->share('pageTitle', __('email.loginAccount'));
        $this->middleware('guest')->except('logout');
        $this->redirectTo = url()->previous();
    }

    public function showLoginForm()
    {
        if (!$this->isLegal()) {
            return redirect('verify-purchase');
        }

        if (!session()->has('errors')) {
            session()->put('url.encoded', url()->previous());
        }

        $socialAuthSettings = $this->socialAuthSettings;

        if ($this->frontThemeSettings->front_theme == 'theme-1') {
            return view('auth.login', compact('socialAuthSettings'));
        }

        return view('auth.theme_2.login', compact('socialAuthSettings'));
    }

    /**
     * The user has been authenticated.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  mixed  $user
     * @return mixed
     */
    protected function authenticated(Request $request, $user)
    {
        if ($user->is_admin || $user->is_employee) {
            return redirect(session()->has('url.intended') ? session()->get('url.intended') : route('admin.dashboard'));
        }

        if(!$user->is_admin && !$user->is_employee && Cookie::get('bookingDetails') !== null && Cookie::get('products') !== null && $this->checkUserBooking($user->id) > $this->settings->booking_per_day){
            return redirect(route('front.index'))->withCookie(Cookie::forget('bookingDetails'))->withCookie(Cookie::forget('products'))->withCookie(Cookie::forget('couponData'));
        }

        return redirect(session()->get('url.encoded'));
    }

    protected function validateLogin(Request $request)
    {
        $google_captcha = GoogleCaptchaSetting::first();

        $rules = [
            $this->username() => 'required|string',
            'password' => 'required|string',
        ];

        if($google_captcha->status == 'active')
        {
            $rules['recaptcha'] = 'required';
        }

        $this->validate($request, $rules);
    }

    /**
     * The user has logged out of the application.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return mixed
     */
    protected function loggedOut(Request $request)
    {
        session()->forget('url.encoded');

        return redirect(url()->previous());
    }

    protected function checkUserBooking($user_id)
    {
        $bookingDetails = json_decode(request()->cookie('bookingDetails'), true);
        $bookingDate = Carbon::createFromFormat('Y-m-d', $bookingDetails['bookingDate']);
        return Booking::whereDate('created_at', $bookingDate)->where('user_id', $user_id)->get()->count();
    }

    public function redirect($provider)
    {
        $this->setSocailAuthConfigs();
        return Socialite::driver($provider)->redirect(); /** @phpstan-ignore-line */
    }

    public function callback(Request $request, $provider)
    {
        $this->setSocailAuthConfigs();

        try {
            if($provider != 'twitter') {
                $data = Socialite::driver($provider)->stateless()->user(); /** @phpstan-ignore-line */
            }
            else {
                $data = Socialite::driver($provider)->user(); /** @phpstan-ignore-line */
            }
        }
        catch (\Exception $e) {
            if ($request->has('error_description') || $request->has('denied')) {
                return redirect()->route('login')->withErrors([$this->username() => 'The user cancelled '.$provider.' login']);
            }

            throw ValidationException::withMessages([
                $this->username() => [$e->getMessage()],
            ])->status(Response::HTTP_TOO_MANY_REQUESTS);
        }

        $user = User::where('email', '=', $data->email)->first();

        if($user) {
            // User found
            DB::beginTransaction();

            Social::updateOrCreate(['user_id' => $user->id],
            [
                'social_id' => $data->id,
                'social_service' => $provider,
            ]);

            DB::commit();

            Auth::login($user);
            return redirect()->intended($this->redirectPath());
        }
        else {
            $user = User::create([
                'name'          => $data->getName(),
                'email'         => $data->getEmail(),
                'image'         => $data->getAvatar(),
                'provider_id'   => $data->getId(),
                'password'      => '123456',
            ]);

            Social::updateOrCreate(['user_id' => $user->id],
            [
                'social_id' => $data->getId(),
                'social_service' => $provider,
            ]);

            $user->attachRole(Role::where('name', 'customer')->withoutGlobalScopes()->first()->id);

            Auth::login($user);

            $user->notify(new NewUser('123456'));

            return redirect()->route('admin.dashboard');
        }

    }

}
