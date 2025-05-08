<?php

namespace App\Observers;

use App\AdvertisementBanner;
use Illuminate\Support\Facades\File;

class AdvertisementBannerObserver
{

    public function updating(AdvertisementBanner $advertisement)
    {
        if($advertisement->isDirty('image') && !is_null($advertisement->getOriginal('image'))){
            $path = public_path('user-uploads/advertisementBanner/'.$advertisement->getOriginal('image'));

            if($path){
                File::delete($path);
            }
        }
    }

    public function deleted(AdvertisementBanner $advertisement)
    {
        if(!is_null($advertisement->getOriginal('image')))
        {
            $path = public_path('user-uploads/advertisementBanner/'.$advertisement->getOriginal('image'));

            if($path) {
                File::delete($path);
            }
        }

    }

}
