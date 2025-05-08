<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\UserMembership; 
use App\Membership;
use App\User;
use App\Helper\Reply;
use Carbon\Carbon;

class UserMembershipController extends Controller
{
    public function index()
    {
        $memberships = UserMembership::with(['user', 'plan'])->latest()->get();
        return view('admin.user-memberships.index', compact('memberships'));
    }

    public function store(Request $request)
    {
        $request->validate([
            'user_id' => 'required|exists:users,id',
            'membership_plan_id' => 'required|exists:membership_plans,id',
        ]);

        $plan = MembershipPlan::findOrFail($request->membership_plan_id);
        $startsAt = Carbon::now();
        $endsAt = $startsAt->copy()->addDays($plan->duration_days);

        UserMembership::create([
            'user_id' => $request->user_id,
            'membership_plan_id' => $plan->id,
            'starts_at' => $startsAt,
            'ends_at' => $endsAt,
        ]);

        return Reply::success('User membership assigned.');
    }

    public function destroy($id)
    {
        $membership = UserMembership::findOrFail($id);
        $membership->delete();

        return Reply::success('User membership deleted.');
    }
}
