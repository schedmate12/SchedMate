<?php

namespace App\Observers;

use App\Category;
use App\Helper\SearchLog;
use Illuminate\Support\Facades\File;

class CategoryObserver
{

    public function created(Category $category)
    {
        SearchLog::createSearchEntry($category->id, 'Category', $category->name, 'admin.categories.edit');
    }

    public function updating(Category $category)
    {
        if($category->isDirty('image') && !is_null($category->getOriginal('image'))){
            $path = public_path('user-uploads/category/'.$category->getOriginal('image'));

            if($path){
                File::delete($path);
            }
        }

        SearchLog::updateSearchEntry($category->id, 'Category', $category->name, 'admin.categories.edit');
    }

    public function deleted(Category $category)
    {
        if(!is_null($category->getOriginal('image')))
        {
            $path = public_path('user-uploads/category/'.$category->getOriginal('image'));

            if($path) {
                File::delete($path);
            }
        }
        
        SearchLog::deleteSearchEntry($category->id, 'admin.categories.edit');
    }

}
