<?php

namespace App\Http\Controllers\Front;

use App\Address;
use App\AdvertisementBanner;
use App\Tax;
use App\User;
use App\Role;
use App\Deal;
use App\Page;
use App\Leave;
use App\Media;
use App\Coupon;
use App\Booking;
use App\ItemTax;use App\DealItem;
use App\Language;
use App\Category;
use App\Location;
use Carbon\Carbon;
use App\OfficeLeave;
use App\BookingItem;
use App\BookingTime;
use App\Helper\Reply;
use App\CompanySetting;
use App\BusinessService;
use App\CustomerFeedback;
use App\EmployeeSchedules;
use App\GoogleMapApiKey;
use Illuminate\Support\Arr;
use Illuminate\Http\Request;
use App\Notifications\NewUser;
use App\Notifications\NewBooking;
use App\Notifications\NewContact;
use Illuminate\Support\Facades\DB;
use App\PaymentGatewayCredentials;
use Illuminate\Support\Facades\App;
use Illuminate\Support\Facades\Auth;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Cookie;
use App\Http\Requests\StoreFrontBooking;
use App\Notifications\BookingConfirmation;
use App\Http\Requests\Front\ContactRequest;
use Illuminate\Support\Facades\Notification;
use App\Http\Requests\Front\CartPageRequest;
use App\Http\Requests\ApplyCoupon\ApplyRequest;
use App\ServiceReview;
use App\NewDeal;

class FrontController extends Controller
{
    // use DestroyCookie;

    public function __construct()
    {
        parent::__construct('front');

        /* remove deal cookie from some all methods */
        $this->middleware('DestroyCookie')->except('checkoutPage', 'saveBooking', 'paymentFail', 'paymentSuccess', 'paymentGateway', 'offlinePayment');

        if (request()->hasCookie('appointo_language_code')) {
            $code = substr(decrypt(request()->cookie('appointo_language_code'), false), strpos(decrypt(request()->cookie('appointo_language_code'), false), '|') + 1);

            App::setLocale($$code);
        }
    }

    public function index()
    {

        if (!request()->location) {
            $sessionLocation = session('sess_location');
        }
        else {
            session(['sess_location' => request()->location]);
            $sessionLocation = request()->location;
        }

        $location = Location::where('id', $sessionLocation)->first();
        $first_location = Location::first()->id;

        $categories = Category::active()
            ->with([
                'services' => function ($query) use ($location, $first_location) {
                    // if no location is in sessionLocation then this code is use.

                    if ($location !== null) {
                        $query->active()->where('location_id', $location->id);
                    }
                    else {
                        $query->active()->where('location_id', $first_location);
                    }
                }
            ])->latest()->take('8')->get();

        $themeOneCategoryView = view('sections.theme_one_categories', compact('categories'))->render();
        $themeTwoCategoryView = view('sections-new.theme_two_categories', compact('categories'))->render();

        $services = BusinessService::active()->with('category')->whereHas(
            'category', function ($q) {
                if (request()->category) {
                    $q->active()->where('id', request()->category);
                }
                else {
                    $q->active();
                }
            }
        );

        if ($location !== null) {
            $services = $services->where('location_id', $location->id);
        }
        else {
            $services = $services->where('location_id', $first_location);
        }

        if (request()->serviceFilter == 'online' || request()->serviceFilter == 'offline'){
            $services = $services->where('service_type', request()->serviceFilter);
        }

        $services = $services->paginate(8);

        $deals = Deal::active()
            ->with(['location', 'services'])
            ->where('start_date_time', '<=', Carbon::now('UTC')->setTimezone($this->settings->timezone))
            ->where('end_date_time', '>=', Carbon::now('UTC')->setTimezone($this->settings->timezone))
            ->whereRaw('json_contains(days, \'["' . Carbon::now('UTC')->setTimezone($this->settings->timezone)->isoFormat('dddd') . '"]\')');

        $advertisement = AdvertisementBanner::get();

        if ($location !== null) {
            $deals = $deals->where('location_id', $location->id);
        }

        $deals = $deals->latest()->take('6')->get();

        $images = Media::select('id', 'file_name')->where('is_section_content', 'no')->latest()->get();
        $section_contents = Media::where('is_section_content', 'yes')->latest()->get();
        $customerFeedbacks = CustomerFeedback::where('status', 'active')->latest()->get();

        if (request()->ajax()) {
            if ($this->frontThemeSettings->front_theme == 'theme-2') {
                $view = view('front-new.all_categories', compact('categories'))->render();
                $html = view('front-new.all_deals', compact('deals'))->render();

                return Reply::dataOnly(['view' => $view, 'html' => $html, 'categories' => $categories, 'themeTwoCategoryView' => $themeTwoCategoryView, 'services' => $services, 'deals' => $deals, 'deal_count' => $deals->count()]);
            }

            $view = view('front.all_services', compact('services'))->render();
            $html = view('front.all_deals', compact('deals'))->render();

            return Reply::dataOnly(['view' => $view, 'html' => $html, 'categories' => $categories, 'themeTwoCategoryView' => $themeTwoCategoryView, 'themeOneCategoryView' => $themeOneCategoryView, 'services' => $services, 'deals' => $deals, 'deal_count' => $deals->count()]);
        }

        $googleMapAPIKey = $this->googleMapAPIKey;

        if ($this->frontThemeSettings->front_theme == 'theme-2') {
            return view('front-new.index', compact('deals', 'advertisement', 'categories', 'images', 'section_contents', 'customerFeedbacks', 'themeTwoCategoryView', 'googleMapAPIKey'));
        }

        return view('front.index', compact('categories', 'advertisement', 'themeOneCategoryView', 'images', 'section_contents', 'customerFeedbacks', 'googleMapAPIKey'));

    }

    public function getLocation(Request $request)
    {
        $newDeals = NewDeal::where('status', 'active')->where('location_id', $request->id)->first();

        $html = view('front-new.newDeal', compact('newDeals'))->render();
        return Reply::dataOnly(['html' => $html]);

    }

    public function addOrUpdateProduct(Request $request)
    {
        $newProduct = [
            'id' => $request->id,
            'name' => $request->name,
            'type' => $request->type,
            'price' => $request->price,
            'unique_id' => $request->unique_id,
            'service_type' => $request->service_type,
        ];

        $products = [];
        $quantity = $request->quantity ?? 1;

        if ($request->type == 'deal') {

            $deals = Deal::where('id', $request->id)
                ->with(['dealTaxes'])->first();

            $tax = [];

            if ($deals->dealTaxes) {
                foreach ($deals->dealTaxes as $key => $deal) {
                    $taxDetail = Tax::select('id', 'tax_name', 'percent')->active()->where('id', $deal->tax_id)->first();
                    $tax[] = $taxDetail;
                }
            }

            $newProduct = Arr::add($newProduct, 'tax', json_encode($tax));
            $newProduct = Arr::add($newProduct, 'max_order', $request->max_order);
        }

        if ($request->type == 'service') {
            $services = BusinessService::where('id', $request->id)
                ->with(['taxServices'])->first();

            $tax = [];

            if ($services->taxServices) {
                foreach ($services->taxServices as $key => $service) {
                    $taxDetail = Tax::select('id', 'tax_name', 'percent')->active()->where('id', $service->tax_id)->first();
                    $tax[] = $taxDetail;
                }
            }

            $newProduct = Arr::add($newProduct, 'tax', json_encode($tax));
        }

        if (!$request->hasCookie('products')) {
            $newProduct = Arr::add($newProduct, 'quantity', $quantity);
            $products = Arr::add($products, $request->unique_id, $newProduct);
            $this->products = $products;
            return response([
                'status' => 'success',
                'message' => __('messages.front.success.productAddedToCart'),
                'productsCount' => count($products),
                'productView' => view('front-new.item-list', $this->data)->render()
            ])->cookie('products', json_encode($products));
        }

        /* If type is different than existing service type */
        $products = json_decode($request->cookie('products'), true);

        $unique_key = array_keys($products);
        $service_type = $products[$unique_key[0]]['service_type'];

        if($service_type != $request->service_type) {
            return Reply::error(__('app.differentServiceTypeMessage', ['type' => $service_type]));
        }

        /* If user select same service more than one */
        if($request->serviceType == 'online')
        {
            if ($request->hasCookie('products'))
            {
                return Reply::error(__('app.oneOnlineService'));
            }
        }
        else
        {
            if($request->hasCookie('products'))
            {
                $products = json_decode($request->cookie('products'), true);

                if(count($products) == 1)
                {
                    $unique_key = array_keys($products);
                    $unique_key = $unique_key[0];
                    $service_type = $products[$unique_key]['service_type'];

                    if($service_type == 'online')
                    {
                        return Reply::error(__('app.oneOnlineService'));
                    }

                }

            }
        }

        /* If type is deal and max_order_per_customer is exceeded,then block increasing quantity */
        if ($request->type == 'deal' && array_key_exists($request->unique_id, $products) && $this->checkDealQuantity($request->id) !== 0 && $this->checkDealQuantity($request->id) <= $products[$request->unique_id]['quantity']) {
            return Reply::error(__('app.maxDealMessage', ['quantity' => $this->checkDealQuantity($request->id)]));
        }

        $types = [];

        foreach ($products as $key => $product) {
            $types[] = $product['type'];
        }

        /* Checking if item has different type then cart item */
        if (!in_array($request->type, $types)) {
            return response(['result' => 'fail', 'message' => __('messages.front.errors.addOneItemAtATime')])->cookie('products', json_encode($products));
        }

        if (!array_key_exists($request->unique_id, $products)) {
            $newProduct = Arr::add($newProduct, 'quantity', $quantity);
            $newProduct = Arr::add($newProduct, 'tax', json_encode($tax));
            $products = Arr::add($products, $request->unique_id, $newProduct);
            $this->products = $products;

            return response([
                'status' => 'success',
                'message' => __('messages.front.success.productAddedToCart'),
                'productsCount' => count($products),
                'productView' => view('front-new.item-list', $this->data)->render()
            ])->cookie('products', json_encode($products));
        }
        else {
            if ($request->quantity) {
                $products[$request->unique_id]['quantity'] = $request->quantity;
            }
            else {
                $products[$request->unique_id]['quantity'] += 1;
            }
        }

        $this->products = $products;

        return response([
            'status' => 'success',
            'message' => __('messages.front.success.cartUpdated'),
            'productsCount' => count($products),
            'productView' => view('front-new.item-list', $this->data)->render()
        ])->cookie('products', json_encode($products));
    }

