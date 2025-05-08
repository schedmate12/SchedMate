<?php

namespace App\Http\Controllers\Admin;

use App\Helper\Files;
use App\Helper\Reply;
use App\Http\Controllers\Controller;
use App\Http\Requests\Front\NewDealRequest;
use App\Http\Requests\Front\NewDealUpdateRequest;
use App\Location;
use App\NewDeal;
use Illuminate\Support\Facades\File;
use Illuminate\Http\Request;

class NewDealController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */

    public function __construct()
    {
        parent::__construct();
        view()->share('pageTitle', __('menu.newDeal'));
    }

    public function index()
    {
        if (request()->ajax()) {

            $newDeal = NewDeal::get();

            return DataTables()->of($newDeal)
                ->addColumn('action', function ($row) {
                    $action = '';
                    $action .= '<a href="javascript:;" class="btn btn-info btn-circle view-newDeal"
                    data-bs-toggle="tooltip" data-id="' . $row->id . '" data-original-title="' . __('app.view') . '"><i class="fa fa-eye" aria-hidden="true"></i></a>';

                    $action .= ' <a href="javascript:;" data-id="' . $row->id . '" class="btn btn-primary btn-circle edit-newDeal"
                    data-bs-toggle="tooltip" data-original-title="' . __('app.edit') . '"><i class="fa fa-pencil" aria-hidden="true"></i></a>';

                    $action .= ' <a href="javascript:;" class="btn btn-danger btn-circle delete-newDeal"
                        data-bs-toggle="tooltip" data-row-id="' . $row->id . '" data-original-title="' . __('app.delete') . '"><i class="fa fa-times" aria-hidden="true"></i></a>';
                    return $action;
                })
                ->addColumn('image', function ($row) {
                    return ' <img src="' . $row->new_deal_image_url . '" class="img" height="65em" width="65em"/>';
                })
                ->editColumn('status', function ($row) {
                    if($row->status == 'active'){
                        return '<label class="badge bg-success">'.__('app.active').'</label>';
                    }
                    else{
                        return '<label class="badge badge-danger">'.__('app.inactive').'</label>';
                    }
                })
                ->editColumn('location_id', function ($row) {
                    return ucfirst($row->location->name);
                })
                ->addIndexColumn()
                ->rawColumns(['image', 'status', 'location_id', 'action'])
                ->toJson();
        }

        return view('admin.new-deal.index');
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        $locations = Location::get();
        return view('admin.new-deal.create', compact('locations'));
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(NewDealRequest $request)
    {
        $newDeal = new NewDeal();
        $newDeal->location_id = $request->location_id;
        $newDeal->link = $request->link;
        $newDeal->status = $request->status;

        if ($request->status == 'active') {
            NewDeal::where('location_id', $request->location_id)->update(['status' => 'inactive']);
        }

        if ($request->hasFile('image')) {
            $newDeal->image = Files::upload($request->image, 'newDeal');
        }

        $newDeal->save();
        return Reply::success(__('messages.createdSuccessfully'));
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        $newDeals = NewDeal::find($id);
        return view('admin.new-deal.show', compact('newDeals'));
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit($id)
    {
        $locations = Location::get();
        $newDeals = NewDeal::find($id);
        return view('admin.new-deal.edit', compact('newDeals', 'locations'));
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(NewDealUpdateRequest $request, $id)
    {
        NewDeal::where('status', 'active')->where('location_id', $request->location_id)->update(['status' => 'inactive']);
        $newDeal = NewDeal::findOrFail($id);
        $newDeal->status = $request->status;
        $newDeal->location_id = $request->location_id;
        $newDeal->link = $request->link;

        if ($request->hasFile('image')) {
            $newDeal->image = Files::upload($request->image, 'newDeal');
        }

        $newDeal->save();
        return Reply::success(__('messages.updatedSuccessfully'));
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        $newDeal = NewDeal::find($id);

        if (!is_null($newDeal->image)) {
            $path = public_path('user-uploads/newDeal/' . $newDeal->image);

            if ($path) {
                File::delete($path);
            }
        }

        NewDeal::destroy($id);

        return Reply::success(__('messages.recordDeleted'));
    }

}
