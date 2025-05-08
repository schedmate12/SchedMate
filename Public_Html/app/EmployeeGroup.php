<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class EmployeeGroup extends Model
{
    /* Attributes */
    protected $guarded = ['id'];
    protected $table = 'employee_groups';


    /* Relations */

    public function services()
    {
        return $this->hasMany(EmployeeGroupService::class, 'employee_groups_id', 'id', 'employee_group_services');
    }

    public function businessServices()
    {
        return $this->belongsToMany(BusinessService::class, 'employee_group_services', 'employee_groups_id', 'business_service_id');
    }

} /* end of class */