    public function checkDealQuantity($dealId)
    {
        $deal = Deal::find($dealId);
        $max_order_per_customer = !is_null($deal->max_order_per_customer) ? $deal->max_order_per_customer : 0;

        return $max_order_per_customer;
    }

    public function bookingPage(Request $request)
    {
        $bookingDetails = [];

        if ($request->hasCookie('bookingDetails')) {
            $bookingDetails = json_decode($request->cookie('bookingDetails'), true);
        }

        if ($request->ajax()) {
            return Reply::dataOnly(['status' => 'success', 'productsCount' => $this->productsCount]);
        }

        $locale = App::getLocale();

        return view('front.booking_page', compact('bookingDetails', 'locale'));
    }

    public function manageBooking(Request $request)
    {
        $products       = json_decode($request->cookie('products'), true);
        $bookingDetails = json_decode($request->cookie('bookingDetails'), true);
        $couponData     = json_decode($request->cookie('couponData'), true);
        $tax = Tax::active()->first();
        $categories = Category::with('services')->has('services', '>', 0)->active()->get();
        $locale = App::getLocale();
        $service_type = '';

        foreach($products as $product)
        {
            $service_type = $product['service_type'];
            break;
        }

        $credentials = PaymentGatewayCredentials::first();
        /* $booking = Booking::with('deal', 'users')->where([
            'user_id' => $this->user->id
            ])
            ->latest()
            ->first(); */

        $setting = CompanySetting::with('currency')->first();
        $frontThemeSetting = $this->frontThemeSettings;
        $coupons = Coupon::active()->where('start_date_time', '<=', Carbon::now()->setTimezone($this->settings->timezone))
            ->where('end_date_time', '>=', Carbon::now()->setTimezone($this->settings->timezone))->get();

        $type = '';

        if (!is_null(json_decode($request->cookie('products'), true))) {
            $product = (array)json_decode(request()->cookie('products', true));
            $keys = array_keys($product);
            $type = $product[$keys[0]]->type == 'deal' ? 'deal' : 'booking';
        }

        $tax = 0;
        $taxAmount = 0;
        $taxName = [];
        $taxPercent = 0;
        $Amt = 0;

        if ($products) {
            foreach ($products as $key => $product) {
                if ($type !== 'deal') {
                    $taxes = ItemTax::with('tax')->where('service_id', $product['id'])->get();
                }
                else {
                    $taxes = ItemTax::with('tax')->where('deal_id', $product['id'])->get();
                }

                $tax = 0;

                foreach ($taxes as $key => $value) {
                    $tax += $value->tax->percent;
                    $taxName[] = $value->tax->name;
                    $taxPercent += $value->tax->percent;
                }

                $Amt = $product['price'] * $product['quantity'];
                $taxAmount += ($Amt * $tax) / 100;
            }
        }

        return view('front-new.booking', compact('coupons', 'setting', 'credentials', 'frontThemeSetting', 'products', 'bookingDetails', 'couponData', 'tax', 'categories', 'locale', 'type', 'service_type'));
    }

    public function cartPage(Request $request, $url = null)
    {
       
        $products       = json_decode($request->cookie('products'), true);
        $bookingDetails = json_decode($request->cookie('bookingDetails'), true);
        $couponData     = json_decode($request->cookie('couponData'), true);
        $taxes          = Tax::active()->first();
        $category_id    = '';
        $categories     = Category::with('services')->has('services', '>', 0)->active()->get();
        $coupons = Coupon::active()->where('start_date_time', '<=', Carbon::now()->setTimezone($this->settings->timezone))
            ->where('end_date_time', '>=', Carbon::now()->setTimezone($this->settings->timezone))->get();
        $type = '';

        if($products)
        {
            foreach ($products as $product)
            {
                $service = BusinessService::findOrFail($product['id']);
                Arr::set($product, 'name', $service->name);
                Arr::set($product, 'price', $service->discounted_price);
                Arr::set($product, 'service_type', $service->service_type);

                Arr::set($products, $service->id, $product);
            }
        }

        if(!is_null(json_decode($request->cookie('products'), true)))
        {
            $product = (array)json_decode(request()->cookie('products', true));
            $keys = array_keys($product);
            $type = $product[$keys[0]]->type == 'deal' ? 'deal' : 'booking';
        }

        $url = $url ? $url : '';

        if ($this->frontThemeSettings->front_theme == 'theme-2') {
            return view('front-new.cart', compact('url', 'bookingDetails', 'products', 'taxes', 'category_id', 'categories', 'type'));
        }

        return view('front.cart_page', compact('coupons', 'products', 'bookingDetails', 'taxes', 'couponData', 'type'));
    }

    public function addBookingDetails(CartPageRequest $request)
    {
        $expireTime = Carbon::parse($request->bookingDate . ' ' . $request->bookingTime, $this->settings->timezone);
        $cookieTime = Carbon::now()->setTimezone($this->settings->timezone)->diffInMinutes($expireTime);

        $emp_name = '';

        if (!empty($request->selected_user)) {
            $emp_name = User::find($request->selected_user)->name;
        }

        if (!is_null($expireTime)) {
            $getDate = $expireTime->format('d M Y h:i A');
        }
        else {
            $getDate = '';
        }

        $empId = $request->selected_user;

        return response(Reply::dataOnly(['status' => 'success', 'getDate' => $getDate, 'empId' => $empId]))->cookie('bookingDetails', json_encode(['bookingDate' => $request->bookingDate, 'bookingTime' => $request->bookingTime, 'selected_user' => $request->selected_user, 'emp_name' => $emp_name]), $cookieTime);
    }

    public function deleteProduct(Request $request, $id)
    {
        $products = json_decode($request->cookie('products'), true);

        if ($id != 'all') {
            Arr::forget($products, $id);
        }
        else {

            return response(Reply::successWithData(__('messages.front.success.cartCleared'), ['action' => 'redirect', 'url' => route('front.cartPage'), 'productsCount' => count($products)]))
                ->withCookie(Cookie::forget('bookingDetails'))
                ->withCookie(Cookie::forget('products'))
                ->withCookie(Cookie::forget('couponData'));
        }

        if (count($products) > 0) {
            setcookie('products', '', time() - 3600);
            return response(Reply::successWithData(__('messages.front.success.productDeleted'), ['productsCount' => count($products), 'products' => $products]))->cookie('products', json_encode($products));
        }

        return response(Reply::successWithData(__('messages.front.success.cartCleared'), ['action' => 'redirect', 'url' => route('front.cartPage'), 'productsCount' => count($products)]))->withCookie(Cookie::forget('bookingDetails'))->withCookie(Cookie::forget('products'))->withCookie(Cookie::forget('couponData'));
    }

