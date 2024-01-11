<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Booking;
class BookingController extends Controller
{
    public function index()
    {
        return view('booking.index');
    }

    public function datatable(Request $request)
    {
        $limit = $request->get('length', 10);
        $offset = $request->get('start', 0);
        $search_key = $_GET['search']['value'];

        $bookings = Booking::getBookings($limit, $offset, $search_key);

        return response()->json( array_merge($bookings, ['draw' => (int)$request->get('draw')  ]) );
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        $booking = Booking::getBookingById($id);

        // dd($booking);
        if(empty($booking)) {
            $msg = __('messages.not_found_entry',['name' => __('messages.booking')] );
            return redirect(route('booking.list'))->withError($msg);
        }
        
        return view('booking.view', [
            'booking' => $booking
        ]);
    }
}
