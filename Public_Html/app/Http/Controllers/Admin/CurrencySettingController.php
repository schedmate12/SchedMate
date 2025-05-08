<?php

namespace App\Http\Controllers\Admin;

use App\Currency;
use App\Helper\Reply;
use Illuminate\Http\Request;
use App\CurrencyFormatSetting;
use App\Http\Controllers\Controller;
use App\Http\Requests\Currency\StoreCurrency;

class CurrencySettingController extends Controller
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
        return view('admin.currency.create');
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store()
    {
        Currency::create(\request()->all());

        return Reply::redirect(route('admin.settings.index') . '#currency', __('messages.createdSuccessfully'));
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
    public function edit($id)
    {
        $currency = Currency::find($id);
        return view('admin.currency.edit', compact('currency'));
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(StoreCurrency $request, $id)
    {
        $currency = Currency::find($id);
        $currency->currency_name = $request->currency_name;
        $currency->currency_code = $request->currency_code;
        $currency->currency_symbol = $request->currency_symbol;
        $currency->save();

        return Reply::redirect(route('admin.settings.index'), __('messages.updatedSuccessfully'));
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        Currency::destroy($id);

        return Reply::success(__('messages.recordDeleted'));
    }

    public function updateCurrencyFormat(Request $request,$id)
    {
        $currency = CurrencyFormatSetting::find($id);
        $currency->currency_position = $request->currency_position;
        $currency->no_of_decimal = $request->no_of_decimal;
        $currency->thousand_separator = $request->thousand_separator;
        $currency->decimal_separator = $request->decimal_separator;
        $currency->update();
        cache()->forget('currency_format_setting');
        return Reply::success( __('messages.updatedSuccessfully'));
    }

}
