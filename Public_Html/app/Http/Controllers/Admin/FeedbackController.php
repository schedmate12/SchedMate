<?php

namespace App\Http\Controllers\Admin;

use App\Helper\Reply;
use App\CustomerFeedback;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Http\Requests\Front\CustomerFeedbackRequest;

class FeedbackController extends Controller
{

    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        if (request()->ajax()) {

            $feedback = CustomerFeedback::get();

            return DataTables()->of($feedback)
                ->addColumn('action', function ($row) {
                    $action = '';
                    $action .= '<a href="javascript:;" data-id="' . $row->id . '" class="btn btn-primary btn-circle edit-feedback"
                    data-bs-toggle="tooltip" data-original-title="' . __('app.edit') . '"><i class="fa fa-pencil" aria-hidden="true"></i></a>';

                    $action .= ' <a href="javascript:;" class="btn btn-danger btn-circle delete-feedback"
                        data-bs-toggle="tooltip" data-row-id="' . $row->id . '" data-original-title="' . __('app.delete') . '"><i class="fa fa-times" aria-hidden="true"></i></a>';
                    return $action;
                })
                ->editColumn('name', function ($row) {
                    return ucfirst($row->customer_name);
                })
                ->editColumn('message', function ($row) {
                    return ucfirst($row->feedback_message);
                })
                ->editColumn('status', function ($row) {

                    if($row->status == 'active'){
                        return '<label class="badge bg-success">'.__('app.active').'</label>';
                    }
                    elseif($row->status == 'inactive'){
                        return '<label class="badge badge-danger">'.__('app.inactive').'</label>';
                    }
                })
                ->addIndexColumn()
                ->rawColumns(['status', 'action'])
                ->toJson();
        }

        return view('admin.customer-feedback.index');
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        return view('admin.customer-feedback.create');
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(CustomerFeedbackRequest $request)
    {
        $feedback = new CustomerFeedback();
        $feedback->feedback_message = $request->feedback_message;
        $feedback->customer_name = $request->customer_name;
        $feedback->status = 'active';
        $feedback->save();

        return Reply::success(__('messages.createdSuccessfully'));
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\CustomerFeedback  $customerFeedback
     * @return \Illuminate\Http\Response
     */
    public function show()
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  \App\CustomerFeedback  $customerFeedback
     * @return \Illuminate\Http\Response
     */
    public function edit($id)
    {
        $feedback = CustomerFeedback::where('id', $id)->firstOrFail();
        return view('admin.customer-feedback.edit', compact('feedback'));
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\CustomerFeedback  $customerFeedback
     * @return \Illuminate\Http\Response
     */
    public function update(CustomerFeedbackRequest $request, $id)
    {
        $feedback = CustomerFeedback::findOrFail($id);

        $feedback->feedback_message = $request->feedback_message;
        $feedback->customer_name = $request->customer_name;
        $feedback->status = $request->status;
        $feedback->save();

        return Reply::success(__('messages.updatedSuccessfully'));
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\CustomerFeedback  $customerFeedback
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        CustomerFeedback::destroy($id);
        return Reply::success(__('messages.recordDeleted'));
    }

}