    public function clearCartProduct(Request $request, $id = 'all')
    {

        $products = json_decode($request->cookie('products'), true);

        $productsCount = 0;

        if ($products) {
            $productsCount = count($products);
        }

        if ($id != 'all') {
            Arr::forget($products, $id);
        }
        else {

            return response(Reply::successWithData(__('messages.front.success.cartCleared'), ['action' => 'redirect', 'url' => route('front.index'), 'productsCount' => $productsCount]))
                ->withCookie(Cookie::forget('bookingDetails'))
                ->withCookie(Cookie::forget('products'))
                ->withCookie(Cookie::forget('couponData'));
        }

        if (count($products) > 0) {
            setcookie('products', '', time() - 3600);
            return response(Reply::successWithData(__('messages.front.success.productDeleted'), ['productsCount' => count($products), 'products' => $products]))->cookie('products', json_encode($products));
        }

        return response(Reply::successWithData(__('messages.front.success.cartCleared'), ['action' => 'redirect', 'url' => route('front.index'), 'productsCount' => count($products)]))->withCookie(Cookie::forget('bookingDetails'))->withCookie(Cookie::forget('products'))->withCookie(Cookie::forget('couponData'));
    }

    public function updateCart(Request $request)
    {
        $product = $request->products;

        if ($request->type == 'deal' && $request->currentValue > $request->max_order) {
            $product[$request->unique_id]['quantity'] = $request->max_order;

            return response(Reply::error(__('app.maxDealMessage', ['quantity' => $request->max_order])));
        }

        return response(Reply::success(__('messages.front.success.cartUpdated')))->cookie('products', json_encode($request->products));
    }

    public function checkoutPage()
    {
        $products = (array)json_decode(request()->cookie('products', true));
        $keys = array_keys($products);
        $this->request_type = $products[$keys[0]]->type == 'deal' ? 'deal' : 'booking';
        $this->emp_name = '';

        if (!empty(json_decode(request()->cookie('bookingDetails'))->selected_user)) {
            $this->emp_name = User::find(json_decode(request()->cookie('bookingDetails'))->selected_user)->name;
        }

        $this->bookingDetails = request()->hasCookie('bookingDetails') ? json_decode(request()->cookie('bookingDetails'), true) : [];
        $couponData     = request()->hasCookie('couponData') ? json_decode(request()->cookie('couponData'), true) : [];
        $Amt = 0;
        $tax = 0;
        $totalAmount = 0;
        $taxAmount = 0;

        if ($this->request_type !== 'deal') {
            foreach ($products as $key => $service) {
                $taxes = ItemTax::with('tax')->where('service_id', $service->id)->get();
                $tax = 0;

                foreach ($taxes as $key => $value) {
                    $tax += $value->tax->percent;
                }

                $Amt = $service->price * $service->quantity;
                $taxAmount += ($Amt * $tax) / 100;
                $totalAmount += $service->price * $service->quantity;
            }
        } else {
            foreach ($products as $key => $deal) {
                $taxes = ItemTax::with('tax')->where('deal_id', $deal->id)->get();
                $tax = 0;

                foreach ($taxes as $key => $value) {
                    $tax += $value->tax->percent;
                }

                $Amt = $deal->price * $deal->quantity;
                $taxAmount += ($Amt * $tax) / 100;
                $totalAmount += $deal->price * $deal->quantity;
            }
        }

        if ($couponData) {
            $totalAmount -= $couponData['applyAmount'];
        }

        if ($taxAmount > 0) {
            $totalAmount = $taxAmount + $totalAmount;
        }

        $this->totalAmount = round($totalAmount, 2);

        return view('front.checkout_page', $this->data);
    }

    public function paymentFail(Request $request, $bookingId = null)
    {
        $credentials = PaymentGatewayCredentials::first();

        if ($bookingId == null) {
            $booking = Booking::where([
                'user_id' => $this->user->id
            ])
                ->latest()
                ->first();
        }
        else {
            $booking = Booking::where(['id' => $bookingId, 'user_id' => $this->user->id])->first();
        }

        $setting = CompanySetting::with('currency')->first();
        $user = $this->user;

        $categories = Category::with('services')->has('services', '>', 0)->active()->get();

        if ($this->frontThemeSettings->front_theme == 'theme-2') {
            return view('front-new.payment', compact('categories', 'credentials', 'booking', 'user', 'setting'));
        }

        return view('front.payment', compact('credentials', 'booking', 'user', 'setting'));
    }

    public function paymentSuccess(Request $request, $bookingId = null)
    {
        $credentials = PaymentGatewayCredentials::first();

        if ($bookingId == null) {
            $booking = Booking::where([
                'user_id' => $this->user->id
            ])
                ->latest()
                ->first();
        }
        else {
            $booking = Booking::where(['id' => $bookingId, 'user_id' => $this->user->id])->first();
        }

        $setting = CompanySetting::with('currency')->first();
        $user = $this->user;

        if ($booking->payment_status !== 'completed') {
            $booking->payment_status = 'completed';
            $booking->save();
        }

        $categories = Category::with('services')->has('services', '>', 0)->active()->get();

        if ($this->frontThemeSettings->front_theme == 'theme-2') {
            return view('front-new.payment', compact('categories', 'credentials', 'booking', 'user', 'setting'));
        }

        return view('front.payment', compact('credentials', 'booking', 'user', 'setting'));
    }

    public function paymentGateway(Request $request)
    {
        $credentials = PaymentGatewayCredentials::first();
        $booking = Booking::with('deal', 'users')->where([
            'user_id' => $this->user->id
        ])
            ->latest()
            ->first();

        $emp_name = '';

        if (array_key_exists(0, $booking->users->toArray())) {
            $emp_name = $booking->users->toArray()[0]['name'];
        }

        $setting = CompanySetting::with('currency')->first();
        $frontThemeSetting = $this->frontThemeSettings;
        $user = $this->user;

        if ($booking->payment_status == 'completed') {
            return redirect(route('front.index'));
        }

        return view('front.payment-gateway', compact('credentials', 'booking', 'user', 'setting', 'frontThemeSetting', 'emp_name'));
    }

    public function offlinePayment($bookingId = null)
    {
        if ($bookingId == null) {
            $booking = Booking::where([
                'user_id' => $this->user->id
            ])
                ->latest()
                ->first();
        }
        else {
            $booking = Booking::where(['id' => $bookingId, 'user_id' => $this->user->id])->first();
        }

        if (!$booking || $booking->payment_status == 'completed') {
            return redirect()->route('front.index');
        }

        $booking->payment_status = 'pending';
        $booking->save();

        $admins = User::allAdministrators()->get();
        Notification::send($admins, new NewBooking($booking));
        $user = User::findOrFail($booking->user_id);
        $user->notify(new BookingConfirmation($booking));

        $categories = Category::with('services')->has('services', '>', 0)->active()->get();

        if ($this->frontThemeSettings->front_theme == 'theme-2') {
            return view('front-new.booking_success', compact('categories'))->withCookie(Cookie::forget('bookingDetails'))->withCookie(Cookie::forget('couponData'))->withCookie(Cookie::forget('products'));
        }

        return view('front.booking_success');
    }

