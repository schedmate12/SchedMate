<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\ServiceReview;
use App\Booking;
use App\Service;
use App\User;
use App\Helper\Reply;

class ServiceReviewController extends Controller
{
    public function index()
    {
        $reviews = Review::with(['user', 'service'])->latest()->get();
         return view('admin.service-reviews.index', compact('reviews'));
    }

    public function store(Request $request)
    {
        $request->validate([
            'booking_id' => 'required|exists:bookings,id',
            'rating' => 'required|integer|min:1|max:5',
            'review' => 'nullable|string|max:1000'
        ]);

        $booking = Booking::find($request->booking_id);

        // Ensure user is allowed to review this booking
        if ($booking->status !== 'completed') {
            return Reply::error('Review allowed only after completion.');
        }

        $review = new Review();
        $review->user_id = $booking->user_id;
        $review->service_id = $booking->service_id;
        $review->booking_id = $booking->id;
        $review->rating = $request->rating;
        $review->review = $request->review;
        $review->save();

        return Reply::success('Review submitted successfully.');
    }

    public function destroy($id)
    {
        $review = Review::findOrFail($id);
        $review->delete();

        return Reply::success('Review deleted.');
    }
}
