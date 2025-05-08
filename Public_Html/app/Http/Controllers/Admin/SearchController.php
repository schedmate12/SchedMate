<?php

namespace App\Http\Controllers\Admin;

use App\UniversalSearch;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;

class SearchController extends Controller
{

    public function __construct()
    {
        parent::__construct();
        view()->share('pageTitle', __('front.search'));
    }

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
        //
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $key = $request->search_key;

        if(trim($key) == ''){
            return redirect()->back();
        }

        return redirect(route('admin.search.show', $key));
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($key)
    {
        $searchResults = UniversalSearch::where('title', 'like', '%'.$key.'%')->get();
        $searchKey = $key;
        session()->put('searchKey', $searchKey);
        return view('admin.search.show', compact('searchResults', 'searchKey'));
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    // @codingStandardsIgnoreLine
    public function edit($id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    // @codingStandardsIgnoreLine
    public function update(Request $request, $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    // @codingStandardsIgnoreLine
    public function destroy($id)
    {
        //
    }

}