    public function bookingSlots(Request $request)
    {
        if(!is_null($this->user) && $this->settings->booking_per_day != (0 || '') && $this->settings->booking_per_day <= $this->user->userBookingCount(Carbon::createFromFormat('Y-m-d', $request->bookingDate))){
            $msg = __('messages.reachMaxBooking').Carbon::createFromFormat('Y-m-d', $request->bookingDate)->format('Y-m-d');
            return Reply::dataOnly(['status' => 'fail', 'msg' => $msg]);
        }

        $location = Location::with('timezone')->findOrFail($request->location_id);
        $bookingDate = Carbon::createFromFormat('Y-m-d', $request->bookingDate);
        $day = $bookingDate->format('l');
        $bookingTime = BookingTime::where('location_id', $request->location_id)->where('day', strtolower($day))->first();
        $officeLeaves = OfficeLeave::where('start_date', $request->bookingDate)
            ->orWhere('end_date', $request->bookingDate)->get();

        if($officeLeaves->count() > 0){
            $msg = __('messages.ShopClosed');
            return Reply::dataOnly(['status' => 'shopclosed', 'msg' => $msg]);
        }

        // Check if multiple booking allowed
        $bookings = Booking::select('id', 'date_time')->where(DB::raw('DATE(date_time)'), $bookingDate->format('Y-m-d'));

        if ($bookingTime->max_booking_per_day != (0 || '') && $bookingTime->max_booking_per_day <= $bookings->count())
        {
            $msg = __('messages.reachMaxBookingPerDay') . Carbon::createFromFormat('Y-m-d', $request->bookingDate)->format('Y-m-d');
            return Reply::dataOnly(['status' => 'fail', 'msg' => $msg]);
        }

        if ($bookingTime->multiple_booking == 'no') {
            $bookings = $bookings->get();
        }
        else {
            $bookings = $bookings->whereRaw('DAYOFWEEK(date_time) = '.($bookingDate->dayOfWeek + 1))->get();
        }

        $variables = compact('bookingTime', 'bookings');

        if ($bookingTime->status == 'enabled') {
            if ($this->settings->time_format == 'H:i') {
                $time = Carbon::parse($request->bookingDate. ' ' .$bookingTime->utc_start_time)->format('Y-m-d H:i');
                $startTime = Carbon::createFromFormat('Y-m-d ' .$this->settings->time_format, $time);
            }
            else {
                $startTime = Carbon::createFromFormat('Y-m-d ' .$this->settings->time_format, $request->bookingDate. ' ' .$bookingTime->utc_start_time->format($this->settings->time_format));
            }

            if ($bookingDate->day === Carbon::today()->day) {
                while ($startTime->lessThan(Carbon::now())) {
                    $startTime = $startTime->addMinutes($bookingTime->slot_duration);
                }
            }

            if ($this->settings->time_format == 'H:i') {
                $times = Carbon::parse($request->bookingDate. ' ' .$bookingTime->utc_end_time)->format('Y-m-d H:i');
                $endTime = Carbon::createFromFormat('Y-m-d ' .$this->settings->time_format, $times);
            }
            else {
                $endTime = Carbon::createFromFormat('Y-m-d ' .$this->settings->time_format, $request->bookingDate. ' ' .$bookingTime->utc_end_time->format($this->settings->time_format));
            }

            $startTime->setTimezone($location->timezone ? $location->timezone->zone_name : '');
            $endTime->setTimezone($location->timezone ? $location->timezone->zone_name : '');

            if($startTime->gt($endTime))
            {
                $startTime->subDay();
            }

            $variables = compact('startTime', 'endTime', 'bookingTime', 'bookings');
        }

        if ($this->frontThemeSettings->front_theme == 'theme-2') {
            $view = view('front-new.booking_slots', $variables)->render();
            return Reply::dataOnly(['status' => 'success', 'view' => $view]);
        }

        $view = view('front.booking_slots', $variables)->render();
        return Reply::dataOnly(['status' => 'success', 'view' => $view]);
    }

    public function saveBooking(StoreFrontBooking $request)
    {
        if ($this->user) {
            $user = $this->user;

            $address = Address::firstOrNew(['user_id' => $user->id]);
            $address->house_no = $request->house_no;
            $address->address_line = $request->address_line;
            $address->city = $request->city;
            $address->state = $request->address_line;
            $address->pin_code = $request->pin_code;
            $address->country_id = $request->country_id;
            $address->save();
        }
        else {
            $user = User::firstOrNew(['email' => $request->email]);
            $user->name = $request->first_name . ' ' . $request->last_name;
            $user->email = $request->email;
            $user->mobile = $request->phone;
            $user->calling_code = $request->calling_code;
            $user->password = '123456';
            $user->save();

            $address = Address::firstOrNew(['user_id' => $user->id]);
            $address->house_no = $request->house_no;
            $address->address_line = $request->address_line;
            $address->city = $request->city;
            $address->state = $request->address_line;
            $address->pin_code = $request->pin_code;
            $address->country_id = $request->country_id;
            $address->save();

            $user->attachRole(Role::where('name', 'customer')->withoutGlobalScopes()->first()->id);

            Auth::loginUsingId($user->id);
            $this->user = $user;

            if ($this->smsSettings->nexmo_status == 'active' && !$user->mobile_verified) {
                // Verify user mobile number
                if ($this->frontThemeSettings->front_theme == 'theme-2') {
                    return Reply::successWithData(__('messages.front.success.userCreated'), ['action' => 'userCreated']);
                }

                return response(Reply::redirect(route('front.checkoutPage'), __('messages.front.success.userCreated')));
            }

            $user->notify(new NewUser('123456'));
        }

        /* If deal is processing */
        if ($request->request_type == 'deal' && !is_null(json_decode($request->cookie('products'), true))) {
            $products = json_decode($request->cookie('products'), true);

            if (is_null($products)) {
                return response(Reply::redirect(route('front.index')));
            }

            $products = (array)json_decode(request()->cookie('products', true));
            $keys = array_keys($products);
            $deal_id = $products[$keys[0]]->id;
            $deal_price = $products[$keys[0]]->price;
            $deal_quantity = $products[$keys[0]]->quantity;
            $type = $products[$keys[0]]->type == 'deal' ? 'deal' : 'booking';

            $products = json_decode($request->cookie('products'), true);

            $tax = 0;
            $Amt = 0;
            $Amount = 0;
            $taxName = [];
            $taxAmount = 0;
            $taxPercent = 0;

            foreach ($products as $key => $product) {
                $taxes = ItemTax::with('tax')->where('deal_id', $product['id'])->get();
                $tax = 0;

                foreach ($taxes as $key => $value) {
                    $tax += $value->tax->percent;
                    $taxName[] = $value->tax->name;
                    $taxPercent += $value->tax->percent;
                }

                $Amt = $product['price'] * $product['quantity'];
                $Amount += $product['price'] * $product['quantity'];
                $taxAmount += ($Amt * $tax) / 100;
            }

            $amountToPay = ($Amount + $taxAmount);

            $booking = new Booking();
            $booking->user_id = $user->id;
            $booking->deal_id = $deal_id;
            $booking->deal_quantity = $deal_quantity;
            $booking->status = 'pending';
            $booking->payment_gateway = 'cash';
            $booking->original_amount = $Amount;
            $booking->discount = '0';
            $booking->discount_percent = '0';
            $booking->payment_status = 'pending';
            $booking->additional_notes = $request->additional_notes;
            $booking->source = 'online';
            $booking->tax_name = json_encode($taxName);
            $booking->tax_percent = $taxPercent;
            $booking->tax_amount = $taxAmount;
            $booking->amount_to_pay = $amountToPay;
            $booking->save();

            /* Save Deal Quantity */
            $deal = Deal::find($deal_id);
            $deal->used_time += $booking->deal_quantity;
            $deal->save();

            $deal_array = array();
            $deal_items = DealItem::where('deal_id', $booking->deal_id)->get();

            foreach ($deal_items as $key => $deal_item) {
                $unit_price = (($deal_item->unit_price * $deal_item->quantity) - $deal_item->discount_amount) / $deal_item->quantity;
                $deal_array[] = [
                    'booking_id' => $booking->id,
                    'business_service_id' => $deal_item->business_service_id,
                    'quantity' => $deal_item->quantity,
                    'unit_price' => $unit_price,
                    'amount' => $deal_item->total_amount
                ];
            }

            DB::table('booking_items')->insert($deal_array);

            if ($this->frontThemeSettings->front_theme == 'theme-2') {
                return response(Reply::successWithData(__('messages.front.success.bookingCreated'), ['action' => 'bookingCreated']))->withCookie(Cookie::forget('products'))->withCookie(Cookie::forget('couponData'));
            }

            return response(Reply::redirect(route('front.payment-gateway'), __('messages.front.success.bookingCreated')))->withCookie(Cookie::forget('products'))->withCookie(Cookie::forget('couponData'));
        }

        // Get products and bookingDetails
        $products       = json_decode($request->cookie('products'), true);
        $bookingDetails = json_decode($request->cookie('bookingDetails'), true);

        if (is_null($products) || is_null($bookingDetails)) {
            return response(Reply::redirect(route('front.index')));
        }

        // Get Applied Coupon Details
        $couponData = request()->hasCookie('couponData') ? json_decode(request()->cookie('couponData'), true) : [];

        // get bookings and bookingTime as per bookingDetails date
        $bookingDate = Carbon::createFromFormat('Y-m-d', $bookingDetails['bookingDate']);
        $day = $bookingDate->format('l');
        $bookingTime = BookingTime::where('day', strtolower($day))->first();

        $bookings = Booking::select('id', 'date_time')->where(DB::raw('DATE(date_time)'), $bookingDate->format('Y-m-d'))->whereRaw('DAYOFWEEK(date_time) = ' . ($bookingDate->dayOfWeek + 1))->get();

        if ($bookingTime->max_booking != 0 && $bookings->count() > $bookingTime->max_booking) {

            return response(Reply::redirect(route('front.bookingPage')))->withCookie(Cookie::forget('bookingDetails'));
        }

        $originalAmount = $taxAmount = $amountToPay = $discountAmount = $couponDiscountAmount = 0;

        $tax = 0;
        $Amt = 0;
        $Amount = 0;
        $taxName = [];
        $taxAmount = 0;
        $taxPercent = 0;
        $bookingItems = array();

        foreach ($products as $key => $product) {
            $amount = ($product['quantity'] * $product['price']);

            $bookingItems[] = [
                'business_service_id' => $key,
                'quantity' => $product['quantity'],
                'unit_price' => $product['price'],
                'amount' => $amount
            ];

            $originalAmount = ($originalAmount + $amount);

            $taxes = ItemTax::with('tax')->where('service_id', $product['id'])->get();
            $tax = 0;

            foreach ($taxes as $key => $value) {
                $tax += $value->tax->percent;
                $taxName[] = $value->tax->name;
                $taxPercent += $value->tax->percent;
            }

            $Amt = $product['price'] * $product['quantity'];
            $Amount += $product['price'] * $product['quantity'];
            $taxAmount += ($Amt * $tax) / 100;
        }

        $amountToPay = ($originalAmount + $taxAmount);

        if ($couponData) {
            $amountToPay -= $couponData['applyAmount'];
            $couponDiscountAmount = $couponData['applyAmount'];
        }

        $amountToPay = round($amountToPay, 2);

        $unique_key = array_keys($products);
        $service_type = $products[$unique_key[0]]['service_type'];

        $booking = new Booking();
        $booking->user_id = $user->id;
        $booking->date_time = Carbon::createFromFormat('Y-m-d', $bookingDetails['bookingDate'])->format('Y-m-d') . ' ' . Carbon::createFromFormat('H:i:s', $bookingDetails['bookingTime'])->format('H:i:s');
        $booking->status = 'pending';
        $booking->payment_gateway = 'cash';
        $booking->original_amount = $originalAmount;
        $booking->discount = $discountAmount;
        $booking->discount_percent = '0';
        $booking->payment_status = 'pending';
        $booking->booking_type = $service_type;
        $booking->additional_notes = $request->additional_notes;
        $booking->source = 'online';

        if (!is_null($tax)) {
            $booking->tax_name = json_encode($taxName);
            $booking->tax_percent = $tax;
            $booking->tax_amount = $taxAmount;
        }

        if (count($couponData) > 0 && !is_null($couponData)) {
            $booking->coupon_id = $couponData[0]['id'];
            $booking->coupon_discount = $couponDiscountAmount;
            $coupon = Coupon::findOrFail($couponData[0]['id']);
            $coupon->used_time = ($coupon->used_time + 1);
            $coupon->save();
        }

        $booking->amount_to_pay = $amountToPay;
        $booking->save();

        // Assign Suggested User To Booking,  _COOKIE['selected_user']
        if (!empty(json_decode($request->cookie('bookingDetails'))->selected_user)) {
            $booking->users()->attach(json_decode($request->cookie('bookingDetails'))->selected_user);
            setcookie('selected_user', '', time() - 3600);
        }
        else {
            if ($this->suggestEmployee($booking->date_time)) {
                $booking->users()->attach($this->suggestEmployee($booking->date_time));
                setcookie('user_id', '', time() - 3600);
            }
        }

        foreach ($bookingItems as $key => $bookingItem) {
            $bookingItems[$key]['booking_id'] = $booking->id;
        }

        foreach($bookingItems as $bookingItem) {
            $item = new BookingItem();
            $item->business_service_id = $bookingItem['business_service_id'] ? $bookingItem['business_service_id'] : null;
            $item->quantity = $bookingItem['quantity'];
            $item->unit_price = $bookingItem['unit_price'];
            $item->amount = $bookingItem['amount'];
            $item->booking_id = $bookingItem['booking_id'];
            $item->save();
        }

        if ($this->frontThemeSettings->front_theme == 'theme-2') {
            return response(Reply::successWithData(__('messages.front.success.bookingCreated'), ['action' => 'bookingCreated', 'booking' => $booking]))->withCookie(Cookie::forget('bookingDetails'))->withCookie(Cookie::forget('couponData'))->withCookie(Cookie::forget('products'));
        }

        return response(Reply::redirect(route('front.payment-gateway'), __('messages.front.success.bookingCreated')))->withCookie(Cookie::forget('bookingDetails'))->withCookie(Cookie::forget('couponData'))->withCookie(Cookie::forget('products'));
    }

