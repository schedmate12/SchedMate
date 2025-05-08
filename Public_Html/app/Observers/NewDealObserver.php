<?php

namespace App\Observers;

use App\NewDeal;
use Illuminate\Support\Facades\File;

class NewDealObserver
{

    public function updating(NewDeal $newDeal)
    {
        if($newDeal->isDirty('image') && !is_null($newDeal->getOriginal('image'))){
            $path = public_path('user-uploads/newDeal/'.$newDeal->getOriginal('image'));

            if($path){
                File::delete($path);
            }
        }
    }

    public function deleted(NewDeal $newDeal)
    {
        if(!is_null($newDeal->getOriginal('image')))
        {
            $path = public_path('user-uploads/newDeal/'.$newDeal->getOriginal('image'));

            if($path) {
                File::delete($path);
            }
        }
    }

}
