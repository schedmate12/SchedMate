<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class EmployeeGroupService extends Model
{
    /* Attributes */

    protected $guarded = ['id'];
    protected $table = 'employee_group_services';

    /* Relations */

    public function service()
    {
        return $this->belongsTo(BusinessService::class, 'business_service_id', 'id', 'business_services');
    }

}