    public function allServices(Request $request)
    {
        if ($request->ajax()) {
            $services = BusinessService::with(['location', 'category'])->active();

            if(!is_null($request->serviceFilter)) {
                if ($request->serviceFilter != 'all') {
                    $services = $services->where('service_type', $request->serviceFilter);
                }
            }

            if(!is_null($request->locations)) {
                $services = $services->whereIn('location_id', $request->locations);
            }

            if (!is_null($request->category)) {
                $services = $services->where('category_id', $request->category);
            }

            if (!is_null($request->term)) {
                $services = $services->where('name', 'like', '%' . $request->term . '%');
            }

            $services = $services->get();

            if(!is_null($request->service_type))
            {
                $serviceType = $request->service_type;
                $services = $services->whereIn('service_type', $serviceType);
            }

            $deals = Deal::active()->with('location', 'services');

            if (!is_null($request->locations)) {
                $deals = $deals->where('location_id', $request->locations);
            }

            $deals = $deals->where('start_date_time', '<=', Carbon::now()->setTimezone($this->settings->timezone))->where('end_date_time', '>=', Carbon::now()->setTimezone($this->settings->timezone))->get();
            $url = $request->url;

            if ($request->url == 'deal') {
                $view = view('front-new.filtered_deals', compact('deals'))->render();
                return Reply::dataOnly(['view' => $view, 'url' => $url, 'deals_count' => $deals->count()]);
            }

            $view = view('front-new.filtered_services', compact('services'))->render();
            return Reply::dataOnly(['view' => $view, 'url' => $url, 'service_count' => $services->count()]);
        }

        /* end of ajax */

        $category_id = '';

        if ($request->category_id && $request->category_id != 'all') {

            $category_id = Category::where('slug', $request->category_id)->first();

            if (!$category_id) {
                abort(404);
            }
        }

        $products       = json_decode($request->cookie('products'), true);
        $bookingDetails = json_decode($request->cookie('bookingDetails'), true);
        $couponData     = json_decode($request->cookie('couponData'), true);
        $tax            = Tax::active()->first();
        $categories = Category::with('services')->has('services', '>', 0)->active()->get();

        $type = '';

        if (!is_null(json_decode($request->cookie('products'), true))) {
            $product = (array)json_decode(request()->cookie('products', true));
            $keys = array_keys($product);
            $type = $product[$keys[0]]->type == 'deal' ? 'deal' : 'booking';
        }

        $url = $request->url;

        return view('front-new.cart', compact('url', 'categories', 'category_id', 'products', 'bookingDetails', 'couponData', 'tax', 'categories', 'type'));
    }

    public function searchServices(Request $request)
    {
        $services = [];

        if ($request->search_term !== null) {
            $location = Location::where('id', request()->location)->first();

            $categories = Category::active()
                ->where('name', 'LIKE', '%' . strtolower($request->search_term) . '%')
                ->with(['services' => function ($q) use ($location) {
                    if ($location !== null) {
                        $q->active()->where('location_id', $location->id);
                    }
                    else {
                        $q->active();
                    }
                }])->get();

            if ($categories->count() > 0) {
                foreach ($categories as $category) {
                    foreach ($category->services as $service) {
                        $services[] = $service;
                    }
                }
            }

            if ($location !== null) {
                $filteredServices = BusinessService::active()->where('name', 'LIKE', '%' . strtolower($request->search_term) . '%')->where('location_id', $location->id)->get();
            }
            else {
                $filteredServices = BusinessService::active()->where('name', 'LIKE', '%' . strtolower($request->search_term) . '%')->get();
            }

            foreach ($filteredServices as $service) {
                $services[] = $service;
            }

            $services = collect(array_unique($services));
        }
        else {
            $services = collect($services);
        }

        $tax         = Tax::active()->first();
        $products    = json_decode($request->cookie('products'), true);
        $categories  = Category::with('services')->has('services', '>', 0)->active()->get();
        $category_id = '';

        $type = '';

        if (!is_null(json_decode($request->cookie('products'), true))) {
            $product = (array)json_decode(request()->cookie('products', true));
            $keys = array_keys($product);
            $type = $product[$keys[0]]->type == 'deal' ? 'deal' : 'booking';
        }

        $url = '';

        if ($this->frontThemeSettings->front_theme == 'theme-2') {
            return view('front-new.cart', compact('url', 'services', 'categories', 'category_id', 'products', 'tax', 'type'));
        }

        return view('front.search_page', compact('services'));
    }

