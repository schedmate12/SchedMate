<?php

namespace App\Http\Controllers\Admin;

use App\Address;
use App\User;
use App\Role;
use App\BookingTime;
use App\Helper\Files;
use App\Helper\Reply;
use App\EmployeeGroup;
use App\BusinessService;
use App\EmployeeSchedules;
use Illuminate\Http\Request;
use App\EmployeeGroupService;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Artisan;
use App\Http\Requests\Employee\StoreRequest;
use App\Http\Requests\Employee\UpdateRequest;
use App\Http\Requests\Employee\ChangeRoleRequest;
use App\Location;
use Carbon\Carbon;

class EmployeeController extends Controller
{

    public function __construct()
    {
        parent::__construct();
        view()->share('pageTitle', __('menu.employee'));
    }

    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */

    /**
     * @return \Illuminate\Contracts\View\Factory|\Illuminate\View\View
     * @throws \Exception
     */
    public function index()
    {
        abort_if(!$this->user->roles()->withoutGlobalScopes()->first()->hasPermission('read_employee'), 403);

        if(\request()->ajax()){
            $employee = User::otherThanCustomers()->get();
            $roles = Role::all();

            return \datatables()->of($employee)
                ->addColumn('action', function ($row) {
                    $action = '<div class="text-right">';

                    if (($this->user->is_admin || $this->user->isAbleTo('update_employee')) && $row->id !== $this->user->id) {
                        $action .= '<a href="' . route('admin.employee.edit', [$row->id]) . '" class="btn btn-primary btn-circle"
                          data-bs-toggle="tooltip" data-original-title="'.__('app.edit').'"><i class="fa fa-pencil" aria-hidden="true"></i></a>';
                    }

                    if (($this->user->is_admin || $this->user->isAbleTo('delete_employee')) && $row->id !== $this->user->id) {
                        $action .= ' <a href="javascript:;" class="btn btn-danger btn-circle delete-row"
                            data-bs-toggle="tooltip" data-row-id="' . $row->id . '" data-original-title="'.__('app.delete').'"><i class="fa fa-times" aria-hidden="true"></i></a>';
                    }

                    $action .= '</div>';
                    return $action;
                })
                ->addColumn('image', function ($row) {
                    return '<img src="'.$row->user_image_url.'" class="img" height="65em" width="65em"/> ';
                })
                ->editColumn('name', function ($row) {
                    return ucfirst($row->name);
                })
                ->editColumn('location', function ($row) {
                    $location_list = '';

                    foreach ($row->location as $location) {
                        $location_list .= '<span class="badge badge-primary username-badge">'.$location->name.'</span>';
                    }

                    return $location_list == '' ? '--' : $location_list;
                })
                ->editColumn('group_id', function ($row) {
                    return $row->group_id ? ucfirst($row->employeeGroup->name) : '--';
                })
                ->editColumn('assignedServices', function ($row) {
                    $service_list = '';

                    foreach ($row->services as $service) {
                        $service_list .= '<span style="margin:0.3em; padding:0.3em" class="badge bg-primary">'.$service->name.'</span>';
                    }

                    return $service_list == '' ? '--' : $service_list;
                })
                ->addColumn('role_name', function ($row) use ($roles){
                    if (($row->id === $this->user->id) || !$this->user->roles()->withoutGlobalScopes()->first()->hasPermission('update_employee')) {
                        return $row->role->display_name;
                    }

                    $roleOption = '<select style="width:100%" name="role_id" class="form-control role_id" data-user-id="'.$row->id.'">';

                    foreach ($roles as $role){
                        $roleOption .= '<option ';

                        if($row->role->id == $role->id){
                            $roleOption .= ' selected ';
                        }

                        $roleOption .= 'value="'.$role->id.'">'.ucwords($role->display_name).'</option>';
                    }

                    $roleOption .= '</select>';

                    return $roleOption;
                })
                ->addIndexColumn()
                ->rawColumns(['action', 'image', 'role_name', 'location', 'assignedServices'])
                ->toJson();
        }

        return view('admin.employees.index');
    }

    /**
     * @return \Illuminate\Contracts\View\Factory|\Illuminate\View\View
     */
    public function create()
    {
        abort_if(!$this->user->roles()->withoutGlobalScopes()->first()->hasPermission('create_employee'), 403);

        $groups = EmployeeGroup::all();
        $roles = Role::all();
        $business_services = BusinessService::with('location')->get();
        $serviceLocations = $business_services->unique('location');
        $locations = [];

        foreach($serviceLocations as $serviceLocation)
        {
            $locations[] = $serviceLocation->location;
        }

        return view('admin.employees.create', compact('groups', 'roles', 'business_services', 'locations'));
    }

