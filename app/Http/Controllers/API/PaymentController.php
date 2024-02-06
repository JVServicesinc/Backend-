<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Payment;
use App\Models\Booking;
use App\Http\Resources\API\PaymentResource;
use Braintree;
class PaymentController extends Controller
{
    public function payment_sheet (Request $request) {
        
        $stripe = new \Stripe\StripeClient('sk_test_51KrOSQCuldPGQCPaZgcH0VWZByd63Ye6NEtOrRRX9S0QnqLdRr1JN4saqfsieYwlrGm1o1sy2v2GSMYbo8mt6UHD00p2NHqNXJ');
        $stoken= $stripe->tokens->create([
           'card' => [
             'number' => '4242424242424242',
             'exp_month' => 9,
             'exp_year' => 2023,
             'cvc' => '314',
           ],
         ]);
       
         $charge = $stripe->charges->create([
           'amount' => 1000,
           'currency' => 'usd',
           'source' => $stoken,
           'description' => 'My First Test Charge (created for API docs at https://www.stripe.com/docs/api)'
         ]);
       return json_encode($charge);
    }

    public function savePayment(Request $request)
    {
        $data = $request->all();
        $data['datetime'] = isset($request->datetime) ? date('Y-m-d H:i:s',strtotime($request->datetime)) : date('Y-m-d H:i:s');
        $result = Payment::create($data);
        $booking = Booking::find($request->booking_id);
        $booking->payment_id = $result->id;
        $booking->total_amount = $result->total_amount;
        $booking->save();
        $status_code = 200;
        if($result->payment_status == 'paid'){
            $message = __('messages.payment_completed');
        } else {
            $message = __('messages.payment_message',['status' => __('messages.'.$result->payment_status) ]);
        }

        if($result->payment_status == 'failed')
        {
            $status_code = 400;
        }
        return comman_message_response($message,$status_code);
    }

    public function paymentList(Request $request)
    {
        $payment = Payment::myPayment()->with('booking');

        $per_page = config('constant.PER_PAGE_LIMIT');
        if( $request->has('per_page') && !empty($request->per_page)){
            if(is_numeric($request->per_page)){
                $per_page = $request->per_page;
            }
            if($request->per_page === 'all' ){
                $per_page = $payment->count();
            }
        }

        $payment = $payment->orderBy('id','desc')->paginate($per_page);
        $items = PaymentResource::collection($payment);

        $response = [
            'pagination' => [
                'total_items' => $items->total(),
                'per_page' => $items->perPage(),
                'currentPage' => $items->currentPage(),
                'totalPages' => $items->lastPage(),
                'from' => $items->firstItem(),
                'to' => $items->lastItem(),
                'next_page' => $items->nextPageUrl(),
                'previous_page' => $items->previousPageUrl(),
            ],
            'data' => $items,
        ];
        
        return comman_custom_response($response);
    }
}