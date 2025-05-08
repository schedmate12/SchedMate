<?php

namespace App\Http\Controllers\Admin;

use App\User;
use Carbon\Carbon;
use App\Helper\Reply;
use App\EmployeeSchedules;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;

class EmployeeScheduleSettingController extends Controller
{

    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        if (request()->ajax()) {

            $employees = User::AllEmployees()->get();

            return datatables()->of($employees)
                ->addColumn('action', function ($row) {

                        $action = '<div class="text-right"><a href="javascript:;" data-row-id="' . $row->id . '" class="btn btn-info btn-circle view-employee-detail"
                        ><i class="fa fa-search" aria-hidden="true"></i></a></div>';

                    return $action;
                })
                ->editColumn('name', function ($row) {
                    return ucfirst($row->name);
                })
                ->addIndexColumn()
                ->rawColumns(['action'])
                ->toJson();
        }

        return view('admin.employee-schedule.index');
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
    public function show($id)
    {
        $schedules = EmployeeSchedules::with('employee')->where('employee_id', $id)->get();
        $serviceLocations = User::with('location')->where('id', $id)->first();
        $serviceLocations = $serviceLocations->location;
        return view('admin.employee-schedule.show', compact('schedules', 'serviceLocations'));
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit()
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {
        $updateSchedule = EmployeeSchedules::findOrFail($id);

        /* @phpstan-ignore-next-line */
        $startTime = Carbon::createFromFormat('H:i a', $request->updateStartTime, $updateSchedule->location->timezone->zone_name)->format('H:i:s');

        $updateSchedule->start_time = $startTime;

        $endTime = Carbon::createFromFormat('H:i a', $request->updateEndTime, $updateSchedule->location->timezone->zone_name)->format('H:i:s');
    
        $updateSchedule->end_time = $endTime;

        $updateSchedule->save();

        $schedules = EmployeeSchedules::with('employee')->where('employee_id', $request->empid)->get();
        $serviceLocations = User::with('location')->where('id', $request->empid)->first();
        $serviceLocations = $serviceLocations->location;

        $tableView = view('admin.employee-schedule.tableview', compact('schedules', 'serviceLocations'))->render();

        return Reply::dataOnly(['html' => $tableView]);

    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy()
    {
        //
    }

    public function updateWorking(Request $request, $id)
    {

        $updateWorking = EmployeeSchedules::findOrFail($id);
        $updateWorking->is_working = $request->isWorking;
        $updateWorking->save();

        $schedules = EmployeeSchedules::with('employee')->where('employee_id', $request->empid)->get();
        $serviceLocations = User::with('location')->where('id', $request->empid)->first();
        $serviceLocations = $serviceLocations->location;
        $tableView = view('admin.employee-schedule.tableview', compact('schedules', 'serviceLocations'))->render();

        return Reply::dataOnly(['html' => $tableView]);

    }

}
