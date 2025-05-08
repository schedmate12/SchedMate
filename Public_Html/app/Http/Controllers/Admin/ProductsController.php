<?php

namespace App\Http\Controllers\Admin;

use App\Tax;
use App\ItemTax;
use App\Product;
use App\Location;
use App\Helper\Files;
use App\Helper\Reply;
use Illuminate\Support\Arr;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\File;
use App\Http\Requests\Product\StoreProduct;

class ProductsController extends Controller
{

    public function __construct()
    {
        parent::__construct();
        view()->share('pageTitle', __('menu.products'));
    }

    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        abort_if(!$this->user->roles()->withoutGlobalScopes()->first()->hasPermission('read_business_service'), 403);

        if(\request()->ajax()){
            $products = Product::all();

            return \datatables()->of($products)
                ->addColumn('action', function ($row) {
                    $action = '<div class="text-right">';

                    if ($this->user->roles()->withoutGlobalScopes()->first()->hasPermission('update_business_service')) {
                        $action .= '<a href="' . route('admin.products.edit', [$row->id]) . '" class="btn btn-primary btn-circle"
                          data-bs-toggle="tooltip" data-original-title="'.__('app.edit').'"><i class="fa fa-pencil" aria-hidden="true"></i></a>';
                    }

                    if ($this->user->roles()->withoutGlobalScopes()->first()->hasPermission('create_business_service')) {
                        $action .= ' <a href="javascript:;" class="btn btn-warning btn-circle duplicate-row"
                        data-bs-toggle="tooltip" data-row-id="' . $row->id . '" data-original-title="'.__('app.duplicate').'"><i class="fa fa-clone" aria-hidden="true"></i></a>';
                    }

                    $action .= ' <a href="javascript:;" data-row-id="' . $row->id . '" class="btn btn-info btn-circle view-product"
                    data-bs-toggle="tooltip" data-original-title="'.__('app.view').'"><i class="fa fa-eye" aria-hidden="true"></i></a> ';

                    if ($this->user->roles()->withoutGlobalScopes()->first()->hasPermission('delete_business_service')) {
                        $action .= ' <a href="javascript:;" class="btn btn-danger btn-circle delete-row"
                          data-bs-toggle="tooltip" data-row-id="' . $row->id . '" data-original-title="'.__('app.delete').'"><i class="fa fa-times" aria-hidden="true"></i></a>';
                    }

                    $action .= '</div>';
                    return $action;
                })
                ->addColumn('image', function ($row) {
                    return '<img src="'.$row->product_image_url.'" class="img" height="65em" width="65em" /> ';
                })
                ->editColumn('name', function ($row) {
                    return ucfirst($row->name);
                })
                ->editColumn('status', function ($row) {
                    if($row->status == 'active'){
                        return '<label class="badge bg-success">'.__('app.active').'</label>';
                    }
                    elseif($row->status == 'deactive'){
                        return '<label class="badge badge-danger">'.__('app.inactive').'</label>';
                    }
                })
                ->editColumn('location_id', function ($row) {
                    return ucfirst($row->location->name);
                })
                ->editColumn('price', function ($row) {
                    return currencyFormatter($row->price);
                })
                ->editColumn('discount_price', function ($row) {
                    return currencyFormatter($row->discounted_price);
                })
                ->addIndexColumn()
                ->rawColumns(['action', 'image', 'status'])
                ->toJson();
        }

