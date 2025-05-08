<?php

namespace App;

use App\Observers\UserObserver;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Notifications\Notifiable;
use Laratrust\Traits\LaratrustUserTrait;
use Illuminate\Foundation\Auth\User as Authenticatable;

class User extends Authenticatable
{

    /* Traits */

    use LaratrustUserTrait;
    use Notifiable;
    use HasFactory;

    /* Attributes */

    protected static function boot()
    {
        parent::boot();
        static::observe(UserObserver::class);
        static::laratrustObserve(UserObserver::class);

    }

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'name', 'email', 'password',
    ];

    /**
     * The attributes that should be hidden for arrays.
     *
     * @var array
     */
    protected $hidden = [
        'password', 'remember_token',
    ];

    protected $appends = [
        'user_image_url', 'mobile_with_code', 'formatted_mobile'
    ];

    /**
     * The attributes that should be mutated to dates.
     *
     * @var array
     */
    protected $dates = ['deleted_at'];

    /* Relations */

    public function employeeGroup()
    {
        return $this->belongsTo(EmployeeGroup::class, 'group_id');
    }

    public function feedback()
    {
        return $this->belongsTo(CustomerFeedback::class);
    }

    public function address()
    {
        return $this->hasOne(Address::class);
    }

    public function todoItems()
    {
        return $this->hasMany(TodoItem::class);
    }

    public function completedBookings()
    {
        return $this->hasMany(Booking::class, 'user_id')->where('bookings.status', 'completed');
    }

    public function customerBookings()
    {
        return $this->hasMany(Booking::class);
    }

    public function booking()
    {
        return $this->belongsToMany(Booking::class);
    }

    public function services()
    {
        return $this->belongsToMany(BusinessService::class);
    }

    public function leave()
    {
        return $this->hasMany('App\Leave', 'employee_id', 'id');
    }

    public function role()
    {
        return $this->belongsToMany(Role::class);
    }

    public function employeeSchedule()
    {
        return $this->hasMany('App\EmployeeSchedules', 'employee_id', 'id');
    }

    /* Scopes */

    public function scopeAllAdministrators()
    {
        return $this->whereHas('roles', function ($query) {
            $query->where('name', 'administrator');
        });
    }

    public function scopeAllCustomers()
    {
        return $this->whereHas('roles', function ($query) {
            $query->where('name', 'customer')->withoutGlobalScopes();
        });
    }

    public function scopeOtherThanCustomers()
    {
        return $this->whereHas('roles', function ($query) {
            $query->where('name', '<>', 'customer');
        });
    }

    public function scopeAllEmployees()
    {
        return $this->whereHas('roles', function ($query) {
            $query->where('name', 'employee');
        });
    }

    public function location()
    {
        return $this->belongsToMany(Location::class, 'location_user');
    }

    /* Accessors */

    public function getUserImageUrlAttribute()
    {
        if (is_null($this->image)) {
            return asset('img/default-avatar-user.png');
        }

        return asset_url('avatar/' . $this->image);
    }

    public function getRoleAttribute()
    {
        return $this->roles->first();
    }

    public function getMobileWithCodeAttribute()
    {
        return substr($this->calling_code, 1).$this->mobile;
    }

    public function getFormattedMobileAttribute()
    {
        if (!$this->calling_code) {
            return $this->mobile;
        }

        return $this->mobile;
    }

    // @codingStandardsIgnoreLine
    public function routeNotificationForVonage($notification)
    {
        return $this->mobile_with_code;
    }

    // @codingStandardsIgnoreLine
    public function routeNotificationForMsg91($notification)
    {
        return $this->mobile_with_code;
    }

    public function getIsAdminAttribute()
    {
        return $this->hasRole('administrator');
    }

    public function getIsEmployeeAttribute()
    {
        return $this->hasRole('employee');
    }

    public function getIsCustomerAttribute()
    {
        if ($this->roles()->withoutGlobalScopes()->where('roles.name', 'customer')->count() > 0) {
            return true;
        }

        return false;
    }

    /* Mutators */

    public function setPasswordAttribute($value)
    {
        $this->attributes['password'] = bcrypt($value);
    }
    
        public function activeMembership()
    {
        return $this->hasOne(UserMembership::class)
            ->where('is_active', true)
            ->whereDate('start_date', '<=', now())
            ->whereDate('end_date', '>=', now());
    }


    /* Formats */

    public function userBookingCount($date)
    {
        return Booking::whereNull('deal_id')->where('user_id', $this->id)->whereDate('created_at', $date)->get()->count();
    }

} /* end of class */
