<?php

namespace App\Observers;

use App\Role;
use App\Module;
use App\Permission;

class ModuleObserver
{

    public function created(Module $module)
    {
        $config = config('laratrust_seeder.role_structure');
        $userPermission = config('laratrust_seeder.permission_structure');
        $mapPermission = collect(config('laratrust_seeder.permissions_map'));

        foreach ($config as $role => $modules) {
            $permissions = [];

            // Reading role permission modules
            $value = array_filter($modules, function ($mod) use ($module) {
                return $mod === $module->name;
            }, ARRAY_FILTER_USE_KEY);

            if (count($value) > 0) {
                // create permissions
                foreach (explode(',', $value[$module->name]['permissions']) as $p => $perm) {

                    $permissionValue = $mapPermission->get($perm);

                    $permission = Permission::where('name', $permissionValue . '_' . $module->name)->get();

                    if($permission->count() == 0)
                    {

                        $permissions[] = Permission::firstOrCreate([
                            'name' => strtolower($permissionValue . '_' . $module->name),
                            'display_name' => ucfirst($permissionValue) . ' ' . ucwords(str_replace('_', ' ', $module->name)),
                            'description' => ucfirst($permissionValue) . ' ' . ucwords(str_replace('_', ' ', $module->name)),
                            'module_id' => $module->id
                        ])->id;

                    }

                    if($permission->count() > 0) {
                        foreach ($permission as $per) {
                            $permissions[] = $per->id;
                        }
                    }

                }

                // Attach permissions to role
                $roleObj = Role::where('name', $role)->withoutGlobalScopes()->first();
                $roleObj->permissions()->syncWithoutDetaching(array_unique($permissions));
            }
        }
    }

}
