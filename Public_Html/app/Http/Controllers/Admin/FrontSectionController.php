<?php

namespace App\Http\Controllers\Admin;

use App\Media;
use App\Helper\Reply;
use App\Helper\Files;
use Illuminate\Support\Facades\File;
use App\Http\Controllers\Controller;
use App\Http\Requests\Front\SectionContentRequest;

class FrontSectionController extends Controller
{

    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        if (request()->ajax()) {

            $media = Media::where('is_section_content', 'yes')->get();

            return DataTables()->of($media)
                ->addColumn('action', function ($row) {
                    $action = '';
                    $action .= '<a href="javascript:;" class="btn btn-info btn-circle view-section"
                    data-bs-toggle="tooltip" data-section-id="' . $row->id . '" data-original-title="' . __('app.view') . '"><i class="fa fa-eye" aria-hidden="true"></i></a>';

                    $action .= ' <a href="javascript:;" data-id="' . $row->id . '" class="btn btn-primary btn-circle edit-section"
                    data-bs-toggle="tooltip" data-original-title="' . __('app.edit') . '"><i class="fa fa-pencil" aria-hidden="true"></i></a>';

                    $action .= ' <a href="javascript:;" class="btn btn-danger btn-circle delete-section"
                        data-bs-toggle="tooltip" data-row-id="' . $row->id . '" data-original-title="' . __('app.delete') . '"><i class="fa fa-times" aria-hidden="true"></i></a>';
                    return $action;
                })
                ->editColumn('image', function ($row) {
                    return ' <img src="' . $row->image_url . '" border=""
                    width="100" height="100" class="img-thumbnail" align="center" alt=""/>';
                })
                ->editColumn('have_content', function ($row) {
                    return ucfirst($row->have_content);
                })
                ->editColumn('title', function ($row) {
                    return ucfirst($row->section_title);
                })
                ->addIndexColumn()
                ->rawColumns(['image', 'action'])
                ->toJson();
        }

        return view('admin.front-section.index');
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        return view('admin.front-section.create');
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(SectionContentRequest $request)
    {
        $media = new Media();

        if ($request->hasFile('image')) {
            $media->file_name = Files::upload($request->image, 'sliders');
        }

        $media->have_content = 'yes';
        $media->is_section_content = 'yes';
        $media->title_note = $request->title_note;
        $media->section_title = $request->section_title;
        $media->section_content = $request->section_content;
        $media->content_alignment = $request->content_alignment;

        $media->save();

        return Reply::success(__('messages.createdSuccessfully'));
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        $section_details = Media::where('id', $id)->first();
        return view('admin.front-section.show', compact('section_details'));
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit($id)
    {
        $sectionContent = Media::where('id', $id)->firstOrFail();
        return view('admin.front-section.edit', compact('sectionContent'));
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(SectionContentRequest $request, $id)
    {
        $media = Media::findOrFail($id);

        if ($request->hasFile('image')) {
            $media->file_name = Files::upload($request->image, 'sliders');
        }

        if ($request->image_delete == 'yes') {
            Files::deleteFile($media->image, 'sliders');
            $media->file_name = null;
        }

        $media->have_content = 'yes';
        $media->is_section_content = 'yes';
        $media->title_note = $request->title_note;
        $media->section_title = $request->section_title;
        $media->section_content = $request->section_content;
        $media->content_alignment = $request->content_alignment;

        $media->save();

        return Reply::success(__('messages.updatedSuccessfully'));
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        $media = Media::findOrFail($id);

        if (!is_null($media->file_name)) {
            $path = public_path('user-uploads/sliders/' . $media->file_name);

            if ($path) { File::delete($path);
            }
        }

        Media::destroy($id);

        return Reply::success(__('messages.recordDeleted'));
    }

}
