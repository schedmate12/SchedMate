<?php

namespace App\Http\Controllers\Admin;

use App\Country;
use App\Location;
use App\Helper\Reply;
use App\Http\Controllers\Controller;
use App\Http\Requests\Location\StoreLocation;
use App\Timezone;
use Illuminate\Http\Request;

class LocationController extends Controller
{

    public function __construct()
    {
        parent::__construct();
        view()->share('pageTitle', __('menu.locations'));
    }

    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        abort_if(!$this->user->roles()->withoutGlobalScopes()->first()->hasPermission('read_location'), 403);

        if(request()->ajax()){
            $locations = Location::all();

            return datatables()->of($locations)
                ->addColumn('action', function ($row) {
                    $action = '<div class="text-right">';

                    if ($this->user->roles()->withoutGlobalScopes()->first()->hasPermission('update_location')) {
                        $action .= '<a href="' . route('admin.locations.edit', [$row->id]) . '" class="btn btn-primary btn-circle"
                          data-bs-toggle="tooltip" data-original-title="'.__('app.edit').'"><i class="fa fa-pencil" aria-hidden="true"></i></a>';
                    }

                    if ($this->user->roles()->withoutGlobalScopes()->first()->hasPermission('delete_location')) {
                        $action .= ' <a href="javascript:;" class="btn btn-danger btn-circle delete-row"
                        data-bs-toggle="tooltip" data-row-id="' . $row->id . '" data-original-title="'.__('app.delete').'"><i class="fa fa-times" aria-hidden="true"></i></a>';
                    }

                    $action .= '</div>';
                    return $action;
                })
                ->editColumn('name', function ($row) {
                    return ucfirst($row->name);
                })
                ->editColumn('country', function ($row) {
                        return $row->country ? $row->country->name : '-';
                })->editColumn('timezone', function ($row) {
                        return $row->timezone ? $row->timezone->zone_name : '-';
                })
                ->addIndexColumn()
                ->rawColumns(['action'])
                ->toJson();
        }

        return view('admin.location.index');
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        abort_if(!$this->user->roles()->withoutGlobalScopes()->first()->hasPermission('create_location'), 403);

        $googleMapAPIKey = $this->googleMapAPIKey;
        return view('admin.location.create', compact('googleMapAPIKey'));
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */

    public function store(StoreLocation $request)
    {
        abort_if(!$this->user->roles()->withoutGlobalScopes()->first()->hasPermission('create_location'), 403);

        $location = new Location();
        $location->name = $request->name;
        $location->pincode = $request->pincode;
        $location->lng = $request->lng;
        $location->lat = $request->lat;
        $location->country_id = $request->country_id;
        $location->timezone_id = $request->timezone_id;

        $location->save();

        if (!$request->redirect_url) {
            $locations = Location::all();
            $options = $this->options($locations, $location);
        }

        return $request->redirect_url ? Reply::redirect($request->redirect_url, __('messages.createdSuccessfully')) : Reply::successWithData(__('messages.createdSuccessfully'), ['data' => $options]);
    }

    public function options($items, $group = null, $columnName = null)
    {
        $options = '';


        foreach ($items as $item) {

            $name = is_null($columnName) ? $item->name : $item->{$columnName};

            $selected = (!is_null($group) && ($item->id == $group->id)) ? 'selected' : '';

            $options .= '<option ' . $selected . ' value="' . $item->id . '"> ' . $name . ' </option>';
        }

        return $options;
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Location  $location
     * @return \Illuminate\Http\Response
     */
    // @codingStandardsIgnoreLine
    public function show($id)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  \App\Location  $location
     * @return \Illuminate\Http\Response
     */
    // @codingStandardsIgnoreLine
    public function edit(Location $location)
    {
        abort_if(!$this->user->roles()->withoutGlobalScopes()->first()->hasPermission('update_location'), 403);
        $countries = Country::all();
        $timezones = Timezone::where('country_id', $location->country_id)->get();
        $googleMapAPIKey = $this->googleMapAPIKey;

        return view('admin.location.edit', compact('location', 'countries', 'timezones', 'googleMapAPIKey'));
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\Location  $location
     * @return \Illuminate\Http\Response
     */
    public function update(StoreLocation $request, $id)
    {
        abort_if(!$this->user->roles()->withoutGlobalScopes()->first()->hasPermission('update_location'), 403);

        $location = Location::find($id);
        $location->name = $request->name;
        $location->pincode = $request->pincode;
        $location->lng = $request->lng;
        $location->lat = $request->lat;
        $location->country_id = $request->country_id;
        $location->timezone_id = $request->timezone_id;

        $location->save();

        if (!$request->redirect_url) {
            $locations = Location::all();
            $options = $this->options($locations, $location);
        }

        return $request->redirect_url ? Reply::redirect($request->redirect_url, __('messages.updatedSuccessfully')) : Reply::successWithData(__('messages.updatedSuccessfully'), ['data' => $options]);

    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Location  $location
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        abort_if(!$this->user->roles()->withoutGlobalScopes()->first()->hasPermission('delete_location'), 403);

        $product = Location::where('id', $id)->first();
        $product->products()->delete();

        Location::destroy($id);

        return Reply::success(__('messages.recordDeleted'));
    }

    public function getCountryTimezone(Request $request)
    {
        $timezone = Timezone::where('country_id', $request->country_id)->orderBy('zone_name')->get();

        return $timezone;
    }

}

