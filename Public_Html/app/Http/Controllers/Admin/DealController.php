<?php

namespace App\Http\Controllers\Admin;

use App\Tax;
use App\Deal;
use App\DealItem;
use App\ItemTax;
use App\Location;
use Carbon\Carbon;
use App\Helper\Files;
use App\Helper\Reply;
use App\BusinessService;
use Illuminate\Support\Arr;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Controller;
use App\Http\Requests\Deal\CreateDeal;
use App\Http\Requests\Deal\StoreRequest;
use App\Http\Requests\Deal\UpdateRequest;

class DealController extends Controller
{

    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function __construct()
    {
        parent::__construct();
        view()->share('pageTitle', __('menu.deals'));

    }

    public function index()
    {
        abort_if(!$this->user->roles()->withoutGlobalScopes()->first()->hasPermission('read_deal'), 403);

        if(request()->ajax())
        {
            $deals = Deal::get();

            return datatables()->of($deals)
                ->addColumn('action', function ($row) {
                    $action = '<div class="text-right">';

                    if($this->user->isAbleTo('update_deal')) {
                        $action .= '<a href="' . route('admin.deals.edit', [$row->id]) . '" class="btn btn-primary btn-circle"
                        data-bs-toggle="tooltip" data-original-title="'.__('app.edit').'"><i class="fa fa-pencil" aria-hidden="true"></i></a>';
                    }

                    if($this->user->isAbleTo('create_deal')) {
                        $action .= ' <a href="javascript:;" class="btn btn-warning btn-circle duplicate-row"
                        data-bs-toggle="tooltip" data-row-id="' . $row->id . '" data-original-title="'.__('app.duplicate').'"><i class="fa fa-clone" aria-hidden="true"></i></a>';
                    }

                    $action .= ' <a href="javascript:;" data-row-id="' . $row->id . '" class="btn btn-info btn-circle view-deal"
                    data-bs-toggle="tooltip" data-original-title="'.__('app.view').'"><i class="fa fa-eye" aria-hidden="true"></i></a> ';

                    if($this->user->isAbleTo('delete_deal')) {
                        $action .= ' <a href="javascript:;" class="btn btn-danger btn-circle delete-row"
                        data-bs-toggle="tooltip" onclick="this.blur()" data-row-id="' . $row->id . '" data-original-title="'.__('app.delete').'"><i class="fa fa-times" aria-hidden="true"></i></a>';
                    }

                    $action .= '</div>';
                    return $action;
                })
                ->addColumn('image', function ($row) {
                    return '<img src="'.$row->deal_image_url.'" class="img" height="65em" width="65em"/> ';
                })
                ->editColumn('title', function ($row) {
                    return ucfirst($row->title);
                })

                ->editColumn('original_amount', function ($row) {
                    return currencyFormatter($row->original_amount);
                })
                ->editColumn('deal_amount', function ($row) {
                    return currencyFormatter($row->deal_amount);
                })
                ->editColumn('status', function ($row) {
                    $status = '---';
                    $condition = Carbon::now()->timezone($this->settings->timezone)->gt( $row->end_date_time);

                    if($condition){
                        $status = '<label class="badge badge-danger">'.__('app.expired').'</label>';
                    }
                    elseif($row->status == 'active'){
                        $status = '<label class="badge bg-success">'.__('app.active').'</label>';
                    }
                    elseif($row->status == 'inactive'){
                        $status = '<label class="badge badge-danger">'.__('app.inactive').'</label>';
                    }
                    return $status;
                })
                ->editColumn('usage', function ($row) {
                    $used_time = $row->used_time; $uses_limit = $row->uses_limit;

                    if($used_time == ''){
                        $used_time = 0;
                    }

                    if($uses_limit == 0){
                        $uses_limit = '&infin;';
                    }

                    return $used_time.'/'.$uses_limit;
                })
                ->addColumn('deal_location', function ($row) {
                    return $row->location->name;
                })
                ->addIndexColumn()
                ->rawColumns(['action', 'image', 'status', 'usage'])
                ->toJson();
        }

        return view('admin.deals.index');
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create(CreateDeal $request)
    {
        abort_if(!$this->user->roles()->withoutGlobalScopes()->first()->hasPermission('create_deal'), 403);

        $days = ['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'];
        $locations = Location::withoutGlobalScope('company')->groupBy('name')->get();
        $services = BusinessService::with('location')->orderBy('name')->get();
        $taxes = Tax::active()->get();

        $variables = compact('days', 'taxes', 'locations', 'services');

        if ($request->deal_id) {
            $deal = Deal::with('location', 'services')->findOrFail($request->deal_id);
            $variables = Arr::add($variables, 'deal', $deal);
            $selectedDays = json_decode($deal->days);
            $variables = Arr::add($variables, 'selectedDays', $selectedDays);

            $deal_services = $deal->services()->pluck('business_service_id')->toArray();
            $variables = Arr::add($variables, 'deal_services', $deal_services);

            $deal_items = $deal->services()->with('businessService')->get();
            $variables = Arr::add($variables, 'deal_items', $deal_items);

            $deal_items_table = view('admin.deals.deal_items_edit', compact('deal_items'))->render();
            $variables = Arr::add($variables, 'deal_items_table', $deal_items_table);
        }

        return view('admin.deals.create', $variables);
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(StoreRequest $request)
    {
        abort_if(!$this->user->roles()->withoutGlobalScopes()->first()->hasPermission('create_deal'), 403);

        if(!$request->has('days')){
            return Reply::error( __('messages.coupon.selectDay'));
        }

        $services = $request->services;
        $location = Location::with('timezone')->where('name', $request->locations)->first();
        $startDate = Carbon::createFromFormat('Y-m-d H:i a', $request->deal_startDate, $location->timezone ? $location->timezone->zone_name : '')->setTimezone($this->settings->timezone)->format('Y-m-d H:i:s');
        $endDate = Carbon::createFromFormat('Y-m-d H:i a', $request->deal_endDate, $location->timezone ? $location->timezone->zone_name : '')->setTimezone($this->settings->timezone)->format('Y-m-d H:i:s');
        $startTime = Carbon::createFromFormat('H:i a', $request->deal_startTime, $location->timezone ? $location->timezone->zone_name : '')->setTimezone($this->settings->timezone)->format('H:i:s');
        $endTime  = Carbon::createFromFormat('H:i a', $request->deal_endTime, $location->timezone ? $location->timezone->zone_name : '')->setTimezone($this->settings->timezone)->format('H:i:s');

        $deal = new Deal();
        $deal->title                   = $request->title;
        $deal->slug                    = $request->slug;
        $deal->start_date_time         = $startDate;
        $deal->end_date_time           = $endDate;
        $deal->open_time               = $startTime;
        $deal->close_time              = $endTime;
        $deal->max_order_per_customer  = $request->customer_uses_time;
        $deal->status                  = $request->status;
        $deal->days                    = json_encode($request->days);
        $deal->description             = $request->description;
        $deal->location_id             = $request->locations;
        $deal->deal_applied_on         = $request->choice;
        $deal->discount_type           = $request->discount_type;
        $deal->percentage              = $request->discount;

        if($request->uses_time == ''){
            $deal->uses_limit          = 0;
        }

        $deal->uses_limit              = $request->uses_time;

        if(count($services) > 1){
            $deal->deal_type           = 'Combo';
        }

        if ($request->hasFile('feature_image')) {
            $deal->image = Files::upload($request->feature_image, 'deal');
        }

        /* Save deal */
        $deal_services = $request->deal_services;
        $prices = $request->deal_unit_price;
        $quantity = $request->deal_quantity;
        $discount = $request->deal_discount;

        $discountAmount = 0;
        $amountToPay    = 0;
        $originalAmount = 0;
        $dealItems      = array();

        foreach ($deal_services as $key => $service){
            $amount = ($quantity[$key] * $prices[$key]);
            $dealItems[] = [
                'business_service_id'   => $deal_services[$key],
                'quantity'              => $quantity[$key],
                'unit_price'         => $prices[$key],
                'discount_amount'       => $discount[$key],
                'total_amount'          => $amount - $discount[$key],
            ];
            $originalAmount = ($originalAmount + $amount);
            $discountAmount = ($discountAmount + $discount[$key]);
        }

        $amountToPay = $originalAmount - $discountAmount;

        $deal->deal_amount             = $amountToPay;
        $deal->original_amount         = $originalAmount;
        $deal->save();

        /* Save deal items */
        foreach ($dealItems as $key => $dealItem){
            $dealItems[$key]['deal_id'] = $deal->id;
        }

        DB::table('deal_items')->insert($dealItems);

        /* store taxes */
        $tax_ids = $request->tax_ids;

        if($tax_ids !== null)
        {
            foreach ($tax_ids as $key => $tax_id)
            {
                $taxService = new ItemTax();
                $taxService->tax_id = $tax_id;
                $taxService->deal_id = $deal->id;
                $taxService->save();
            }
        }

        return Reply::redirect(route('admin.deals.index'), __('messages.createdSuccessfully'));
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        $deal = Deal::with('location')->findOrFail($id);
        $deal_items = DealItem::with('businessService')->where('deal_id', $id)->get();

        if($deal->days){
            $days = json_decode($deal->days);
        }

        $locations = $deal->locations;

        $selectedTax = array();
        $dealsTax = ItemTax::where('deal_id', $id)->get();

        foreach ($dealsTax as $key => $dealsTaxes)
        {
            $tax = Tax::where('id', $dealsTaxes->tax_id)->first();
            array_push($selectedTax, $tax);
        }

        return view('admin.deals.show', compact('selectedTax', 'deal', 'days', 'locations', 'deal_items'));
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit($id)
    {
        abort_if(!$this->user->roles()->withoutGlobalScopes()->first()->hasPermission('update_deal'), 403);
        $days = ['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'];
        $selectedLocations = [];

        $deal = Deal::with(['location' => function ($q){
            $q->with('timezone');
        }], )->findOrFail($id);

        $selectedDays = json_decode($deal->days);

        $services = BusinessService::all();
        $deal_services = DealItem::where('deal_id', $id)->pluck('business_service_id')->toArray();

        $deal_items = DealItem::with('businessService', 'deal')->where('deal_id', $id)->get();
        $deal_items_table = view('admin.deals.deal_items_edit', compact('deal_items'))->render();

        $selectedTax = array();
        $taxServices = ItemTax::where('deal_id', $deal->id)->get();

        foreach ($taxServices as $key => $taxService)
        {
            array_push($selectedTax, $taxService->tax_id);
        }

        $taxes = Tax::active()->get();

        return view('admin.deals.edit', compact('selectedTax', 'taxes', 'days', 'deal', 'selectedDays', 'services', 'deal_services', 'deal_items_table'));
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
        abort_if(!$this->user->roles()->withoutGlobalScopes()->first()->hasPermission('update_deal'), 403);

        if(!$request->has('days')){
            return Reply::error( __('messages.coupon.selectDay'));
        }

        /* delete all items from deal_items table */
        DB::table('deal_items')->where('deal_id', $id)->delete();

        $services = $request->services;
        $location = Location::with('timezone')->where('name', $request->locations)->first();
        $startDate = Carbon::createFromFormat('Y-m-d H:i a', $request->deal_startDate, $location->timezone->zone_name)->setTimezone($this->settings->timezone)->format('Y-m-d H:i:s');
        $endDate = Carbon::createFromFormat('Y-m-d H:i a', $request->deal_endDate, $location->timezone->zone_name)->setTimezone($this->settings->timezone)->format('Y-m-d H:i:s');
        $startTime = Carbon::createFromFormat('H:i a', $request->deal_startTime, $location->timezone->zone_name)->setTimezone($this->settings->timezone)->format('H:i:s');
        $endTime  = Carbon::createFromFormat('H:i a', $request->deal_endTime, $location->timezone->zone_name)->setTimezone($this->settings->timezone)->format('H:i:s');

        $deal = Deal::findOrFail($id);
        $deal->title                   = $request->title;
        $deal->slug                    = $request->slug;
        $deal->start_date_time         = $startDate;
        $deal->end_date_time           = $endDate;
        $deal->open_time               = $startTime;
        $deal->close_time              = $endTime;
        $deal->max_order_per_customer  = $request->customer_uses_time;
        $deal->status                  = $request->status;
        $deal->days                    = json_encode($request->days);
        $deal->description             = $request->description;
        $deal->location_id             = $request->locations;
        $deal->deal_applied_on         = $request->choice;
        $deal->discount_type           = $request->discount_type;
        $deal->percentage              = $request->discount;

        if($request->uses_time == ''){
            $deal->uses_limit          = 0;
        }

        $deal->uses_limit              = $request->uses_time;

        if(count($services) > 1){
            $deal->deal_type           = 'Combo';
        }

        if ($request->hasFile('feature_image')) {
            $deal->image = Files::upload($request->feature_image, 'deal');
        }

        if ($request->feature_image_delete == 'yes') {
            Files::deleteFile($deal->feature_image, 'deal');
            $deal->image = null;
        }

        /* Save deal */
        $deal_services = $request->deal_services;
        $prices = $request->deal_unit_price;
        $quantity = $request->deal_quantity;
        $discount = $request->deal_discount;

        $discountAmount = 0;
        $amountToPay    = 0;
        $originalAmount = 0;
        $dealItems      = array();

        foreach ($deal_services as $key => $service){
            $amount = ($quantity[$key] * $prices[$key]);
            $dealItems[] = [
                'business_service_id'   => $deal_services[$key],
                'quantity'              => $quantity[$key],
                'unit_price'            => $prices[$key],
                'discount_amount'       => $discount[$key],
                'total_amount'          => $amount - $discount[$key],
            ];
            $originalAmount = ($originalAmount + $amount);
            $discountAmount = ($discountAmount + $discount[$key]);
        }

        $amountToPay = $originalAmount - $discountAmount;

        $deal->deal_amount             = $amountToPay;
        $deal->original_amount         = $originalAmount;

        $deal->save();

        /* Save deal items */
        foreach ($dealItems as $key => $dealItem){
            $dealItems[$key]['deal_id'] = $deal->id;
        }

        DB::table('deal_items')->insert($dealItems);

        /* delete existing taxes */
        $taxServices = ItemTax::where('deal_id', $id)->get();

        foreach ($taxServices as $key => $taxService)
        {
            ItemTax::destroy($taxService->id);
        }

        /* update taxes */
        $tax_ids = $request->tax_ids;

        if($tax_ids !== null)
        {
            foreach ($tax_ids as $key => $tax_id)
            {
                $taxService = new ItemTax();
                $taxService->tax_id = $tax_id;
                $taxService->deal_id = $deal->id;
                $taxService->save();
            }
        }

        return Reply::redirect(route('admin.deals.index'), __('messages.createdSuccessfully'));
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        abort_if(!$this->user->roles()->withoutGlobalScopes()->first()->hasPermission('delete_coupon'), 403);

        $coupon = Deal::findOrFail($id);
        $coupon->delete();
        return Reply::success(__('messages.recordDeleted'));
    }

    public function selectLocation(Request $request)
    {
        $services           = $request->services;
        $result_locations   = [];
        $selected_location  = '';
        $result_array       = [];

        foreach ($services as $key => $service)
        {
            $ser2 = BusinessService::with('location')->where('name', $services[$key])->get();

            foreach ($ser2 as $key2 => $value2)
            {
                $result_locations[] = $value2->location_id;
            }
        }

        $array2 = array_count_values($result_locations);

        foreach ($array2 as $k => $v)
        {
            if($array2[$k] == count($services))
            {
                $result_array[] = $k;
            }
        }

        $locations = Location::whereIn('id', $result_array)->get();

        foreach ($locations as $location)
        {
            $selected_location .= '<option value="'.$location->name.'">'.$location->name.'</option>';
        }

        return response()->json(['selected_location' => $selected_location]);

    } /* end of selectLocation() */

    public function selectServices(Request $request)
    {
        $location = $request->locations;
        $selected_service = '';

        $locations = Location::with('services')->where('name', $location)->get();

        foreach ($locations as $key2 => $location){
            foreach($location->services as $service){
                $selected_service .= "<option value='".$service->name."'>".$service->name.'</option>';
            }
        }

        return response()->json(['selected_service' => $selected_service]);
    } /* end of selectServices() */

    public function resetSelection()
    {
        $all_services_array = '<option value="">Select Services</option>';
        $services = BusinessService::groupBy('name')->get();

        foreach ($services as $service)
        {
            $all_services_array .= '<option value="'.$service->name.'">'.$service->name.'</option>';
        }

        $all_locations_array = '<option value="">Select Location</option>';
        $locations = Location::groupBy('name')->get();

        foreach ($locations as $location)
        {
            $all_locations_array .= '<option value="'.$location->name.'">'.$location->name.'</option>';
        }

        return response()->json(['all_locations_array' => $all_locations_array, 'all_services_array' => $all_services_array]);
    } /* end of resetSelection()  */

    public function makeDeal(Request $request)
    {
        $services = $request->services;
        $location = $request->locations;

        $deal_list = BusinessService::whereIn('name', $services)->with('location')
            ->whereHas('location', function($query) use($location){
                $query->where('name', $location);
            })->get();

        $view = view('admin.deals.deal_items', compact('deal_list'))->render();

        return response()->json(['view' => $view]);
    }

} /* end of class */
