<?php

namespace App\Http\Controllers\Admin;

use App\Helper\Reply;
use App\FooterSetting;
use App\CompanySetting;
use Illuminate\Support\Arr;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Http\Requests\Front\GetStartedRequest;

class FrontSettingController extends Controller
{

    public function __construct()
    {
        parent::__construct();
        view()->share('pageTitle', __('menu.settings'));

    }

    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        abort_if(!$this->user->roles()->withoutGlobalScopes()->first()->hasPermission('manage_settings'), 403);

        $this->footerSetting = FooterSetting::first();
        $this->getStartedData = CompanySetting::firstOrFail();
        return view('admin.front-settings.index', $this->data);
    }

    public function getStarted()
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
    public function edit()
    {
        abort_if(!$this->user->roles()->withoutGlobalScopes()->first()->hasPermission('manage_settings'), 403);

        $getStartedData = CompanySetting::firstOrFail();
        return view('admin.front-settings.get_started', compact('getStartedData'));
    }

    public function getStartedNote(GetStartedRequest $request, $id)
    {
        $getStarted = CompanySetting::findOrFail($id);
        $getStarted->get_started_title = $request->get_started_title;
        $getStarted->get_started_note = $request->get_started_note;
        $getStarted->save();

        return Reply::success(__('messages.updatedSuccessfully'));
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
        $setting = FooterSetting::findOrFail($id);

        $links = [];

        foreach ($request->social_links as $name => $value) {
            $link_details = [];
            $link_details = Arr::add($link_details, 'name', $name);
            $link_details = Arr::add($link_details, 'link', $value);
            array_push($links, $link_details);
        }

        $setting->social_links = $links;
        $setting->footer_text = $request->footer_text;

        $setting->save();

        return Reply::success(__('messages.updatedSuccessfully'));
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

}
