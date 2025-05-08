<?php

namespace App\Http\Controllers\Admin;

use App\OfficeLeave;
use App\Helper\Reply;
use App\Http\Controllers\Controller;
use App\Http\Requests\OfficeLeaves\StoreRequest;
use App\Http\Requests\OfficeLeaves\UpdateRequest;

class OfficeLeaveController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */

    public function index()
    {
        //
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        return view('admin.office-leaves.create');
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(StoreRequest $request)
    {
        $office_Leave = new OfficeLeave();
        $office_Leave->title = $request->title;
        $office_Leave->start_date = $request->startdate;
        $office_Leave->end_date = $request->enddate;
        $office_Leave->save();

        return Reply::success(__('messages.createdSuccessfully'));
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Office_Leave  $office_Leave
     * @return \Illuminate\Http\Response
     */
    public function show()
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  \App\Office_Leave  $office_Leave
     * @return \Illuminate\Http\Response
     */
    public function edit($id)
    {
        $office_leave = OfficeLeave::where('id', $id)->firstOrFail();

        if (request()->ajax()) {
            return view('admin.office-leaves.edit', compact('office_leave'));
        }

        return view('admin.office-leaves.edit', compact('office_leave'));
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\Office_Leave  $office_Leave
     * @return \Illuminate\Http\Response
     */
    public function update(UpdateRequest $request,$id)
    {
        $office_Leave = OfficeLeave::where('id', $id)->firstOrFail();
        $office_Leave->title = $request->title;
        $office_Leave->start_date = $request->startDate;
        $office_Leave->end_date = $request->endDate;
        $office_Leave->save();

        return Reply::success(__('messages.updatedSuccessfully'));
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Office_Leave  $office_Leave
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        OfficeLeave::destroy($id);

        return Reply::success(__('messages.recordDeleted'));
    }

}
