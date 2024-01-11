<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Order;

class OrderController extends Controller
{
    public function index()
    {
        return view('order.index');
    }

    public function datatable(Request $request)
    {
        $limit = $request->get('length', 10);
        $offset = $request->get('start', 0);
        $search_key = $_GET['search']['value'];

        $bookings = Order::getAllOrders($limit, $offset, $search_key);

        return response()->json( array_merge($bookings, ['draw' => (int)$request->get('draw')]) );
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        $order = Order::getOrderDetails($id);
        // dd($order);
        if(empty($order)) {
            $msg = __('messages.not_found_entry',['name' => __('messages.order')] );
            return redirect(route('orders.list'))->withError($msg);
        }
        
        return view('order.view', [
            'order' => $order
        ]);
    }
}