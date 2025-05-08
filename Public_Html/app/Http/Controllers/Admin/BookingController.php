<?php

namespace App\Http\Controllers\Admin;

use App\Booking;
use App\BookingItem;
use App\ItemTax;
use App\BusinessService;
use App\CompanySetting;
use App\Coupon;
use App\ServiceReview;
use App\Helper\Reply;
use App\Location;
use App\CustomerFeedback;
use App\Notifications\BookingCancel;
use App\Notifications\BookingReminder;
use App\User;
use Carbon\Carbon;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Http\Requests\Booking\StoreFeedbackRequest;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Notification;
use App\Http\Requests\BookingStatusMultiUpdate;
use App\Http\Requests\Booking\UpdateBooking;
use App\Payment;
use App\PaymentGatewayCredentials;
use App\Product;
use App\Tax;
use App\ZoomMeeting;
use Illuminate\Support\Facades\Auth;

class BookingController extends Controller
{

    public function __construct()
    {
        parent::__construct();
        $this->credentials = PaymentGatewayCredentials::first();
        $this->setting = CompanySetting::with('currency')->first();

        view()->share('pageTitle', __('menu.bookings'));
        view()->share('credentials', $this->credentials);
        view()->share('setting', $this->setting);
    }

    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        abort_if(!$this->user->roles()->withoutGlobalScopes()->first()->hasPermission('read_booking') && !$this->user->roles()->withoutGlobalScopes()->first()->hasPermission('create_booking'), 403);

