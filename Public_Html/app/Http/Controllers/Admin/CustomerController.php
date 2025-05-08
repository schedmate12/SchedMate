<?php

namespace App\Http\Controllers\Admin;

use App\Address;
use App\User;
use App\Role;
use App\Booking;
use App\Helper\Reply;
use App\Helper\Files;
use App\Notifications\NewUser;
use App\Http\Controllers\Controller;
use App\Http\Requests\Customer\StoreCustomer;
use App\Http\Requests\Customer\UpdateCustomer;

class CustomerController extends Controller
{

    public function __construct()
    {
        parent::__construct();
        view()->share('pageTitle', __('menu.customers'));
    }

    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        abort_if(!$this->user->roles()->withoutGlobalScopes()->first()->hasPermission('read_customer'), 403);

        $recordsLoad = 8;

        if (\request()->ajax()) {
            $totalRecords = User::allCustomers()
                ->orderBy('id', 'desc');

            if (\request('param') != '') {
                $totalRecords = $totalRecords->where('name', 'LIKE', '%' . \request('param') . '%');
                $totalRecords = $totalRecords->orWhere('email', 'LIKE', '%' . \request('param') . '%');
                $totalRecords = $totalRecords->orWhere('mobile', 'LIKE', '%' . \request('param') . '%');
            }

            $totalRecords = $totalRecords->count();

            $customers = User::with('completedBookings');

            if (\request('param') != '') {
                $customers = $customers->where('name', 'LIKE', '%' . \request('param') . '%');
                $customers = $customers->orWhere('email', 'LIKE', '%' . \request('param') . '%');
                $customers = $customers->orWhere('mobile', 'LIKE', '%' . \request('param') . '%');
            }

            $customers = $customers->take(\request('take'));

            $customers = $customers->orderBy('id', 'desc')->get();

            $view = view('admin.customer.list_ajax', compact('customers', 'totalRecords', 'recordsLoad'))->render();
            return Reply::dataOnly(['status' => 'success', 'view' => $view]);
        }

        return view('admin.customer.index', compact('recordsLoad'));
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(StoreCustomer $request)
    {
        $user = new User();
        $user->name = $request->name;

        if ($request->email != '') {
            $user->email = $request->email;
        }

        $user->calling_code = $request->calling_code;
        $user->mobile = $request->mobile;
        $user->password = '123456';
        $user->save();

        // add customer role
        $user->attachRole(Role::where('name', 'customer')->withoutGlobalScopes()->first()->id);

        $user->notify(new NewUser('123456'));

        return Reply::successWithData(__('messages.createdSuccessfully'), ['user' => ['id' => $user->id, 'text' => $user->name]]);
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        abort_if(!$this->user->roles()->withoutGlobalScopes()->first()->hasPermission('read_customer') && !$this->user->roles()->withoutGlobalScopes()->first()->hasPermission('create_booking'), 403);

        $customer = User::findOrFail($id);

        if (\request()->ajax()) {
            $view = view('admin.customer.ajax_show', compact('customer'))->render();
            return Reply::dataOnly(['status' => 'success', 'view' => $view]);
        }

        $completedBookings = Booking::where('user_id', $id)->where('status', 'completed')->count();
        $approvedBookings = Booking::where('user_id', $id)->where('status', 'approved')->count();
        $pendingBookings = Booking::where('user_id', $id)->where('status', 'pending')->count();
        $canceledBookings = Booking::where('user_id', $id)->where('status', 'canceled')->count();
        $inProgressBookings = Booking::where('user_id', $id)->where('status', 'in progress')->count();
        $earning = Booking::where('user_id', $id)->where('status', 'completed')->sum('amount_to_pay');

        return view('admin.customer.show', compact('customer', 'completedBookings', 'approvedBookings', 'pendingBookings', 'inProgressBookings', 'canceledBookings', 'earning'));
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit($id)
    {
        abort_if(!$this->user->roles()->withoutGlobalScopes()->first()->hasPermission('update_customer'), 403);

        $customer = User::find($id);
        return view('admin.customer.edit', compact('customer'));
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(UpdateCustomer $request, $id)
    {
        abort_if(!$this->user->roles()->withoutGlobalScopes()->first()->hasPermission('update_customer'), 403);

        $user = User::find($id);
        $user->name = $request->name;
        $user->email = $request->email;

        if ($request->password != '') {
            $user->password = $request->password;
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

        return Reply::redirect(route('admin.customers.show', $id), __('messages.updatedSuccessfully'));
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        abort_if(!$this->user->roles()->withoutGlobalScopes()->first()->hasPermission('delete_customer'), 403);

        User::destroy($id);
        return Reply::redirect(route('admin.customers.index'), __('messages.recordDeleted'));
    }

}
