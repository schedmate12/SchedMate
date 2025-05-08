<?php

namespace App\Http\Controllers\Admin;

use App\AdvertisementBanner;
use App\Helper\Files;
use App\Helper\Reply;
use App\Http\Controllers\Controller;
use App\Http\Requests\AdvertisementBanner\StoreAdvertisement;
use App\Http\Requests\AdvertisementBanner\UpdateAdvertisement;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Request as FacadesRequest;

class AdvertisementController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */

    public function __construct()
    {
        parent::__construct();
        view()->share('pageTitle', __('menu.advertisement'));

    }

    public function index(Request $request)
    {
        abort_if(!$this->user->roles()->withoutGlobalScopes()->first()->hasPermission('read_advertisement_banner'), 403);

        if($request->ajax())
        {
            $advertisement = AdvertisementBanner::get();
            return datatables()->of($advertisement)
                ->addColumn('action', function ($row) {
                    $action = '<div class="text-right">';

                    if($this->user->isAbleTo('update_advertisement_banner')) {
                        $action .= '<a href="' . route('admin.advertisements.edit', [$row->id]) . '" class="btn btn-primary btn-circle"
                        data-bs-toggle="tooltip" data-original-title="'.__('app.edit').'"><i class="fa fa-pencil" aria-hidden="true"></i></a>';
                    }

                    $action .= ' <a href="javascript:;" data-row-id="' . $row->id . '" class="btn btn-info btn-circle view-advertisement"
                    data-bs-toggle="tooltip" data-original-title="'.__('app.view').'"><i class="fa fa-eye" aria-hidden="true"></i></a> ';

                    if($this->user->isAbleTo('delete_advertisement_banner')) {
                        $action .= ' <a href="javascript:;" class="btn btn-danger btn-circle delete-row"
                        data-bs-toggle="tooltip" onclick="this.blur()" data-row-id="' . $row->id . '" data-original-title="'.__('app.delete').'"><i class="fa fa-times" aria-hidden="true"></i></a>';
                    }

                    $action .= '</div>';
                    return $action;
                })
                ->addColumn('image', function ($row) {
                    return '<img src="'.$row->advertisement_image_url.'" class="img" height="65em" width="65em"/> ';
                })
                ->editColumn('position', function ($row) {
                    return ucfirst($row->position);
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
                ->addIndexColumn()
                ->rawColumns(['action', 'image', 'status'])
                ->make(true);
        }

        return view('admin.advertisement.index');
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */

    public function create()
    {
        abort_if(!$this->user->roles()->withoutGlobalScopes()->first()->hasPermission('create_advertisement_banner'), 403);

        return view('admin.advertisement.create');
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */

    public function store(StoreAdvertisement $request)
    {
        abort_if(!$this->user->roles()->withoutGlobalScopes()->first()->hasPermission('create_advertisement_banner'), 403);

        $advertisement = new AdvertisementBanner();
        $advertisement->start_date_time = $request->advertisement_startDate;
        $advertisement->end_date_time   = $request->advertisement_endDate;
        $advertisement->position        = $request->position;
        $advertisement->status          = $request->status;

        if ($request->hasFile('image')) {
            $advertisement->image = Files::upload($request->image, 'advertisementBanner');
        }

        $advertisement->save();

        if (!$request->redirect_url) {
            $advertisements = AdvertisementBanner::all();
            $options = $this->options($advertisements, $advertisement);
        }

        return $request->redirect_url ? Reply::redirect($request->redirect_url, __('messages.createdSuccessfully')) : Reply::successWithData(__('messages.createdSuccessfully'), ['data' => $options]);
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */

    public function show($id)
    {
        $advertisement = AdvertisementBanner::find($id);

        return view('admin.advertisement.show', compact('advertisement'));
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */

    public function edit($id)
    {
        abort_if(!$this->user->roles()->withoutGlobalScopes()->first()->hasPermission('update_advertisement_banner'), 403);

        $advertisement = AdvertisementBanner::find($id);
        return view('admin.advertisement.edit', compact('advertisement'));
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */

    public function update(UpdateAdvertisement $request, $id)
    {
        abort_if(!$this->user->roles()->withoutGlobalScopes()->first()->hasPermission('update_advertisement_banner'), 403);

        $advertisement = AdvertisementBanner::find($id);
        $advertisement->start_date_time         = $request->advertisement_startDate;
        $advertisement->end_date_time           = $request->advertisement_endDate;
        $advertisement->position = $request->position;
        $advertisement->status = $request->status;

        if ($request->hasFile('image')) {
            $advertisement->image = Files::upload($request->image, 'advertisementBanner');
        }

        $advertisement->save();
        return Reply::redirect(route('admin.advertisements.index'), __('messages.updatedSuccessfully'));
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */

    public function destroy($id)
    {
        abort_if(!$this->user->roles()->withoutGlobalScopes()->first()->hasPermission('delete_advertisement_banner'), 403);

        $advertisement = AdvertisementBanner::findOrFail($id);
        $advertisement->delete();
        return Reply::success(__('messages.recordDeleted'));
    }

}