        if(\request()->ajax()){
            $bookings = Booking::groupBy('id');


            if(\request('filter_sort') != ''){
                $bookings->orderBy('id', \request('filter_sort'));
            }
            else {
                $bookings->orderBy('id', 'desc');
            }

            if (\request('filter_status') != '') {
                $bookings->where('bookings.status', \request('filter_status'));
            }

            if (\request('filter_type') != '') {
                $bookings->where('bookings.booking_type', \request('filter_type'));
            }

            if (\request('booking-via') != '') {
                $bookings->where('bookings.source', 'online');
            }

            if (\request('booking-via-pos') != '') {
                $bookings->where('bookings.source', 'pos');
            }

            if (\request('filter_customer') != '') {
                $customer = request()->filter_customer;
                $bookings->whereHas('user', function ($query) use ($customer) {
                    $query->where('name', 'like', '%' . $customer . '%');
                });
            }

            if(\request('filter_location') != ''){
                $bookings->leftJoin('booking_items', 'bookings.id', 'booking_items.booking_id')
                    ->leftJoin('business_services', 'booking_items.business_service_id', 'business_services.id')
                    ->leftJoin('locations', 'business_services.location_id', 'locations.id')
                    ->select('bookings.*')
                    ->where('locations.id', request('filter_location'))
                    ->groupBy('bookings.id');
            }

            if(request('start_date') != '' && request('end_date') != ''){

                $startDate = Carbon::createFromFormat($this->setting->date_format, request('start_date'))->format('Y-m-d');
                $endDate = Carbon::createFromFormat($this->setting->date_format, request('end_date'))->format('Y-m-d');

                $bookings->where(DB::raw('DATE(bookings.date_time)'), '>=', $startDate)->where(DB::raw('DATE(bookings.date_time)'), '<=', $endDate);
            }

            if(\request('filter_booking') != ''){
                if(request()->filter_booking == 'deal'){
                    $bookings->where('deal_id', '<>', '');
                }
                else{
                    $bookings->where('deal_id', null);
                }
            }

            if (!$this->user->is_admin && !$this->user->isAbleTo('create_booking')) {

                if ($this->user->is_employee && $this->current_emp_role->name == 'employee')
                {
                    $bookings->whereHas('users', function ($q) {
                        $q->where('user_id', $this->user->id);
                    })->orWhere('user_id', $this->user->id);
                }
                else {
                    $bookings->where('user_id', $this->user->id);
                }
            }

            if ($this->current_emp_role->name == 'customer') {
                $bookings->where('user_id', $this->user->id);

            }

            if(!$this->user->is_admin && !$this->user->isAbleTo('create_booking')){
                ($this->user->is_employee) && !session('loginRole') ? $bookings->whereHas('users', function($query) { return $query->where('user_id', $this->user->id);
                }) : $bookings->where('bookings.user_id', $this->user->id);
            }

            $bookings->get();

            if (request('current_url') == 'customer_url') {
                return \datatables()->of($bookings)
                    ->editColumn('id', function ($row) {
                        $view = view('admin.booking.list_view', compact('row'))->render();
                        return $view;
                    })
                    ->rawColumns(['id'])
                    ->toJson();
            }

            return \datatables()->of($bookings)
                ->addColumn('action', function ($row) {
                    $action = '<div class="text-right">';

                    $action .= '<a href="' . route('admin.bookings.add_rating', [$row->id]) . '" class="btn btn-info btn-circle"
                        data-bs-toggle="tooltip" data-original-title="rating"><i class="fa fa-star" aria-hidden="true"></i></a> 
                        <a href="' . route('admin.bookings.show', [$row->id]) . '" class="btn btn-info btn-circle view-booking"
                        data-bs-toggle="tooltip" data-original-title="'.__('app.view').'"><i class="fa fa-eye" aria-hidden="true"></i></a> ';

                    if($row->status != 'completed'){
                        $action .= '<a href="' . route('admin.bookings.edit', [$row->id]) . '" class="btn btn-primary btn-circle"
                        data-bs-toggle="tooltip" data-original-title="'.__('app.edit').'"><i class="fa fa-pencil" aria-hidden="true"></i></a>';
                    }

                    $action .= ' <a href="javascript:;" class="btn btn-danger btn-circle delete-row"
                    data-bs-toggle="tooltip" data-row-id="' . $row->id . '" data-original-title="'.__('app.delete').'"><i class="fa fa-times" aria-hidden="true"></i></a>';

                    $action .= '</div>';
                    return $action;
                })
                ->editColumn('customer name', function ($row) {
                    return $row->user->name;
                })
                ->editColumn('booking time', function ($row) {
                    return $row->date_time;
                })
                ->editColumn('total', function ($row) {
                    $total = '<div class="text-bold">Total ='.currencyFormatter($row->amount_to_pay).'</div>';
                    $total .= '<div class="text-bold text-success">Total Paid ='.currencyFormatter($row->amountPaid()).'</div>';
                    $total .= '<div class="text-bold text-danger">Total Remaining ='.currencyFormatter($row->amountDue()).'</div>';

                    return $total;
                })

                ->editColumn('status', function ($row) {

                    if ($row->status == 'completed') {

                        return '<label class="badge badge-success">'.ucwords($row->status).'</label>';
                    }
                    elseif ($row->status == 'pending') {

                        return '<label class="badge badge-warning">'.ucwords($row->status).'</label>';
                    }
                    elseif ($row->status == 'approved') {

                        return '<label class="badge badge-info">'.ucwords($row->status).'</label>';
                    }
                    elseif ($row->status == 'in progress') {

                        return '<label class="badge badge-primary">'.ucwords($row->status).'</label>';
                    }
                    else {

                        return '<label class="badge badge-danger">'.ucwords($row->status).'</label>';
                    }
                })
                ->addIndexColumn()
                ->rawColumns(['id', 'action', 'customer_name', 'status', 'booking_time', 'total'])
                ->toJson();
        }

        $users = User::all();
        $customers = $users->sortBy('name')->pluck('name')->unique();

        $locations = Location::all();
        $startDate = request()->start ? Carbon::createFromFormat('Y-m-d', request()->start)->format($this->setting->date_format) : null;
        $endDate = request()->end ? Carbon::createFromFormat('Y-m-d', request()->end)->format($this->setting->date_format) : null;
        $status = \request('status');
        $source = \request('booking-via');
        $sourcePos = \request('booking-via-pos');