    public function getAllLocations()
    {
        $locations = Location::get();
        return Reply::dataOnly(['locations' => $locations]);
    }

    public function matchLocations(Request $request)
    {
        $record = Location::select('id', 'name', DB::raw('6371 * acos(cos(radians(' . $request->latitude . ')) * cos(radians(lat)) * cos(radians(lng) - radians(' . $request->longitude . ')) + sin(radians(' .$request->latitude. ')) * sin(radians(lat))) AS distance'))
            ->where('name', 'LIKE', '%' . $request->city . '%')
            ->orderBy('distance')
            ->get();

        return Reply::dataOnly(['locations' => $record]);
    }

    public function getLocationName(Request $request)
    {
        $location_name = Location::where('id', $request->locId)->first()->name;
        return Reply::dataOnly(['location_name' => $location_name]);
    }

    public function page($slug)
    {
        $page = Page::where('slug', $slug)->firstOrFail();

        $categories = Category::active()->with(['services' => function ($query) {
            $query->active();
        }])->get();

        if ($this->frontThemeSettings->front_theme == 'theme-1') {
            return view('front.page', compact('page'));
        }

        return view('front-new.contact_us', compact('page', 'categories'));
    }

    public function contact(ContactRequest $request)
    {
        $users = User::select('id', 'email', 'name')->allAdministrators()->get();
        Notification::send($users, new NewContact());
        return Reply::success(__('messages.front.success.emailSent'));
    }

    // @codingStandardsIgnoreLine
    public function serviceDetail(Request $request, $categorySlug, $serviceSlug)
    {
        $service = BusinessService::where('slug', $serviceSlug)->first();
        $reviews = ServiceReview::with('user')->where('service_id', $service->id)->get();
       // echo $reviews; die;
        $products = json_decode($request->cookie('products'), true) ?: [];

        $reqProduct = array_filter($products, function ($product) use ($service) {
            return $product['name'] == $service->name;
        });
        $categories = Category::with('services')->has('services', '>', 0)->active()->get();

        if ($this->frontThemeSettings->front_theme == 'theme-2') {
            return view('front-new.service_detail', compact(['service', 'reqProduct', 'categories','reviews']));
        }

        return view('front.service_detail', compact('service', 'reqProduct','reviews'));
    }

    // @codingStandardsIgnoreLine
    public function dealDetail(Request $request,  $dealId,  $dealSlug)
    {
        $deal = Deal::with('location')->where('id', $dealId)->firstOrFail();
        $categories = Category::with('services')->has('services', '>', 0)->active()->get();

        $products = json_decode($request->cookie('products'), true) ?: [];
        $reqProduct = array_filter($products, function ($product) use ($deal) {
            return $product['unique_id'] == 'deal' . $deal->id;
        });

        if ($this->frontThemeSettings->front_theme == 'theme-2') {
            return view('front-new.deal_detail', compact(['deal', 'categories', 'reqProduct']));
        }

        return view('front.deal_detail', compact('deal', 'reqProduct'));
    }

    public function changeLanguage($code)
    {
        $language = Language::where('language_code', $code)->first();

        if (!$language) {
            return Reply::error('invalid language code');
        }

        return response(Reply::success(__('messages.languageChangedSuccessfully')))->withCookie(cookie('appointo_language_code', $code));
    }

    /**
     * @param Request $request
     * @return $this|array|\Illuminate\Contracts\Routing\ResponseFactory|\Illuminate\Http\Response
     */
    public function applyCoupon(ApplyRequest $request)
    {
        $couponTitle = strtolower($request->coupon);
        $products    = json_decode($request->cookie('products'), true);
        $tax         = Tax::active()->first();

        $productAmount = 0;

        if (!$products) {
            return Reply::error(__('messages.coupon.addProduct'));
        }

        foreach ($products as $product) {
            $productAmount += $product['price'] * $product['quantity'];
        }

        if ($tax == null) {
            $percentAmount = 0;
        }
        else {
            $percentAmount = ($tax->percent / 100) * $productAmount;
        }

        $totalAmount   = ($productAmount + $percentAmount);

        $currentDate = Carbon::now($this->settings->timezone)->format('Y-m-d H:i:s');

        $couponData = Coupon::where('coupons.start_date_time', '<=', $currentDate)
            ->where(function ($query) use ($currentDate) {
                $query->whereNull('coupons.end_date_time')
                    ->orWhere('coupons.end_date_time', '>=', $currentDate);
            })
            ->where('coupons.status', 'active')
            ->where('coupons.title', $couponTitle)
            ->first();

        if (!is_null($couponData) && $couponData->minimum_purchase_amount != 0 && $couponData->minimum_purchase_amount != null && $productAmount < $couponData->minimum_purchase_amount) {
            return Reply::error(__('messages.coupon.minimumAmount') . ' ' . currencyFormatter($couponData->minimum_purchase_amount));
        }

        if (!is_null($couponData) && $couponData->used_time >= $couponData->uses_limit && $couponData->uses_limit != null && $couponData->uses_limit != 0) {
            return Reply::error(__('messages.coupon.usedMaximum'));
        }

        if (!is_null($couponData)) {
            $days = json_decode($couponData->days);
            $currentDay = Carbon::now()->format('l');

            if (in_array($currentDay, $days)) {
                if (!is_null($couponData->percent) && $couponData->percent != 0) {
                    $percentAmnt = round(($couponData->percent / 100) * $totalAmount, 2);

                    if (!is_null($couponData->amount) && $percentAmnt >= $couponData->amount) {
                        $percentAmnt = $couponData->amount;
                    }

                    return response(Reply::dataOnly(['amount' => $percentAmnt, 'couponData' => $couponData]))->cookie('couponData', json_encode([$couponData, 'applyAmount' => $percentAmnt]));
                }
                elseif (!is_null($couponData->amount) && (is_null($couponData->percent) || $couponData->percent == 0)) {
                    return response(Reply::dataOnly(['amount' => $couponData->amount, 'couponData' => $couponData]))->cookie('couponData', json_encode([$couponData, 'applyAmount' => $couponData->amount]));
                }
            } else {
                return response(
                    Reply::error(
                        __(
                            'messages.coupon.notValidToday',
                            ['day' => __('app.' . strtolower($currentDay))]
                        )
                    )
                );
            }
        }

        return Reply::error(__('messages.coupon.notMatched'));
    }

    /**
     * @param Request $request
     * @return $this|array|\Illuminate\Contracts\Routing\ResponseFactory|\Illuminate\Http\Response
     */
    public function updateCoupon(Request $request)
    {
        $couponTitle = strtolower($request->coupon);
        $products    = json_decode($request->cookie('products'), true);
        $tax         = Tax::active()->first();

        $productAmount = 0;

        foreach ($products as $product) {
            $productAmount += $product['price'] * $product['quantity'];
        }

        $percentAmount = ($tax->percent / 100) * $productAmount;
        $totalAmount   = ($productAmount + $percentAmount);

        $currentDate = Carbon::now()->format('Y-m-d H:i:s');

        $couponData = Coupon::where('coupons.start_date_time', '<=', $currentDate)
            ->where(function ($query) use ($currentDate) {
                $query->whereNull('coupons.end_date_time')
                    ->orWhere('coupons.end_date_time', '>=', $currentDate);
            })
            ->where('coupons.status', 'active')
            ->where('coupons.title', $couponTitle)
            ->first();

        if (!is_null($couponData) && $couponData->minimum_purchase_amount != 0 && $couponData->minimum_purchase_amount != null && $productAmount < $couponData->minimum_purchase_amount) {
            return Reply::errorWithoutMessage();
        }

        if (!is_null($couponData) && $couponData->used_time >= $couponData->uses_limit && $couponData->uses_limit != null && $couponData->uses_limit != 0) {
            return Reply::errorWithoutMessage();
        }

        if (!is_null($couponData) && $productAmount > 0) {
            $days = json_decode($couponData->days);
            $currentDay = Carbon::now()->format('l');

            if (in_array($currentDay, $days)) {

                if (!is_null($couponData->percent) && $couponData->percent != 0) {
                    $percentAmnt = round(($couponData->percent / 100) * $totalAmount, 2);

                    if (!is_null($couponData->amount) && $percentAmnt >= $couponData->amount) {
                        $percentAmnt = $couponData->amount;
                    }

                    return response(Reply::dataOnly(['amount' => $percentAmnt, 'couponData' => $couponData]))->cookie('couponData', json_encode([$couponData, 'applyAmount' => $percentAmnt]));
                }
                elseif (!is_null($couponData->amount) && (is_null($couponData->percent) || $couponData->percent == 0)) {
                    return response(Reply::dataOnly(['amount' => $couponData->amount, 'couponData' => $couponData]))->cookie('couponData', json_encode([$couponData, 'applyAmount' => $couponData->amount]));
                }
            } else {
                return Reply::errorWithoutMessage();
            }
        }

        return Reply::errorWithoutMessage();
    }