    /**
     * @param StoreRequest $request
     * @return array
     */
    public function store(StoreRequest $request)
    {
        abort_if(!$this->user->roles()->withoutGlobalScopes()->first()->hasPermission('create_employee'), 403);

        $user = new User();

        $user->name     = $request->name;
        $user->email    = $request->email;

        if ($request->group_id !== '0')
        {
            $user->group_id = $request->group_id;

            $service_array = array();
            $services_lists  = EmployeeGroupService::where('employee_groups_id', $request->group_id)->get();

            foreach ($services_lists as $key => $services_list) {
                $service_array [] = $services_list->business_service_id;
            }

        }

        $user->calling_code = $request->calling_code;
        $user->mobile = $request->mobile;

        if($request->password != ''){
            $user->password = $request->password;
        }

        if ($request->hasFile('image')) {
            $user->image = Files::upload($request->image, 'avatar');
        }

        $user->save();

        $address = new Address();
        $address->user_id = $user->id;
        $address->house_no = $request->house_no;
        $address->address_line = $request->address_line;
        $address->city = $request->city;
        $address->state = $request->address_line;
        $address->pin_code = $request->pin_code;
        $address->country_id = $request->country_id;
        $address->save();

        if ($request->group_id !== '0') { $user->services()->sync($service_array);
        }


        /* Assign services to users */
        $business_service_id = $request->business_service_id;

        if($business_service_id)
        {
            $assignedServices   = array();

            foreach ($business_service_id as $key => $service_id)
            {
                $assignedServices[] = $business_service_id[$key];
            }

            $user->services()->sync($assignedServices);
            $user->location()->sync($request->location);
        }


        // Add default employee role
        $user->attachRole($request->role_id);

        $this->addOrEditSchedule($user);

        return Reply::redirect(route('admin.employee.index'), __('messages.createdSuccessfully'));

    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show()
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit(Request $request, $id)
    {
        $employee = User::where('id', $id)->first();
        abort_if(!$this->user->roles()->withoutGlobalScopes()->first()->hasPermission('update_employee') || $employee->id === $this->user->id || $this->user->id === $employee->id, 403);

        $groups = EmployeeGroup::all();
        $roles = Role::all();

        /* push all previous assigned services to an array */
        $selectedServices = array();
        $assignedServices = User::with(['services'])->find($id);

        foreach ($assignedServices->services as $key => $services)
        {
            array_push($selectedServices, $services->id);
        }

        /* Locations of employee */
        $selectedLocations = [];

        $userLocations = User::with(['location'])->find($id);

        /* @phpstan-ignore-next-line */
        $userLocation = $userLocations->location;

        foreach ($userLocation as $location)
        {
            $selectedLocations[] = $location->id;
        }

        $businessServices = BusinessService::with('location')->active()->get();
        $serviceLocations = $businessServices->unique('location');
        $locations = [];

        foreach($serviceLocations as $serviceLocation)
        {
            $locations[] = $serviceLocation->location;
        }

        return view('admin.employees.edit', compact('employee', 'groups', 'roles', 'selectedServices', 'businessServices', 'locations', 'selectedLocations'));
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(UpdateRequest $request, $id)
    {
        abort_if(!$this->user->roles()->withoutGlobalScopes()->first()->hasPermission('update_employee'), 403);

        $user = User::findOrFail($id);
        $assignedServices = array();

        /* save new edited services */
        $services = $request->service_id;

        if($services){
            foreach ($services as $key => $service){
                $assignedServices[] = $services[$key];
            }
        }

        $user->name         = $request->name;
        $user->email        = $request->email;
        $user->group_id     = $request->group_id == 0 ? null : $request->group_id;

        $group_id = User::where('id', $user->id)->first()->group_id;
        $preAssignedServices = array();

        if ($request->group_id != $group_id && $group_id != null) {

            $group = EmployeeGroup::whereId($group_id)->first();

            if($group != null){

                foreach ($group->businessServices as $key => $services_list) {
                    $preAssignedServices [] = $services_list->id;
                }
            }
        }

        if ($request->group_id !== '0' && $request->group_id != $group_id){

            $user->group_id = $request->group_id;

            DB::table('business_service_user')->where(['user_id' => $user->id])->delete();

            $services = EmployeeGroup::whereId($user->group_id)->first();

            foreach ($services->businessServices as $services_list) {
                $assignedServices [] = $services_list->id;
            }
        }

        $differenceArray = array_diff($assignedServices, $preAssignedServices);

        if($request->password != ''){
            $user->password = $request->password;
        }

        if (($request->mobile != $user->mobile || $request->calling_code != $user->calling_code) && $user->mobile_verified == 1) {
            $user->mobile_verified = 0;
        }

        $user->mobile       = $request->mobile;
        $user->calling_code = $request->calling_code;

        if ($request->image_delete == 'yes') {
            Files::deleteFile($user->image, 'avatar');
            $user->image = null;
        }

        if ($request->hasFile('image')) {
            $user->image = Files::upload($request->image, 'avatar');
        }

        $user->save();

        $user->services()->detach();

        $user->services()->sync($differenceArray);

        if($request->location)
        {
            $schedules = EmployeeSchedules::where('employee_id', $user->id)->get()->unique('location_id');
            $employeeLocation = [];

            foreach ($schedules as $schedule)
            {
                $employeeLocation [] = $schedule->location_id;
            }

            $diff = array_diff($employeeLocation, $request->location);
            $count = count($diff);

            if($count > 0)
            {
                for($i = 0; $i < $count; $i++)
                {
                    $user->location()->detach($diff[$i]);
                    EmployeeSchedules::where('location_id', $diff[$i])->where('employee_id', $user->id)->delete();
                }
            }

            foreach ($request->location as $location)
            {
                if(!in_array($location, $employeeLocation))
                {
                    $user->location()->attach($location);
                    $this->addOrEditSchedule($user);
                }
            }

        }
        else
        {
            $user->services()->detach();
        }

        $user->syncRoles([$request->role_id]);

        $address = Address::firstOrNew(['user_id' => $user->id]);
        $address->house_no = $request->house_no;
        $address->address_line = $request->address_line;
        $address->city = $request->city;
        $address->state = $request->address_line;
        $address->pin_code = $request->pin_code;
        $address->country_id = $request->country;
        $address->save();

        $this->addOrEditSchedule($user);

        return Reply::redirect(route('admin.employee.index'), __('messages.updatedSuccessfully'));
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        $user = User::findOrFail($id);
        abort_if(!$this->user->roles()->withoutGlobalScopes()->first()->hasPermission('delete_employee') || $user->id === $this->user->id, 403);

        $user->delete();
        return Reply::success(__('messages.recordDeleted'));
    }

    public function changeRole(ChangeRoleRequest $request)
    {
        $user = User::findOrFail($request->user_id);

        $user->roles()->sync($request->role_id);

        Artisan::call('cache:clear');

        $this->addOrEditSchedule($user);

        return Reply::success(__('messages.roleChangedSuccessfully'));
    }

    public function addOrEditSchedule(User $user)
    {
        /* @phpstan-ignore-next-line */
        $locations = $user->location;

        foreach($locations as $location)
        {
            $employee = EmployeeSchedules::where('employee_id', $user->id)->where('location_id', $location->id)->count();

            if($user->hasRole('employee') && $employee == 0)
            {
                $bookingTime = BookingTime::where('location_id', $location->id)->get();

                foreach($bookingTime as $bookingTimes){
                    $startTime = Carbon::parse($bookingTimes->utc_start_time, 'UTC')->setTimezone($this->settings->timezone);
                    $endTime = Carbon::parse($bookingTimes->utc_end_time, 'UTC')->setTimezone($this->settings->timezone);

                    $endTime = $endTime->setTimezone($location->timezone->zone_name)->format('Y-m-d H:i:s');
                    $startTime = $startTime->setTimezone($location->timezone->zone_name)->format('Y-m-d H:i:s');
                    $employeeSchedule = new EmployeeSchedules();
                    $employeeSchedule->employee_id = $user->id;
                    $employeeSchedule->location_id = $location->id;
                    $employeeSchedule->start_time = $startTime;
                    $employeeSchedule->end_time = $endTime;
                    $employeeSchedule->days = $bookingTimes->day;

                    if($bookingTimes->status == 'enabled'){
                        $employeeSchedule->is_working = 'yes';
                    }
                    else {
                        $employeeSchedule->is_working = 'no';
                    }

                    $employeeSchedule->save();
                }
            }
            else {

                if(!($user->hasRole('employee')) && $employee != 0){
                    $employeeSchedules = EmployeeSchedules::where('employee_id', $user->id)->get();

                    foreach($employeeSchedules as $employeeSchedule){
                        $employeeSchedule->delete();
                    }
                }

            }
        }

        /*
        $employee = EmployeeSchedules::where('employee_id', $user->id)->count();

        if($user->hasRole('employee') && $employee == 0){

            $bookingTime = BookingTime::all();

            foreach($bookingTime as $bookingTimes){

                $employeeSchedule = new EmployeeSchedules();
                $employeeSchedule->employee_id = $user->id;
                $employeeSchedule->start_time = $bookingTimes->start_time;
                $employeeSchedule->end_time = $bookingTimes->end_time;
                $employeeSchedule->days = $bookingTimes->day;

                if($bookingTimes->status == 'enabled'){
                    $employeeSchedule->is_working = 'yes';
                }
                else {
                    $employeeSchedule->is_working = 'no';
                }

                $employeeSchedule->save();
            }
        }
        else {

            if(!($user->hasRole('employee')) && $employee != 0){
                $emp = EmployeeSchedules::where('employee_id', $user->id)->get();

                foreach($emp as $employee){
                    $employee->delete();
                }
            } */
    }

}
