<?php

namespace App\Observers;

use App\User;

class EmployeeObserver
{

    /**
     * Handle the user "created" event.
     *
     * @param  \App\User  $user
     * @return void
     */
    // @codingStandardsIgnoreLine
    public function created(User $user)
    {
        //
    }

    /**
     * Handle the user "updated" event.
     *
     * @param  \App\User  $user
     * @return void
     */
    // @codingStandardsIgnoreLine
    public function updated(User $user)
    {
        //
    }

    /**
     * Handle the user "deleted" event.
     *
     * @param  \App\User  $user
     * @return void
     */
    // @codingStandardsIgnoreLine
    public function deleted(User $user)
    {
        //
    }

    /**
     * Handle the user "restored" event.
     *
     * @param  \App\User  $user
     * @return void
     */
    // @codingStandardsIgnoreLine
    public function restored(User $user)
    {
        //
    }

    /**
     * Handle the user "force deleted" event.
     *
     * @param  \App\User  $user
     * @return void
     */
    // @codingStandardsIgnoreLine
    public function forceDeleted(User $user)
    {
        //
    }

}