    /**
     * @param Request $request
     * @return $this|array|\Illuminate\Contracts\Routing\ResponseFactory|\Illuminate\Http\Response
     */
    public function removeCoupon(Request $request)
    {
        return response(Reply::dataOnly([]))->withCookie(Cookie::forget('couponData'));
    }

    public function checkUserAvailability(Request $request)
    {
        /* check for all employee of that service, of that particular location  */
        $location = Location::where('id', $request->location_id)->first();

        $dateTime = Carbon::createFromFormat('Y-m-d H:i:s', $request->date, $location->timezone->zone_name);

        [$service_ids, $service_names] = Arr::divide(json_decode($request->cookie('products'), true));

        $user_lists = BusinessService::with('users')->where('location_id', $request->location_id)->whereIn('id', $service_ids)->get();

        $all_users_of_particular_services = array();

        foreach ($user_lists as $user_list) {
            foreach ($user_list->users as $user) {
                $all_users_of_particular_services[] = $user->id;
            }
        }

        /* if no employee for that particular service is found then allow booking with null employee assignment  */
        if (empty($all_users_of_particular_services)) {
            return response(Reply::dataOnly(['continue_booking' => 'yes']));
        }

        /* Employee schedule: */
        $day = $dateTime->format('l');
        $time = $dateTime->format('H:i:s');
        $date = $dateTime->format('Y-m-d');
        $bookingTime = BookingTime::where('day', strtolower($day))->first();
        $slot_select = $date . ' ' . $time;
        $booking_slot = DB::table('bookings')->whereBetween('date_time', [$slot_select, $dateTime->addMinute($bookingTime->slot_duration)])
            ->get();

        if ($bookingTime->max_booking_per_slot != (0 || '') && $bookingTime->max_booking_per_slot <= $booking_slot->count()) {
            return response(Reply::dataOnly(['status' => 'fail']));
        }

        // If no employee for that particular service is found then allow booking with null employee assignment  */
        if (empty($all_users_of_particular_services)) {
            return response(Reply::dataOnly(['continue_booking' => 'yes']));
        }

        /* Check for employees working on that day: */
        $employeeWorking = EmployeeSchedules::with('employee')->where('location_id', $request->location_id)->where('days', $day)
            ->whereTime('start_time', '<=', $time)->whereTime('end_time', '>=', $time)
            ->where('is_working', 'yes')->whereIn('employee_id', $all_users_of_particular_services)->get();

        $working_employee = array();

        foreach ($employeeWorking as $employeeWorkings) {
            $working_employee[] = $employeeWorkings->employee->id;
        }

        /* Check for employees busy at that time: */
        $assigned_user_list_array = array();
        $assigned_users_list = Booking::with('users')->where('date_time', $dateTime)->get();

        foreach ($assigned_users_list as $key => $value) {
            foreach ($value->users as $key1 => $value1) {
                $assigned_user_list_array[] = $value1->id;
            }
        }

        $free_employee_list = array_diff($working_employee, array_intersect($working_employee, $assigned_user_list_array));

        $select_user = '<select name="" id="selected_user" name="selected_user" class="form-control mt-3 "><option value="">--Select Employee--</option>';

        /* Leave: */
        /* check for half day */
        $halfday_leave = Leave::with('employee')->whereDate('start_date', '<=', $date)
            ->whereDate('end_date', '>=', $date)->whereTime('start_time', '<=', $time)
            ->whereTime('end_time', '>=', $time)->where('leave_type', 'Half Day')->where('status', 'approved')->get();

        $users_on_halfday_leave = array();

        foreach ($halfday_leave as $halfday_leaves) {
            $users_on_halfday_leave[] = $halfday_leaves->employee->id;
        }

        /* check for full day */
        $fullday_leave = Leave::with('employee')->whereDate('start_date', '<=', $date)
            ->whereDate('end_date', '>=', $date)->where('leave_type', 'Full Day')->where('status', 'approved')->get();

        $users_on_fullday_leave = array();

        foreach ($fullday_leave as $fullday_leaves) {
            $users_on_fullday_leave[] = $fullday_leaves->employee->id;
        }

        $employees_not_on_halfday_leave = array_diff($free_employee_list, array_intersect($free_employee_list, $users_on_halfday_leave));

        $employees_not_on_fullday_leave = array_diff($free_employee_list, array_intersect($free_employee_list, $users_on_fullday_leave));

        /* if any employee is on leave on that day */
        // if($this->settings->multi_task_user=='enabled') {
        $employee_lists = User::allEmployees()->select('id', 'name')->whereIn('id', $free_employee_list)->get();

        $employee = User::allEmployees()->select('id', 'name')->whereIn('id', $employees_not_on_fullday_leave)->whereIn('id', $employees_not_on_halfday_leave)->get();

        if ($this->settings->employee_selection == 'enabled') {

            $i = 0;

            foreach ($employee_lists as $employee_list) {
                $user_schedule = $this->checkUserSchedule($employee_list->id, $request->date);

                if ($this->settings->disable_slot == 'enabled') {
                    foreach ($employee as $key => $employees) {

                        if ($user_schedule == true) {
                            $select_user .= '<option value="' . $employees->id . '">' . $employees->name . '</option>';
                            $i++;
                        }
                    }

                    $select_user .= '</select>';

                    if ($i > 0) {
                        return response(Reply::dataOnly(['continue_booking' => 'yes', 'select_user' => $select_user]));
                    }

                    return response(Reply::dataOnly(['continue_booking' => 'no']));
                }
                else {

                    foreach ($employee as $employees) {
                        $select_user .= '<option value="' . $employees->id . '">' . $employees->name . '</option>';
                    }

                    $select_user .= '</select>';

                    return response(Reply::dataOnly(['continue_booking' => 'yes', 'select_user' => $select_user]));
                }
            }
        }

        /* else {
            /* block booking here
            return response(Reply::dataOnly(['continue_booking' => 'no']));
        } */

        /* if no employee found of that particular service */
        if (empty($free_employee_list)) {
            if ($this->settings->multi_task_user == 'enabled') {
                /* give dropdown of all users */
                if ($this->settings->employee_selection == 'enabled') {
                    $employee_lists = User::allEmployees()->select('id', 'name')->whereIn('id', $all_users_of_particular_services)->get();

                    foreach ($employee_lists as $employee_list) {
                        $select_user .= '<option value="' . $employee_list->id . '">' . $employee_list->name . '</option>';
                    }

                    $select_user .= '</select>';
                    return response(Reply::dataOnly(['continue_booking' => 'yes', 'select_user' => $select_user]));
                }
            } else {
                /* block booking here  */
                return response(Reply::dataOnly(['continue_booking' => 'no']));
            }
        }

        /* if multitasking and allow employee selection is enabled */
        if ($this->settings->multi_task_user == 'enabled') {
            /* give dropdown of all users */
            if ($this->settings->employee_selection == 'enabled') {
                $employee_lists = User::allEmployees()->select('id', 'name')->whereIn('id', $all_users_of_particular_services)->get();

                foreach ($employee_lists as $key => $employee_list) {
                    $select_user .= '<option value="' . $employee_list->id . '">' . $employee_list->name . '</option>';
                }

                $select_user .= '</select>';
                return response(Reply::dataOnly(['continue_booking' => 'yes', 'select_user' => $select_user]));
            }
        }

        /* select of all remaining employees */
        $employee_lists = User::allEmployees()->select('id', 'name')->whereIn('id', $free_employee_list)->get();

        if ($this->settings->employee_selection == 'enabled') {
            $i = 0;

            foreach ($employee_lists as $key => $employee_list) {
                $user_schedule = $this->checkUserSchedule($employee_list->id, $request->date);

                if ($this->settings->disable_slot == 'enabled') {
                    // call function which will see employee schedules
                    if ($user_schedule == true) {
                        $select_user .= '<option value="' . $employee_list->id . '">' . $employee_list->name . '</option>';
                        $i++;
                    }
                } else {
                    if ($user_schedule == true) {
                        $select_user .= '<option value="' . $employee_list->id . '">' . $employee_list->name . '</option>';
                        $i++;
                    }
                }
            }

            $select_user .= '</select>';

            if ($i > 0) {
                return response(Reply::dataOnly(['continue_booking' => 'yes', 'select_user' => $select_user]));
            }

            return response(Reply::dataOnly(['continue_booking' => 'no']));
        }

        $user_check_array = array();

        foreach ($employee_lists as $employee_list) {
            // Call function which will see employee schedules
            $user_schedule = $this->checkUserSchedule($employee_list->id, $request->date);

            if ($user_schedule == true) {
                $user_check_array[] = $employee_list->id;
            }
        }

        if (empty($user_check_array)) {
            return response(Reply::dataOnly(['continue_booking' => 'no']));
        }
    }

