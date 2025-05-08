<?php

namespace App\Http\Controllers\Admin;

use App\ZoomSetting;
use App\Helper\Reply;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;

class ZoomSettingController extends Controller
{

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {
        $zoomSetting = ZoomSetting::findOrFail($id);
        $zoomSetting->api_key = $request->zoom_api_key;
        $zoomSetting->secret_key = $request->zoom_secret_key;
        $zoomSetting->meeting_app = $request->meeting_app;

        if($request->enable_zoom ?? false)
        {
            $zoomSetting->enable_zoom = $request->enable_zoom;
        }
        else
        {
            $zoomSetting->enable_zoom = 'inactive';
        }

        $zoomSetting->update();

        return Reply::success(__('messages.updatedSuccessfully'));
    }

}
