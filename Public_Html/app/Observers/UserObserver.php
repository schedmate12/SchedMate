<?php

namespace App\Observers;

use App\User;
use App\Helper\SearchLog;
use Illuminate\Support\Facades\File;

class UserObserver
{

    // @codingStandardsIgnoreLine
    public function roleAttached(User $user, $role, $team)
    {
        if (!$user->is_admin) {
            $type = 'Employee';
            $route = 'admin.employee.edit';

            if ($user->is_customer) {
                $type = 'Customer';
                $route = 'admin.customers.show';
            }

            SearchLog::createSearchEntry($user->id, $type, $user->name, $route);
            SearchLog::createSearchEntry($user->id, $type, $user->email, $route);
        }
    }

    public function updating(User $user)
    {
        if (!$user->is_admin) {
            $type = 'Employee';
            $route = 'admin.employee.edit';

            if ($user->is_customer) {
                $type = 'Customer';
                $route = 'admin.customers.show';
            }

            if ($user->isDirty('name')) {
                $original = $user->getOriginal('name');
                SearchLog::updateSearchEntry($user->id, $type, $user->name, $route, ['name' => $original]);
            }

            if ($user->isDirty('email')) {
                $original = $user->getOriginal('email');
                SearchLog::updateSearchEntry($user->id, $type, $user->email, $route, ['email' => $original]);
            }

            if ($user->isDirty('image')) {
                if(!is_null($user->getOriginal('image'))){
                    $path = public_path('user-uploads/avatar/'.$user->getOriginal('image'));

                    if($path){
                        File::delete($path);
                    }
                }
            }
        }
    }

    public function deleted(User $user)
    {
        if(!is_null($user->getOriginal('image')))
        {
            $path = public_path('user-uploads/avatar/'.$user->getOriginal('image'));

            if($path){
                File::delete($path);
            }
        }

        if (!$user->is_admin) {
            $route = 'admin.employee.edit';

            if ($user->is_customer) {
                $route = 'admin.customers.show';
            }

            SearchLog::deleteSearchEntry($user->id, $route);
        }
    }

}
