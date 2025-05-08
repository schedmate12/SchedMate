<?php

namespace App\Observers;

use App\CompanySetting;

class CompanySettingObserver
{

    public function updated(CompanySetting $companySetting)
    {
        cache(['global_setting' => $companySetting], 60 * 60 * 24);
    }

}
