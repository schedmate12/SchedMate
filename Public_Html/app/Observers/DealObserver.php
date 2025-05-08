<?php

namespace App\Observers;

use App\Deal;
use Illuminate\Support\Facades\File;

class DealObserver
{

    public function updating(Deal $deal)
    {
        if($deal->isDirty('image') && !is_null($deal->getOriginal('image'))){
            $path = public_path('user-uploads/deal/'.$deal->getOriginal('image'));

            if($path){
                File::delete($path);
            }
        }
    }

    public function deleted(Deal $deal)
    {
        if(!is_null($deal->getOriginal('image')))
        {
            $path = public_path('user-uploads/deal/'.$deal->getOriginal('image'));

            if($path) {
                File::delete($path);
            }
        }

    }

}
