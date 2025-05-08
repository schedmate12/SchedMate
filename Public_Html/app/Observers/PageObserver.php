<?php

namespace App\Observers;

use App\Page;
use App\Helper\SearchLog;

class PageObserver
{

    public function created(Page $page)
    {
        SearchLog::createSearchEntry($page->slug, 'Page', $page->title, 'admin.pages.edit');

    }

    public function updating(Page $page)
    {
        if ($page->isDirty('slug') || $page->isDirty('title')) {
            SearchLog::updateSearchEntry($page->getOriginal('slug'), 'Page', $page->getOriginal('title'), 'admin.pages.edit', ['modified' => ['searchable_id' => $page->slug, 'title' => $page->title]]);
        }
    }

    public function deleted(Page $page)
    {
        SearchLog::deleteSearchEntry($page->slug, 'admin.pages.edit');
    }

}
