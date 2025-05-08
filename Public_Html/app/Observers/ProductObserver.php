<?php

namespace App\Observers;

use App\Product;
use App\Helper\SearchLog;
use Illuminate\Support\Facades\File;

class ProductObserver
{

    /**
     * Handle the product "deleted" event.
     *
     * @param  \App\Product  $product
     * @return void
     */
    public function deleted(Product $product)
    {
        SearchLog::deleteSearchEntry($product->id, 'admin.products.edit');

        // delete images folder from user-uploads/product directory
        File::deleteDirectory(public_path('user-uploads/product/'.$product->id));
    }

    /**
     * Handle the product "restored" event.
     *
     * @param  \App\Product  $product
     * @return void
     */
    // @codingStandardsIgnoreLine
    public function restored(Product $product)
    {
        //
    }

    /**
     * Handle the product "force deleted" event.
     *
     * @param  \App\Product  $product
     * @return void
     */
    // @codingStandardsIgnoreLine
    public function forceDeleted(Product $product)
    {
        //
    }

}
