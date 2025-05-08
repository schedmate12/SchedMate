<?php
namespace App\Http\Controllers\Admin;

use App\Tax;
use App\Helper\Reply;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Http\Requests\Tax\StoreTax;

class TaxSettingController extends Controller
{

    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        if (request()->ajax()) {

            $tax = Tax::all();

            return \datatables()->of($tax)
                ->addColumn('action', function ($row) {
                    $action = '';
                    $action .= '<a href="javascript:;" class="btn btn-primary btn-circle edit-tax" id="editTax" data-row-id="' . $row->id . '"
                        data-bs-toggle="tooltip" data-original-title="'.__('app.edit').'"><i class="fa fa-pencil" aria-hidden="true"></i></a>';

                    $action .= ' <a href="javascript:;" class="btn btn-danger btn-circle delete-tax" data-bs-placement="top"
                        data-bs-toggle="tooltip" data-row-id="' . $row->id . '" data-original-title="'.__('app.delete').'"><i class="fa fa-times" aria-hidden="true"></i></a>';

                    return $action;
                })
                ->editColumn('name', function ($row) {
                    return ucfirst($row->tax_name);
                })
                ->editColumn('percent', function ($row) {
                    return $row->percent;
                })
                ->editColumn('status', function ($row) {
                    if($row->status == 'active'){
                        return '<label class="badge bg-success">'.__('app.active').'</label>';
                    }
                    else{
                        return '<label class="badge badge-danger">'.__('app.inactive').'</label>';
                    }
                })
                ->addIndexColumn()
                ->rawColumns(['action', 'status'])
                ->toJson();
        }

        return view('admin.tax-setting.index');
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        //
        return view('admin.tax-setting.create');
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $tax = new Tax();
        $tax->tax_name = $request->tax_name;
        $tax->percent = $request->percent;
        $tax->status = $request->status;
        $tax->save();
        return Reply::success(__('messages.createdSuccessfully'));
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
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
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit($id)
    {
        //
        $this->tax = Tax::find($id);
        return view('admin.tax-setting.edit', $this->data);
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(StoreTax $request, $id)
    {
        $tax = Tax::find($id);
        $tax->tax_name = $request->tax_name;
        $tax->percent = $request->percent;
        $tax->status = $request->status;
        $tax->save();

        return Reply::redirect(route('admin.settings.index') . '#tax', __('messages.updatedSuccessfully'));
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        Tax::destroy($id);
        return Reply::success(__('messages.recordDeleted'));
    }

}