    public function checkUserSchedule($userid, $dateTime)
    {
        $new_booking_start_time = Carbon::parse($dateTime)->format('Y-m-d H:i');
        $time = $this->calculateCartItemTime();
        $end_time1 = Carbon::parse($dateTime)->addMinutes($time - 1);

        $userBooking = Booking::whereIn('status', ['pending', 'in progress', 'approved'])->with('users')->whereHas('users', function ($q) use ($userid) {
            $q->where('user_id', $userid);
        });
        $bookings = $userBooking->get();

        if ($userBooking->count() > 0) {
            foreach ($bookings as $booking) {
                /* previous booking start date and time */
                $start_time = Carbon::parse($booking->date_time)->format('Y-m-d H:i');
                $booking_time = $this->calculateBookingTime($booking->id);
                $end_time = Carbon::parse($booking->date_time)->addMinutes($booking_time - 1);

                if (Carbon::parse($new_booking_start_time)->between($start_time, Carbon::parse($end_time)->format('Y-m-d H:i'), true) || Carbon::parse($start_time)->between($new_booking_start_time, Carbon::parse($end_time1)->format('Y-m-d H:i'), true)) {
                    return false;
                }
            }
        }

        return true;
    }

    public function calculateBookingTime($booking_id)
    {
        $booking_items = BookingItem::with('businessService')->where('booking_id', $booking_id)->get();
        $time = 0;
        $total_time = 0;
        $max = 0;
        $min = 0;

        foreach ($booking_items as $key => $item) {

            if ($item->businessService->time_type == 'minutes') {
                $time = $item->businessService->time;
            }
            elseif ($item->businessService->time_type == 'hours') {
                $time = $item->businessService->time * 60;
            }
            elseif ($item->businessService->time_type == 'days') {
                $time = $item->businessService->time * 24 * 60;
            }

            $total_time += $time;

            if ($key == 0) {
                $min = $time;
                $max = $time;
            }

            if ($time < $min) {
                $min = $time;
            }

            if ($time > $max) {
                $max = $time;
            }
        }

        if ($this->settings->booking_time_type == 'sum') {
            return $total_time;
        }
        elseif ($this->settings->booking_time_type == 'avg') {
            return $total_time / $booking_items->count();
        }
        elseif ($this->settings->booking_time_type == 'max') {
            return $max;
        }
        elseif ($this->settings->booking_time_type == 'min') {
            return $min;
        }
    }

    public function calculateCartItemTime()
    {
        $products = json_decode(request()->cookie('products'), true);

        foreach ($products as $key => $product) {
            $bookingIds[] = $key;
        }

        $booking_items = BusinessService::whereIn('id', $bookingIds)->get();
        $time = 0;
        $total_time = 0;
        $max = 0;
        $min = 0;

        foreach ($booking_items as $key => $booking_item) {

            if ($booking_item->time_type == 'minutes') {
                $time = $booking_item->time;
            }
            elseif ($booking_item->time_type == 'hours') {
                $time = $booking_item->time * 60;
            }
            elseif ($booking_item->time_type == 'days') {
                $time = $booking_item->time * 24 * 60;
            }

            $total_time += $time;

            if ($key == 0) {
                $min = $time;
                $max = $time;
            }

            if ($time < $min) {
                $min = $time;
            }

            if ($time > $max) {
                $max = $time;
            }
        }

        if ($this->settings->booking_time_type == 'sum') {
            return $total_time;
        }
        elseif ($this->settings->booking_time_type == 'avg') {
            return $total_time / $booking_items->count('id');
        }
        elseif ($this->settings->booking_time_type == 'max') {
            return $max;
        }
        elseif ($this->settings->booking_time_type == 'min') {
            return $min;
        }
    }

    public function suggestEmployee($date)
    {
         /* check for all employee of that service, of that particular location  */
         $dateTime = Carbon::parse($date);

        [$service_ids, $service_names] = Arr::divide(json_decode(request()->cookie('products'), true));

        $user_lists = BusinessService::with('users')->whereIn('id', $service_ids)->get();

        $all_users_of_particular_services = array();

        foreach ($user_lists as $user_list) {
            foreach ($user_list->users as $user) {
                $all_users_of_particular_services[] = $user->id;
            }
        }

        /* if no empolyee for that particular service is found then allow booking with null employee assignment  */
        if (empty($all_users_of_particular_services)) {
            return '';
        }

        /* Employee schedule: */
        $day = $dateTime->format('l');
        $time = $dateTime->format('H:i:s');
        $date = $dateTime->format('Y-m-d');

        /* Check for employees working on that day: */
        $employeeWorking = EmployeeSchedules::with('employee')->where('days', $day)
            ->whereTime('start_time', '<=', $time)->whereTime('end_time', '>=', $time)
            ->where('is_working', 'yes')->whereIn('employee_id', $all_users_of_particular_services)->get();

        $working_employee = array();

        foreach ($employeeWorking as $employeeWorkings) {
            $working_employee[] = $employeeWorkings->employee->id;
        }

        $assigned_user_list_array = array();
        $assigned_users_list = Booking::with('users')->where('date_time', $dateTime)->get();

        foreach ($assigned_users_list as $value) {
            foreach ($value->users as $value1) {
                $assigned_user_list_array[] = $value1->id;
            }
        }

        $free_employee_list = array_diff($working_employee, array_intersect($working_employee, $assigned_user_list_array));

        /* Leave: */
        $halfday_leave = Leave::with('employee')->whereDate('start_date', '<=', $date)
            ->whereDate('end_date', '>=', $date)->whereTime('start_time', '<=', $time)
            ->whereTime('end_time', '>=', $time)->where('leave_type', 'Half day')->where('status', 'approved')->get();

        $users_on_halfday_leave = array();

        foreach ($halfday_leave as $halfday_leaves) {
            $users_on_halfday_leave[] = $halfday_leaves->employee->id;
        }

        $fullday_leave = Leave::with('employee')->whereDate('start_date', '<=', $date)
            ->whereDate('end_date', '>=', $date)->where('leave_type', 'Full day')->where('status', 'approved')->get();

        $users_on_fullday_leave = array();

        foreach ($fullday_leave as $fullday_leaves) {
            $users_on_fullday_leave[] = $fullday_leaves->employee->id;
        }

        $employees_not_on_halfday_leave = array_diff($free_employee_list, array_intersect($free_employee_list, $users_on_halfday_leave));

        $employees_not_on_fullday_leave = array_diff($free_employee_list, array_intersect($free_employee_list, $users_on_fullday_leave));

        /* if any employee is on leave on that day */
        if ($this->settings->employee_selection == 'enabled') {
            return User::allEmployees()->select('id', 'name')->whereIn('id', $employees_not_on_fullday_leave)->whereIn('id', $employees_not_on_halfday_leave)->get();
        }

        /* if no employee found then return allow booking with no employee assignment   */
        if (empty($free_employee_list)) {
            if ($this->settings->multi_task_user == 'enabled') {
                /* give single users */
                return User::select('id', 'name')->whereIn('id', $all_users_of_particular_services)->first()->id;
            }
        }

        /* select of all remaining employees */
        $users = User::select('id', 'name')->whereIn('id', $free_employee_list);

        if ($this->settings->disable_slot == 'enabled') {
            foreach ($users->get() as $employee_list) {
                // call function which will see employee schedules
                $user_schedule = $this->checkUserSchedule($employee_list->id, $date);

                if ($user_schedule == true) {
                    return $employee_list->id;
                }
            }
        }

        return $users->first() ? $users->first()->id : '';
    }

} /* End of main class */
