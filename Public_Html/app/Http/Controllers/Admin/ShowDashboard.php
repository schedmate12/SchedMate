<?php
namespace App\Http\Controllers\Admin;

use App\User;
use App\Booking;
use Carbon\Carbon;
use App\Helper\Reply;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Location;
use App\Payment;
use App\RoleUser;
use Illuminate\Support\Facades\Session;

class ShowDashboard extends Controller
{

    public function __construct()
    {
        parent::__construct();
        view()->share('pageTitle', __('menu.dashboard'));
    }

    /**
     * Handle the incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function __invoke(Request $request)
    {
        if (\request()->ajax()) {

            $startDate = Carbon::createFromFormat('Y-m-d', $request->startDate);
            $endDate = Carbon::createFromFormat('Y-m-d', $request->endDate);

            $totalBooking = Booking::whereDate('date_time', '>=', $startDate)
                ->whereDate('date_time', '<=', $endDate);

            if($this->current_emp_role->name != 'administrator' && !$this->user->isAbleTo('create_booking') || session('loginRole')) {
                $totalBooking = ($this->user->is_employee) ? $totalBooking->whereHas('users', function ($query) {
                    return $query->where('user_id', $this->user->id);
                }) : $totalBooking->where('user_id', $this->user->id);
            }

            $totalBooking = $totalBooking->count();

            $inProgressBooking = Booking::whereDate('date_time', '>=', $startDate)
                ->whereDate('date_time', '<=', $endDate)
                ->where('status', 'in progress');

            if($this->current_emp_role->name != 'administrator' && !$this->user->isAbleTo('create_booking') || session('loginRole')) {
                $inProgressBooking = ($this->user->is_employee) ? $inProgressBooking->whereHas('users', function ($query) {
                    return $query->where('user_id', $this->user->id);
                }) : $inProgressBooking->where('user_id', $this->user->id);
            }

            $inProgressBooking = $inProgressBooking->count();

            $pendingBooking = Booking::whereDate('date_time', '>=', $startDate)
                ->whereDate('date_time', '<=', $endDate)
                ->where('status', 'pending');

            if($this->current_emp_role->name != 'administrator' && !$this->user->isAbleTo('create_booking') || session('loginRole')) {
                $pendingBooking = ($this->user->is_employee) ? $pendingBooking->whereHas('users', function ($query) {
                    return $query->where('user_id', $this->user->id);
                }) : $pendingBooking->where('user_id', $this->user->id);
            }

            $pendingBooking = $pendingBooking->count();

            $approvedBooking = Booking::whereDate('date_time', '>=', $startDate)
                ->whereDate('date_time', '<=', $endDate)
                ->where('status', 'approved');

            if($this->current_emp_role->name != 'administrator' && !$this->user->isAbleTo('create_booking') || session('loginRole')) {
                $approvedBooking = ($this->user->is_employee) ? $approvedBooking->whereHas('users', function ($query) {
                    return $query->where('user_id', $this->user->id);
                }) : $approvedBooking->where('user_id', $this->user->id);
            }

            $approvedBooking = $approvedBooking->count();

            $completedBooking = Booking::whereDate('date_time', '>=', $startDate)
                ->whereDate('date_time', '<=', $endDate)
                ->where('status', 'completed');

            if($this->current_emp_role->name != 'administrator' && !$this->user->isAbleTo('create_booking') || session('loginRole')) {
                $completedBooking = ($this->user->is_employee) ? $completedBooking->whereHas('users', function ($query) {
                    return $query->where('user_id', $this->user->id);
                }) : $completedBooking->where('user_id', $this->user->id);
            }

            $completedBooking = $completedBooking->count();

            $canceledBooking = Booking::whereDate('date_time', '>=', $startDate)
                ->whereDate('date_time', '<=', $endDate)
                ->where('status', 'canceled');

            if($this->current_emp_role->name != 'administrator' && !$this->user->isAbleTo('create_booking') || session('loginRole')) {
                $canceledBooking = ($this->user->is_employee) ? $canceledBooking->whereHas('users', function ($query) {
                    return $query->where('user_id', $this->user->id);
                }) : $canceledBooking->where('user_id', $this->user->id);
            }

            $canceledBooking = $canceledBooking->count();

            $offlineBooking = Booking::whereDate('date_time', '>=', $startDate)
                ->whereDate('date_time', '<=', $endDate)
                ->where('source', 'pos');

            if (!$this->user->is_admin) {
                $offlineBooking = ($this->user->is_employee) ? $offlineBooking->whereHas('users', function ($query) {
                    return $query->where('user_id', $this->user->id);
                }) : $offlineBooking->where('user_id', $this->user->id);
            }

            $offlineBooking = $offlineBooking->count();

            $onlineBooking = Booking::whereDate('date_time', '>=', $startDate)
                ->whereDate('date_time', '<=', $endDate)
                ->where('source', 'online');

            if (!$this->user->is_admin) {
                $onlineBooking = ($this->user->is_employee) ? $onlineBooking->whereHas('users', function ($query) {
                    return $query->where('user_id', $this->user->id);
                }) : $onlineBooking->where('user_id', $this->user->id);
            }

            $onlineBooking = $onlineBooking->count();

            if ($this->user->is_admin) {
                $totalCustomers = User::all()->count();
                $totalEarnings = Payment::where('status', 'completed')
                    ->whereDate('paid_on', '>=', $startDate)
                    ->whereDate('paid_on', '<=', $endDate)
                    ->sum('amount_paid');
            }
            else {
                $totalCustomers = 0;
                $totalEarnings = 0;
            }

            return Reply::dataOnly(['status' => 'success', 'totalBooking' => $totalBooking, 'pendingBooking' => $pendingBooking, 'approvedBooking' => $approvedBooking, 'inProgressBooking' => $inProgressBooking, 'completedBooking' => $completedBooking, 'canceledBooking' => $canceledBooking, 'offlineBooking' => $offlineBooking, 'onlineBooking' => $onlineBooking, 'totalCustomers' => $totalCustomers, 'totalEarnings' => round($totalEarnings, 2), 'user' => $this->user]);
        }

        if ($this->user->is_admin) {
            $recentSales = Booking::orderBy('date_time', 'desc')->take(20)->get();
        }
        else {
            $recentSales = null;
        }

        $todoItemsView = $this->generateTodoView();
        $isNotSetCountry = (Location::where('country_id', null)->where('timezone_id', null)->count() > 0);
        $isEmployeesHasLocation = (User::has('location')->otherThanCustomers()->count() == 0);
        $isNotSetLongitude = (Location::where('lat', 0)->where('lng', 0)->count() > 0);

        return view('admin.dashboard.index', compact('recentSales', 'todoItemsView', 'isNotSetCountry', 'isEmployeesHasLocation', 'isNotSetLongitude'));
    }

    public function roleLogin(Request $request)
    {
        if(request()->roleId){
            $role = RoleUser::where('user_id', $this->user->id)->where('role_id', request()->roleId)->first();

            if(!$role){
                $this->user->roles()->attach(request()->roleId);
            }
        }

        // @codingStandardsIgnoreLine
       Session::put('loginRole', request()->roleId);

        return Reply::redirect(route('admin.dashboard'));
    }

    public function employeeLogin()
    {
        $roleId = Session::get('loginRole');

        if($roleId){
            $role = RoleUser::where('user_id', $this->user->id)->where('role_id', $roleId)->first();

            if($role){
                $this->user->roles()->detach($roleId);
            }
        }

        session()->forget('loginRole');
        return Reply::redirect(route('admin.dashboard'));
    }

}
