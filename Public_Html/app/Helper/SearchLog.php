<?php

namespace App\Helper;

use App\UniversalSearch;
use Illuminate\Support\Arr;

class SearchLog
{

    public static function createSearchEntry($searchableId, $type, $title, $route)
    {
        $search = new UniversalSearch();

        $search->searchable_id = $searchableId;
        $search->searchable_type = $type;
        $search->title = $title;
        $search->route_name = $route;

        $search->save();
    }

    public static function updateSearchEntry($searchableId, $type, $title, $route, $data = null)
    {

        $where = ['searchable_id' => $searchableId, 'route_name' => $route];

        if ($data && !Arr::has($data, 'modified')) {
            $where['title'] = current($data);
        }
        
        $search = UniversalSearch::firstOrCreate($where);

        $search->searchable_id = $searchableId;
        $search->searchable_type = $type;
        $search->title = $title;
        $search->route_name = $route;

        if ($data && Arr::has($data, ['modified'])) {
            $value = $data['modified'];

            $search->searchable_id = $value['searchable_id'];
            $search->title = $value['title'];
        }

        $search->save();
    }

    public static function deleteSearchEntry($searchableId, $route)
    {
        $searches = UniversalSearch::where(['searchable_id' => $searchableId, 'route_name' => $route])->get();

        foreach ($searches as $search) {
            $search->delete();
        }
    }

}