        return view('admin.booking.index', compact('customers', 'status', 'source', 'sourcePos', 'locations', 'startDate', 'endDate', 'sourcePos'));
    }

    public function calendar()
    {
        abort_if(!$this->user->roles()->withoutGlobalScopes()->first()->hasPermission('read_booking') && !$this->user->roles()->withoutGlobalScopes()->first()->hasPermission('create_booking'), 403);

        if ($this->user->hasRole('customer') || $this->current_emp_role->name == 'customer'){
            $bookings = Booking::with([
                'user' => function($q)
                {
                    $q->withoutGlobalScope('company')->where('id', $this->user->id);
                }
            ])->where('status', '!=', 'canceled')->where('user_id', $this->user->id)->get();
        }
        elseif ($this->user->hasRole('employee')) {
            $bookings = Booking::with([
                'user' => function($q)
                {
                    $q->withoutGlobalScope('company');
                }
                ])->where(function($q){
                    $q->where('status', '!=', 'canceled');
                    $q->where(function($q){
                        $q->where('user_id', $this->user->id);
                        $q->orWhere(function($q){
                            $q->whereHas('users', function($q){
                                $q->where('id', $this->user->id);
                            });
                        });
                    });
                })
                ->get();
        }
        elseif ($this->user->is_admin) {
            $bookings = Booking::with([
                'user' => function($q)
                    {
                        $q->withoutGlobalScope('company');
                }
                ])->where(function($q){
                    $q->where('status', '!=', 'canceled');
                })
                ->get();
        }

        return view('admin.booking.calendar_index', compact('bookings'));
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store()
    {
        //
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show(Request $request, $id)
    {
        abort_if(!$this->user->roles()->withoutGlobalScopes()->first()->hasPermission('read_booking') && !$this->user->roles()->withoutGlobalScopes()->first()->hasPermission('create_booking'), 403);

        if ($request->current_url !== 'booking_url') {
            $booking = Booking::with(['coupon', 'users', 'feedback', 'bookingPayments', 'payment'])->find($id);
        }
        else
        {
            $booking = Booking::with(['coupon', 'users', 'feedback'])->find($id);
        }

        $current_url = ($request->current_url != null) ? $request->current_url : 'backend';
        // dd($booking->payment_status);
        $commonCondition = $booking->payment_status == 'pending' && $booking->status != 'canceled' && $this->credentials->show_payment_options == 'show' && !$this->user->is_admin && !$this->user->is_employee;

        $meeting = ZoomMeeting::where('booking_id', $booking->id)->first();

        if ($request->current_url !== 'booking_url') {

            return view('admin.booking.show', compact(['booking', 'current_url', 'commonCondition', 'meeting']));
        }

        $view = view('admin.booking.show', compact('booking', 'commonCondition', 'current_url', 'meeting'))->render();
        return Reply::dataOnly(['status' => 'success', 'view' => $view]);
    }

    public function addPayment(Request $request)
    {
        if ($request->cash_remaining == 0)
        {
            $status = 'completed';
        }
        else{
            $status = 'pending';
        }

        $bookingId = $request->booking_id;
        $payment = new Payment();
        $payment->currency_id = $this->settings->currency_id;
        $payment->booking_id = $bookingId;

        $payment->amount = $request->total;
        $payment->amount_remaining = $request->cash_remaining;
        $payment->amount_paid = $request->cash_given;
        $payment->gateway = $request->payment_gateway;
        $payment->status = 'completed';
        $payment->paid_on = Carbon::now();
        $payment->save();

        $booking = Booking::find($bookingId);
        $booking->payment_status = $status;
        $booking->save();
        return Reply::redirect(route('admin.bookings.show', $request->booking_id), __('messages.createdSuccessfully'));
    }
    
    //     public function add_rating($id)
    // {
    //     $items = \DB::table('booking_items')
    // ->join('business_services', 'booking_items.business_service_id', '=', 'business_services.id')
    // ->where('booking_items.booking_id', $id)
    // ->select(
    //     'booking_items.*',
    //     'business_services.name as service_name',
    //     'business_services.price',
    //     'business_services.description'
    // )
    // ->get();
    // return view('admin.booking.addrating', ['booking' => $items,]);
    // }
    
        public function add_rating($id)
        {
            $items = \DB::table('booking_items')
                ->join('business_services', 'booking_items.business_service_id', '=', 'business_services.id')
                ->leftJoin('service_reviews', function ($join) use ($id) {
                    $join->on('booking_items.business_service_id', '=', 'service_reviews.service_id')
                        ->where('service_reviews.booking_id', '=', $id)
                        ->where('service_reviews.user_id', auth()->id()); // assuming logged in user
                })
                ->where('booking_items.booking_id', $id)
                ->select(
                    'booking_items.*',
                    'business_services.name as service_name',
                    'business_services.price',
                    'business_services.description',
                    'service_reviews.id as review_id',
                    'service_reviews.rating',
                    'service_reviews.review_text'
                )
                ->get();
        
            return view('admin.booking.addrating', ['booking' => $items]);
        }
        
        
        public function ratingstore(Request $request, $id)
{
    $review = ServiceReview::where('booking_id', $request->booking_id)
        ->where('user_id', $request->user_id)
        ->where('service_id', $request->service_id)
        ->first();

    if ($review) {
        // Update existing
        $review->rating = $request->rating;
        $review->review_text = $request->review_text;
        $review->save();
    } else {
        // Create new
        ServiceReview::create([
            'booking_id' => $request->booking_id,
            'user_id' => $request->user_id,
            'service_id' => $request->service_id,
            'rating' => $request->rating,
            'review_text' => $request->review_text,
        ]);
    }

    return redirect()->route('admin.bookings.index')->with('success', __('messages.receivedSuccessfully'));
}


    
    // public function ratingstore(Request $request, $id)
    // {
    //      $servicereview = new ServiceReview();
    //      $servicereview->booking_id = $request->booking_id;
    //     $servicereview->user_id = $request->user_id;
    //     $servicereview->service_id = $request->service_id;
    //     $servicereview->rating = $request->rating;
    //     $servicereview->review_text = $request->review_text;
    //     $servicereview->save();
    //     return redirect()->route('admin.bookings.index')->with('success', __('messages.receivedSuccessfully'));

    // }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit(Booking $booking)
    {

        abort_if(!$this->user->isAbleTo('update_booking'), 403);

        $selected_booking_user = array();
        $booking_users = Booking::with(['users'])->find($booking->id);

        foreach ($booking_users->users as $key => $user)
        {
            array_push($selected_booking_user, $user->id);
        }

        $tax = Tax::active()->first();
        $employees = User::OtherThanCustomers()->get();
        $businessServices = BusinessService::active()->get();
        $products = Product::active()->get();

        $current_url = request()->current_url ? request()->current_url : '';

        $latestBooking = DB::table('payments')->latest('id')->first();

        $amount = '';
        $total_paid = '';
        $amount_remaining = '';

        if($latestBooking)
        {
            $amount = $booking->payment ? $booking->payment->amount : 0;
            $amount_remaining = $latestBooking->amount_remaining;
            $total_paid = $amount - $amount_remaining;
        }

        if ($amount) {
            $total_paid = $amount - $amount_remaining;
        }
        else {
            $total_paid = $amount_remaining;
        }

        return view('admin.booking.edit', compact('booking', 'tax', 'businessServices', 'products', 'employees', 'selected_booking_user', 'current_url', 'total_paid', 'amount_remaining'));
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(UpdateBooking $request, $id)
    {
        abort_if(!$this->user->isAbleTo('update_booking'), 403);
        // Delete old items and enter new booking_date
        BookingItem::where('booking_id', $id)->delete();
        $types          = $request->types;
        $products       = $request->cart_products;
        $productQty     = $request->product_quantity;
        $productPrice   = $request->product_prices;
        $employees      = $request->employee_id;
        $services       = $request->cart_services;
        $quantity       = $request->cart_quantity;
        $prices         = $request->cart_prices;
        $discount       = $request->cart_discount;
        $payment_status = $request->payment_status;
        $taxes          = $request->tax_percent;
        $amountRemaining = $request->amount_remaining;
        $discountAmount = 0;
        $productAmt     = 0;
        $taxAmount      = 0;
        $taxPercent     = 0;
        $productTaxAmt  = 0;
        $amountToPay    = 0;
        $originalAmount = 0;
        $bookingItems   = array();

        if(!is_null($services)){
            foreach ($services as $key => $service){
                $amount = ($quantity[$key] * $prices[$key]);
                $deal_id = ($types[$key] == 'deal') ? $services[$key] : null;
                $service_id = ($types[$key] == 'service') ? $services[$key] : null;

                $bookingItems[] = [
                    'business_service_id' => $service_id,
                    'quantity' => $quantity[$key],
                    'unit_price' => $prices[$key],
                    'amount' => $amount
                ];
                $originalAmount = ($originalAmount + $amount);

                if ($types[$key] == 'deal') {
                    $taxes = ItemTax::with('tax')->where('deal_id', $deal_id)->get();
                }
                else {
                    $taxes = ItemTax::with('tax')->where('service_id', $service_id)->get();
                }

                $tax = 0;

                foreach ($taxes as $key => $value) {
                    $tax += $value->tax->percent;
                    $taxName[] = $value->tax->name;
                    $taxPercent += $value->tax->percent;
                }

                $taxAmount += ($amount * $tax) / 100;
            }
        }


        if(!is_null($products)){
            foreach ($products as $key => $product){
                $totalProductAmt = ($productQty[$key] * $productPrice[$key]);

                $productItems[] = [
                    'product_id' => $product,
                    'quantity' => $productQty[$key],
                    'unit_price' => $productPrice[$key],
                    'amount' => $totalProductAmt
                ];

                $productAmt = ($productAmt + $totalProductAmt);

                $taxes = ItemTax::with('tax')->where('product_id', $product)->get();

                $productTax = 0;

                foreach ($taxes as $key => $value) {
                    $productTax += $value->tax->percent;
                    $taxName[] = $value->tax->name;
                    $taxPercent += $value->tax->percent;
                }

                $productTaxAmt += ($productAmt * $productTax) / 100;
            }
        }

        $totalTax = $taxAmount + $productTaxAmt;

        $amountToPay = $originalAmount;

        $booking = Booking::with('payment')->where('id', $id)->first();

        if ($discount > 0){
            if ($discount > 100) { $discount = 100;
            }

            $discountAmount = (($discount / 100) * $originalAmount);
            $amountToPay = ($originalAmount - $discountAmount);
        }

        $amountToPay = ($amountToPay + $totalTax);

        if (!is_null($request->coupon_id)) {
            $amountToPay -= $request->coupon_amount;
        }

        if($productAmt > 0){
            $amountToPay = ($amountToPay + $productAmt);
        }

        $amountToPay = round($amountToPay, 2);

        $bookingDate = Carbon::createFromFormat('Y-m-d H:i a', $request->booking_date)->format('Y-m-d');
        $booking->date_time   = Carbon::createFromFormat('Y-m-d H:i a', $bookingDate . ' ' . $request->hidden_booking_time)->format('Y-m-d H:i:s');

        $booking->status      = $request->status;
        $booking->original_amount = $originalAmount;
        $booking->product_amount   = $productAmt;
        $booking->discount = $discountAmount;
        $booking->discount_percent = $request->cart_discount;
        $booking->tax_amount = $totalTax;
        $booking->amount_to_pay = $amountToPay;
        $booking->payment_status = $payment_status;

        $booking->save();


        /* assign employees to this appointment */
        if(!empty($employees))
        {
            $assignedEmployee   = array();

            foreach ($employees as $key => $employee)
            {
                $assignedEmployee[] = $employees[$key];
            }

            $booking = Booking::find($id);
            $booking->users()->sync($assignedEmployee);
        }

        $total_amount = 0.00;

        foreach ($bookingItems as $key => $bookingItem){
            $bookingItems[$key]['booking_id'] = $booking->id;
            $total_amount += $bookingItem['amount'];
        }

        $total_amt = 0.00;

        if(!is_null($products)){

            foreach ($productItems as $key => $productItem){
                $productItems[$key]['booking_id'] = $booking->id;
                $total_amt += $productItem['amount'];
            }

            DB::table('booking_items')->insert($productItems);
        }

        $total_amount = round($total_amount + $total_amt, 2);

        if (!$booking->payment) {
            $payment = new Payment();

            $payment->currency_id = $this->settings->currency_id;
            $payment->booking_id = $booking->id;
            $payment->amount = $total_amount;
            $payment->amount_remaining = $amountRemaining;
            $payment->gateway = 'cash';
            $payment->status = 'completed';
            $payment->paid_on = Carbon::now();
        }
        else {
            $payment = $booking->payment;
            $payment->amount_remaining = $amountRemaining;
            $payment->status = 'completed';
            $payment->amount = $total_amount;
        }

        $payment->save();

        DB::table('booking_items')->insert($bookingItems);
        return Reply::redirect(route('admin.bookings.index'), __('messages.updatedSuccessfully'));
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        abort_if(!$this->user->roles()->withoutGlobalScopes()->first()->hasPermission('delete_booking'), 403);

        Booking::destroy($id);
        return Reply::success(__('messages.recordDeleted'));
    }

    public function download($id)
    {

        $booking = Booking::with('user', 'items', 'bookingPayments')->where('id', $id)->first();

        if($booking->status != 'completed')
        {
            abort(403);
        }

        if($this->user->is_admin || $this->user->is_employee || $booking->user_id == $this->user->id){
            $pdf = app('dompdf.wrapper');

            $pdf->loadView('admin.booking.receipt', compact('booking') );
            $filename = __('app.receipt').' #'.$booking->id;
            return $pdf->download($filename . '.pdf');
        }
        else{
            abort(403);
        }
    }

    public function invocePdf($id)
    {

        $booking = Booking::with('user', 'items')->where('id', $id)->first();

        if($booking->status != 'completed')
        {
            abort(403);
        }

        if($this->user->is_admin || $this->user->is_employee || $booking->user_id == $this->user->id){
            $pdf = app('dompdf.wrapper');
            $pdf->loadView('admin.booking.receipt', compact('booking') );
            return $pdf->stream();
        }
        else{
            abort(403);
        }
    }

    public function print($id)
    {
        $this->id = $id;

        return view('admin.booking.print', $this->data);
    }

    public function requestCancel(Request $request, $id)
    {
        $booking = Booking::findOrFail($id);
        $booking->status = 'canceled';
        $booking->save();

        $commonCondition = $booking->payment_status == 'pending' && $booking->status != 'canceled' && $this->credentials->show_payment_options == 'show' && !$this->user->is_admin && !$this->user->is_employee;
        $current_url = ($request->current_url != null) ? $request->current_url : 'backend';
        $view = view('admin.booking.show', compact('booking', 'commonCondition', 'current_url'))->render();

        $admins = User::allAdministrators()->get();
        $role = $this->user->is_admin == true && $this->user->is_employee == false ? 'Admin' : 'Customer';

        Notification::send($admins, new BookingCancel($booking, $role));

        if ($request->current_url == 'backend') {
            return Reply::successWithData(__('messages.cancelledSuccessfully'), ['view' => $view]);
        }

        return Reply::dataOnly(['status' => 'success', 'view' => $view]);
    }

    public function sendReminder()
    {
        $bookingId = \request('bookingId');
        $booking = Booking::findOrFail($bookingId);
        $customer = User::findOrFail($booking->user_id);
        $customer->notify(new BookingReminder($booking));

        return Reply::success(__('messages.bookingReminderSent'));
    }

    public function multiStatusUpdate(BookingStatusMultiUpdate $request)
    {

        foreach ($request->booking_checkboxes as $booking_checkbox)
        {
            $booking = Booking::find($booking_checkbox);

            if($booking->status != 'completed')
            {
                $booking->status = $request->change_status;
            }

            $booking->save();
        }

        return Reply::dataOnly(['status' => 'success', '']);
    }

    public function updateCoupon(Request $request)
    {
        $couponId = $request->coupon_id;

        $tax = Tax::active()->first();

        $productAmount = $request->cart_services;

        if($request->cart_discount > 0){
            $totalDiscount = ($request->cart_discount * $productAmount) / 100;
            $productAmount -= $totalDiscount;
        }

        $percentAmount = ($tax->percent / 100) * $productAmount;

        $totalAmount   = ($productAmount + $percentAmount);

        $currentDate = Carbon::now()->format('Y-m-d H:i:s');

        $couponData = Coupon::where('coupons.start_date_time', '<=', $currentDate)
            ->where(function ($query) use($currentDate) {
                $query->whereNull('coupons.end_date_time')
                    ->orWhere('coupons.end_date_time', '>=', $currentDate);
            })
            ->where('coupons.id', $couponId)
            ->where('coupons.status', 'active')
            ->first();

        if (!is_null($couponData) && $couponData->minimum_purchase_amount != 0 && $couponData->minimum_purchase_amount != null && $productAmount < $couponData->minimum_purchase_amount)
        {
            return Reply::errorWithoutMessage();
        }

        if (!is_null($couponData) && $couponData->used_time >= $couponData->uses_limit && $couponData->uses_limit != null && $couponData->uses_limit != 0) {
            return Reply::errorWithoutMessage();
        }

        if (!is_null($couponData)) {
            $days = json_decode($couponData->days);
            $currentDay = Carbon::now()->format('l');

            if (in_array($currentDay, $days)) {
                if (!is_null($couponData->percent) && $couponData->percent != 0) {
                    $percentAmount = round(($couponData->percent / 100) * $totalAmount, 2);

                    if (!is_null($couponData->amount) && $percentAmount >= $couponData->amount) {
                        $percentAmount = $couponData->amount;
                    }

                    return Reply::dataOnly( ['amount' => $percentAmount, 'couponData' => $couponData]);
                }
                elseif (!is_null($couponData->amount) && (is_null($couponData->percent) || $couponData->percent == 0)) {
                    return Reply::dataOnly(['amount' => $couponData->amount, 'couponData' => $couponData]);
                }
            }
            else {
                return Reply::errorWithoutMessage();
            }

        }

        return Reply::errorWithoutMessage();
    }

    public function showFeedbackModal ($id)
    {
        $booking = Booking::where('id', $id)->first();
        return view('admin.booking.feedback', compact('booking'));
    }

    public function giveUsFeedback (StoreFeedbackRequest $request, $id)
    {
        $booking = new CustomerFeedback();
        $booking->user_id = Auth::user()->id;
        $booking->booking_id = $id;
        $booking->customer_name = Auth::user()->name;
        $booking->feedback_message = $request->customer_feedback;
        $booking->status = 'active';
        $booking->save();

        return Reply::successWithData(__('messages.receivedSuccessfully'), ['view' => $booking->feedback_message]);
    }

    public function updateBookingDate(Request $request, $id)
    {
        abort_if(!$this->user->isAbleTo('update_booking'), 403);

        $booking = Booking::where('id', $id)->first();
        $booking->date_time   = Carbon::parse($request->startDate)->format('Y-m-d H:i:s');
        $booking->save();

        return Reply::successWithData('messages.updatedSuccessfully', ['status' => 'success']);
    }

}
