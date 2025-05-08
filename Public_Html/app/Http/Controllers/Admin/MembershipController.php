<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Membership; 
use App\UserMembership; 
use App\Helper\Reply;
use App\CompanySetting;
use Yajra\DataTables\Facades\DataTables;
use App\User;
use App\PaymentGatewayCredentials;
use Carbon\Carbon;

class MembershipController extends Controller
{
    public function __construct()
    {
        parent::__construct();
        $this->setting = CompanySetting::with('currency')->first();

        view()->share('pageTitle', __('menu.membership'));
        view()->share('setting', $this->setting);
    }

    public function index()
    {
        abort_if(!$this->user->roles()->withoutGlobalScopes()->first()->hasPermission('read_memberships'), 403);
    
        if (request()->ajax()) {
            $memberships = Membership::all();
    
            return datatables()->of($memberships)
                ->addColumn('action', function ($row) {
                    $action = '<div class="text-right">';
    
                    if ($this->user->roles()->withoutGlobalScopes()->first()->hasPermission('update_memberships')) {
                        $action .= '<a href="' . route('admin.memberships.edit', [$row->id]) . '" class="btn btn-sm btn-primary btn-circle"
                            data-bs-toggle="tooltip" data-original-title="' . __('app.edit') . '"><i class="fa fa-pencil" aria-hidden="true"></i></a>';
                    }
    
                    if ($this->user->roles()->withoutGlobalScopes()->first()->hasPermission('delete_memberships')) {
                        $action .= ' <a href="javascript:;" class="btn btn-sm btn-danger btn-circle delete-row"
                            data-bs-toggle="tooltip" data-row-id="' . $row->id . '" data-original-title="' . __('app.delete') . '"><i class="fa fa-times" aria-hidden="true"></i></a>';
                    }
    
                    $action .= '</div>';
                    return $action;
                })
                ->editColumn('name', function ($row) {
                    return ucfirst($row->name);
                })
                ->editColumn('price', function ($row) {
                    return number_format($row->price, 2);
                })
                ->editColumn('status', function ($row) {
                    if ($row->status == 'active') {
                        return '<label class="badge bg-success">' . __('app.active') . '</label>';
                    } elseif ($row->status == 'deactive') {
                        return '<label class="badge bg-danger">' . __('app.deactive') . '</label>';
                    } else {
                        return '<label class="badge bg-secondary">' . __('app.unknown') . '</label>';
                    }
                })
                ->addIndexColumn()
                ->rawColumns(['action', 'status'])
                ->toJson();
        }
    
        return view('admin.membership.index');
    }


    public function create()
    {
        return view('admin.membership.create');
    }
    
    public function list()
    {
        $memberships = Membership::all();
        $currentUser = auth()->user();
        $activeMembership = $currentUser->activeMembership()->with('membership')->first();
        return view('admin.membership.list', compact('memberships', 'activeMembership'));
    }
    
    public function purchase($id)
    {
        $membership = Membership::findOrFail($id);
         $credentials = PaymentGatewayCredentials::first();
         return view('admin.membership.buy', compact('membership','credentials'));
    }
    
    public function offlinePayment($id)
    {
        $membership = Membership::findOrFail($id);
        $startDate = Carbon::now();
        $endDate = $startDate->copy()->addDays($membership->duration_days);
        
         UserMembership::create([
        'user_id' => $this->user->id,
        'membership_id' => $id,
        'start_date' => $startDate,
        'end_date' => $endDate,
        'is_active' => true,]);
        
            return redirect()->route('admin.memberships.list')->with('success', 'Membership purchased successfully!');
    }
    
    

    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'price' => 'required|numeric|min:0',
            'duration_days' => 'required|integer|min:1',
            'discount_percentage' => 'required|numeric|min:0|max:100',
        ]);

        $plan = Membership::create($request->only('name', 'price', 'duration_days', 'discount_percentage','description'));

        // return Reply::success('Membership plan created successfully.');
        return Reply::successWithData('Membership plan created successfully.', [
        'redirectUrl' => route('admin.memberships.index')
    ]);
    }

    public function show($id)
    {
        $plan = Membership::findOrFail($id);
        return view('admin.membership.show', compact('plan'));
    }

    public function edit($id)
    {
        $plan = Membership::findOrFail($id);
        return view('admin.membership.edit', compact('plan'));
    }
    
        public function update(Request $request, $id)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'price' => 'required|numeric|min:0',
            'duration_days' => 'required|integer|min:1',
            'discount_percent' => 'required|numeric|min:0|max:100',
        ]);
    
        $plan = Membership::findOrFail($id);
        $plan->update($request->only('name', 'price', 'duration_days', 'discount_percent', 'description', 'status'));
    
        return Reply::successWithData(
            __('messages.updateSuccess'),
            ['redirect_url' => route('admin.memberships.index')]
        );
    }

    // public function update(Request $request, $id)
    // {
    //     $request->validate([
    //         'name' => 'required|string|max:255',
    //         'price' => 'required|numeric|min:0',
    //         'duration_days' => 'required|integer|min:1',
    //         'discount_percent' => 'required|numeric|min:0|max:100',
    //     ]);

    //     $plan = Membership::findOrFail($id);
    //     $plan->update($request->only('name', 'price', 'duration_days', 'discount_percent'));
        
    //     return Reply::successWithData('Membership plan updated successfull.', ['redirectUrl' => route('admin.memberships.index')]);
    // }

    public function destroy($id)
    {
        $plan = Membership::findOrFail($id);
        $plan->delete();

        return Reply::success('Membership plan deleted successfully.');
    }
}