        return view('admin.products.index');
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create(Request $request)
    {
        abort_if(!$this->user->roles()->withoutGlobalScopes()->first()->hasPermission('create_business_service'), 403);

        $locations = Location::orderBy('name', 'ASC')->get();
        $taxes = Tax::active()->get();

        $variables = compact('locations', 'taxes');

        if ($request->product_id) {
            $product = Product::where('id', $request->product_id)->first();
            $variables = Arr::add($variables, 'product', $product);
        }

        return view('admin.products.create', $variables);
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(StoreProduct $request)
    {
        abort_if(!$this->user->roles()->withoutGlobalScopes()->first()->hasPermission('create_business_service'), 403);

        $product = new product();
        $product->name = $request->name;
        $product->description = $request->description;
        $product->price = $request->price;
        $product->discount = $request->discount;
        $product->discount_type = $request->discount_type;
        $product->discount = $request->discount;
        $product->location_id = $request->location_id;
        $product->save();

        /* store taxes */
        $tax_ids = $request->tax_ids;

        if($tax_ids !== null)
        {
            foreach ($tax_ids as $tax_id)
            {
                $taxService = new ItemTax();
                $taxService->tax_id = $tax_id;
                $taxService->product_id = $product->id;
                $taxService->save();
            }
        }

        return Reply::dataOnly(['productID' => $product->id, 'defaultImage' => $request->default_image ?? 0]);

    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Product  $product
     * @return \Illuminate\Http\Response
     */
    public function show(Product $product)
    {
        $selectedTax = array();
        $taxServices = ItemTax::where('product_id', $product->id)->get();

        foreach ($taxServices as $key => $taxService)
        {
            array_push($selectedTax, $taxService->tax_id);
        }

        $taxes = Tax::active()->get();

        return view('admin.products.show', compact('taxes', 'selectedTax', 'product'));
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  \App\Product  $product
     * @return \Illuminate\Http\Response
     */
    public function edit(Product $product)
    {
        abort_if(!$this->user->roles()->withoutGlobalScopes()->first()->hasPermission('update_business_service'), 403);

        $locations = Location::orderBy('name', 'ASC')->get();

        $images = [];

        if ($product->image) {
            foreach ($product->image as $image)
            {
                if(File::exists('user-uploads/product/'.$product->id.'/'.$image) == true )
                {
                    $reqImage['name'] = $image;
                    $reqImage['size'] = filesize(public_path('/user-uploads/product/'.$product->id.'/'.$image));
                    $reqImage['type'] = pathinfo(public_path('/user-uploads/product/'.$product->id.'/'.$image), PATHINFO_EXTENSION);
                    $images[] = $reqImage;
                }
            }
        }

        $images = json_encode($images);

        /* push all previous assigned services to an array */
        $selectedUsers = array();

        $selectedTax = array();
        $taxServices = ItemTax::where('product_id', $product->id)->get();

        foreach ($taxServices as $key => $taxService)
        {
            array_push($selectedTax, $taxService->tax_id);
        }

        $taxes = Tax::active()->get();

        return view('admin.products.edit', compact('taxes', 'selectedTax', 'product', 'locations', 'images'));
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\Product  $product
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {
        abort_if(!$this->user->roles()->withoutGlobalScopes()->first()->hasPermission('update_business_service'), 403);

        $product = Product::find($id);
        $product->name = $request->name;
        $product->description = $request->description;
        $product->price = $request->price;
        $product->discount = $request->discount;
        $product->discount_type = $request->discount_type;
        $product->location_id = $request->location_id;
        $product->status = $request->status;
        $product->default_image = $request->default_image;
        $product->save();

        /* delete existing taxes */
        $productTaxes = ItemTax::where('product_id', $id)->get();

        foreach ($productTaxes as $productTax)
        {
            ItemTax::destroy($productTax->id);
        }

        /* update taxes */
        $tax_ids = $request->tax_ids;

        if($tax_ids !== null)
        {
            foreach ($tax_ids as $tax_id)
            {
                $taxService = new ItemTax();
                $taxService->tax_id = $tax_id;
                $taxService->product_id = $product->id;
                $taxService->save();
            }
        }

        return Reply::dataOnly(['productID' => $product->id, 'defaultImage' => $request->default_image ?? 0]);
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Product  $product
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        abort_if(!$this->user->roles()->withoutGlobalScopes()->first()->hasPermission('delete_business_service'), 403);

        Product::destroy($id);
        return Reply::success(__('messages.recordDeleted'));
    }

    public function storeImages(Request $request)
    {
        if ($request->hasFile('file')) {
            $product = Product::where('id', $request->product_id)->first();
            $product_images_arr = [];
            $default_image_index = 0;

            foreach ($request->file as $fileData) {
                array_push($product_images_arr, Files::upload($fileData, 'product/'.$product->id));

                if ($fileData->getClientOriginalName() == $request->default_image) {
                    $default_image_index = array_key_last($product_images_arr);
                }
            }

            $product->image = json_encode($product_images_arr);
            $product->default_image = count($product_images_arr) > 0 ? $product_images_arr[$default_image_index] : null;
            $product->save();
        }

        return Reply::redirect(route('admin.products.index'), __('messages.createdSuccessfully'));
    }

    public function updateImages(Request $request)
    {
        $product = Product::where('id', $request->product_id)->first();

        $product_images_arr = [];
        $default_image_index = 0;

        if ($request->hasFile('file')) {
            if ($request->file[0]->getClientOriginalName() !== 'blob') {
                foreach ($request->file as $fileData) {
                    array_push($product_images_arr, Files::upload($fileData, 'product/'.$product->id));

                    if ($fileData->getClientOriginalName() == $request->default_image) {
                        $default_image_index = array_key_last($product_images_arr);
                    }
                }
            }

            if ($request->uploaded_files) {
                $files = json_decode($request->uploaded_files, true);

                foreach ($files as $file) {
                    array_push($product_images_arr, $file['name']);

                    if ($file['name'] == $request->default_image) {
                        $default_image_index = array_key_last($product_images_arr);
                    }
                }

                $arr_diff = array_diff($product->image, $product_images_arr);

                if (count($arr_diff) > 0) {

                    foreach ($arr_diff as $file) {
                        Files::deleteFile($file, 'service/'.$product->id);
                    }
                }
            }
            else {

                if (!is_null($product->image) && count($product->image) > 0) {
                    Files::deleteFile($product->image[0], 'service/'.$product->id);
                }
            }
        }

        $product->image = json_encode(array_values($product_images_arr));
        $product->default_image = count($product_images_arr) > 0 ? $product_images_arr[$default_image_index] : null;
        $product->save();

        return Reply::redirect(route('admin.products.index'), __('messages.updatedSuccessfully'));
    }

    public function deleteImage(Request $request)
    {
        $product = Product::where('id', $request->productId)->first();

        $photo = Product::find($request->productId);
        $img = $photo->image;

        if (($key = array_search($request->file, $img)) !== false) {

            array_splice($img, $key, 1);
            $default_image_index = array_search($request->default_image, $img);
            $product->default_image = !empty($img) ? ($default_image_index !== false ? $img[$default_image_index] : $img[0]) : null;
            $product->image = !empty($img) ? json_encode($img) : null;

        }

        $product->save();

        return Reply::success(__('File Removed Successfully'));
    }

}
