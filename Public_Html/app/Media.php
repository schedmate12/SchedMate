<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Media extends Model
{
    protected $appends = ['file_image_url'];

    public function getFileImageUrlAttribute()
    {
        if (is_null($this->file_name)) {
            return asset('img/no-image.jpg');
        }

        // Demo Data
        if ($this->file_name == 'slide-1.jpeg' || $this->file_name == 'slide-2.jpeg') {
            return asset('img/banner/' . $this->file_name);
        }

        if ($this->is_section_content == 'no') {
            return asset_url('carousel-images/' . $this->file_name);
        }
        else if ($this->is_section_content == null) {
            return asset_url('carousel-images/' . $this->file_name);
        }
    }

    public function getImageUrlAttribute()
    {
        if (empty($this->file_name)) {
            return asset('img/no-image.jpg');
        }

        if ($this->is_section_content == 'yes') {
            return asset_url('sliders/' . $this->file_name);
        }

    }

}
