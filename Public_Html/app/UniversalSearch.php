<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class UniversalSearch extends Model
{
    protected $fillable = ['searchable_id', 'searchable_type', 'title'];
}
