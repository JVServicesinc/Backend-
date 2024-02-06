<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Booking;
use App\Models\BookingStatus;
use App\Models\BookingRating;
use App\Models\HandymanRating;
use App\Models\BookingActivity;
use App\Models\Payment;
use App\Models\Wallet;
use App\Models\User;
use App\Models\Service;
use App\Models\ServiceProof;
use App\Http\Resources\API\BookingResource;
use App\Http\Resources\API\BookingDetailResource;
use App\Http\Resources\API\BookingRatingResource;
use App\Http\Resources\API\ServiceResource;
use App\Http\Resources\API\UserResource;
use App\Http\Resources\API\HandymanResource;
use App\Http\Resources\API\HandymanRatingResource;
use App\Http\Resources\API\ServiceProofResource;
use Auth;
use DB;

class BookingController extends Controller
{
   
    function mail(){
$to = 'sandeep2siripurapu@gmail.com';
$subject = 'Birthday Reminders for August';
$message = '
<html>
<head>
  <title>Birthday Reminders for August</title>
</head>
<body>
  <p>Here are the birthdays upcoming in August!</p>
  <table>
    <tr>
      <th>Person</th><th>Day</th><th>Month</th><th>Year</th>
    </tr>
    <tr>
      <td>Joe</td><td>3rd</td><td>August</td><td>1970</td>
    </tr>
    <tr>
      <td>Sally</td><td>17th</td><td>August</td><td>1973</td>
    </tr>
  </table>
</body>
</html>
';

$headers = array("From: from@example.com",
    "Reply-To: replyto@example.com",
    "X-Mailer: PHP/" . PHP_VERSION
);
$headers = implode("\r\n", $headers);
 if(mail($to, $subject, $message, $headers)){
    return "sent";
}else{
   return "not sent";
}

    }
    function setlat(Request $req){
        $check=DB::select("select * from getmap where provider_id='$req->provider_id' and customer_id='$req->customer_id'");
       
        if(count($check)==0){
        $tbl=DB::table('getmap')->insert(  [ "provider_id"=>$req->provider_id,
        "customer_id"=>$req->customer_id,
        "lat"=>$req->lat,
        "lang"=>$req->lang,
        "updated_at"=>date("Y-m-d H:i:s")]);
        }else{
            $tbl=DB::table('getmap')->where('id',$check[0]->id)->update(
                [ "provider_id"=>$req->provider_id,
                "customer_id"=>$req->customer_id,
                "lat"=>$req->lat,
                "lang"=>$req->lang,
                "updated_at"=>date("Y-m-d H:i:s")]
            );   
        }
        if($tbl){
            return json_encode(array("status"=>200,"message"=>"map updated successfully"));
        }else{
           return json_encode(array("status"=>500,"message"=>"something went wrong"));
        }
    }
   function getlat(Request $req){
    return $check=DB::select("select * from getmap where provider_id='$req->provider_id' and customer_id='$req->customer_id'");
       
   }
    function updttxn(Request $req){
     $tbl=Booking::where('customer_id',$req->customer_id)->get();
     $tbl=$tbl[0];
     $tbl->transaction_id=$req->txn_id;
     $tbl->tx_status=$req->txn_status;
     $tbl->tx_date=date("Y-m-d H:i");
     $tbl->save();
     if($tbl->count()>0){
        $data[]=array('tx_id'=>$req->txn_id,'tx_status'=>$req->txn_status,'tx_date'=>date("Y-m-d H:i"),'userid'=>$req->customer_id);
      $tbl1=DB::table('transaction')->insert($data); 
        return json_encode(array("status"=>200,"message"=>"transaction details updated successfully"));
     }else{
        return json_encode(array("status"=>500,"message"=>"something went wrong"));
     }
    }
    public function PostBookingSave(Request $request)
    {
       // dd($request->all());
        //dd(date('Y-m-d H:i:s'));
        
        // if($cart)
        // {
            $cnt= count($request->all());
            $date=date('Y-m-d H:i:s');
          for($i=0;$i<$cnt;$i++){
            $cartId = $request[$i]['cartId'];
        $bd = $request[$i]['booking_date'];
        $bt = $request[$i]['booking_time'];
        $cart = DB::table('addToCart')->where('id', $cartId)->first();
        $service = Service::where('id', $cart->service_id)->first();
        $user = User::where('id', $cart->user_id)->first();
            $data[]=array('customer_id'=>$cart->user_id,
            'service_id'=>$cart->service_id,
            'date'=>$date,
            'booking_date'=>$bd,
            'booking_time'=>$bt,
            'quantity'=>$cart->service_quantity,
            'amount'=>$service->price,
            'total_amount'=>((int)$service->price * (int)$cart->service_quantity),
            'status'=>0);
        
          }
                      
            // $data = array();

            // $data['customer_id'] = $cart->user_id;
            // $data['service_id'] = $cart->service_id;
            // $data['date'] = date('Y-m-d H:i:s');
            // $data['booking_date'] = $bd;
            // $data['booking_time'] = $bt;
            // $data['quantity'] = $cart->service_quantity;
            // $data['amount'] = $service->price;
            // $data['total_amount'] = (int)$service->price * (int)$cart->service_quantity;
            // $data['status'] = 0;

            $booking = DB::table('bookings')->insert($data);
            // $booking = new Booking();
            // $booking->save($data);
            // dd('bdata',$booking);
             $providers_data = [];
            if(!empty($service->providers_val))
            {
                
                $a = explode(',', $service->providers_val);

                $u = User::whereIn('id', $a)->get();

                $providers_data = $u; 

                // dd('ser',$ser);
            }else {

                $a = $service->provider_id;

                $u = User::where('id', $a)->first();

                $providers_data = $u;
            }    

             $response = [
                'booking' => $booking,
                'service' => $service,
                'user'  => $user, 
                'providers' => $providers_data,
             ];

             return comman_custom_response($response);

        // }else {
        //     return comman_custom_response(['error' => "Cart Item Not Found"]);
        // }    
    }

    public function PostBookingCancel(Request $request)
    {
        $uid = $request->uid;
        $bid = $request->bid;
        $booking = Booking::where('customer_id', $uid)->where('id', $bid)->first();

        if($booking)
        {
            $previous = $booking->date;
             $newTime = date('Y-m-d H:i:s');   

            $timediff = strtotime($previous) - strtotime($newTime);

                if($timediff > 86400){ 
                    return comman_custom_response(['error' => "Booking Cancel Failed, Time Limit Exceeded"]);

                }
                else
                {
                  $data = array('id'=> $bid, 'status'=> 4);

                    $booking = DB::table('bookings')->update($data);

                     return comman_custom_response(['success' => "Booking Cancel Successfully"]);
 
                }

        }else {
            return comman_custom_response(['error' => "Booking Data Not Found"]);
        }    
    }

    public function PostProviderBook(Request $request)
    {
        $pid = $request->pid;
        $bid = $request->bid;

        $booking = Booking::find($bid);
        if($booking)
        {
            $data = array('provider_id'=> $pid, 'status'=> 1);

             $booking = DB::table('bookings')->where('id', $bid)->update($data);

        return comman_custom_response(['success' => "Booking Update Successfully And Provider Assign to this Booking"]);
        }    
    }

    public function PostProviderBookingRunning(Request $request)
    {
        $pid = $request->pid;

        $Bookings = Booking::where('provider_id', $pid)->where('status', 1)->get();

            foreach($Bookings as $Booking)
            {
                $service = Service::where('id', $Booking->service_id)->first();
                $user = User::where('id', $Booking->customer_id)->first();

                $Booking['user'] = $user;
                $Booking['service'] = $service;   
            }    

        if($Bookings)
        {
            $response = [
                'Bookings' => $Bookings,
            ];   

             return comman_custom_response($response);
        }else {
            return comman_custom_response(['error' => "Running Booking Not Available For This Provider"]);
        }    
    }

    public function PostProviderBookingRunningUser(Request $request)
    {
        $uid = $request->uid;

        $Bookings = Booking::where('customer_id', $uid)->where('status', 1)->get();

        //dd($Bookings);

            foreach($Bookings as $Booking)
            {
                $service = Service::where('id', $Booking->service_id)->first();
                $user = User::where('id', $Booking->customer_id)->first();

                $Booking['user'] = $user;
                $Booking['service'] = $service;   
            }    


        if($Bookings)
        {
            $response = [
                'Bookings' => $Bookings,
            ];   

             return comman_custom_response($response);
        }else {
            return comman_custom_response(['error' => "Running Booking Not Available For This User"]);
        }    
    }

    public function PostProviderBookingCompleteUser(Request $request)
    {
        $uid = $request->uid;

        $Bookings = Booking::where('customer_id', $uid)->where('status', 2)->get();

            foreach($Bookings as $Booking)
            {
                $service = Service::where('id', $Booking->service_id)->first();
                $user = User::where('id', $Booking->customer_id)->first();

                $Booking['user'] = $user;
                $Booking['service'] = $service;   
            }    

        if($Bookings)
        {
            $response = [
                'Bookings' => $Bookings,
            ];   

             return comman_custom_response($response);
        }else {
            return comman_custom_response(['error' => "Completed Booking Not Available For This User"]);
        }    
    }     

    public function PostProviderBookingComplete(Request $request)
    {
         $pid = $request->pid;

        $Bookings = Booking::where('provider_id', $pid)->where('status', 2)->get();

        foreach($Bookings as $Booking)
            {
                $service = Service::where('id', $Booking->service_id)->first();
                $user = User::where('id', $Booking->customer_id)->first();

                $Booking['user'] = $user;
                $Booking['service'] = $service;   
            }    

        if($Bookings)
        {
            $response = [
                'Bookings' => $Bookings,
            ];   

             return comman_custom_response($response);
        }else {
            return comman_custom_response(['error' => "Completed Booking Not Available For This Provider"]);
        }    
    }

    public function PostProviderBookingCompletePerform(Request $request)
    {
        $pid = $request->pid;
        $bid = $request->bid;

        $booking = Booking::where('provider_id', $pid)->where('id', $bid)->first();

        if($booking)
        {
            $data = array('provider_id'=> $pid, 'status'=> 2);

             $booking = DB::table('bookings')->where('id', $bid)->update($data);


             return comman_custom_response(['success' => "Booking Completed", 'booking' => $booking]);
        }else {
            return comman_custom_response(['error' => "Something Went Wrong! Booking Not Found"]);
        }
    }

    public function PostProviderServiceList(Request $request)
    {
        $pid = $request->pid;

        $services = Service::all();
            
            $i = array();
        foreach($services as $ser)
        {
             
            if(!empty($ser->providers_val))
            {
                   
                $a = explode(',', $ser->providers_val);
                if(in_array($pid, $a)){
                    $service = Service::where('id', $ser->id)->first();
                    array_push($i, $service);
                }             
                
            }    
        }    
            
        if($i)
        {
            $response = [
                'Services' => $i,
             ];   

             return comman_custom_response($response);
        }else {
            return comman_custom_response(['error' => 'Services not Available For This provider Id']);
        }    


    }

    public function PostProviderBookingDetails(Request $request)
    {
        $pid = $request->pid;

        $services = Service::all();
            
            $i = array();
        foreach($services as $ser)
        {
             
            if(!empty($ser->providers_val))
            {
                   
                $a = explode(',', $ser->providers_val);
                if(in_array($pid, $a)){
                    array_push($i, $ser->id);
                }             
                
            }    
        }    
            //dd(array_unique($s));
            $d = array_unique($i);

            $Bookings = Booking::whereIn('service_id', $d)->where('status', 0)->get();

            foreach($Bookings as $Booking)
            {
                $service = Service::where('id', $Booking->service_id)->first();
                $user = User::where('id', $Booking->customer_id)->first();

                $Booking['user'] = $user;
                $Booking['service'] = $service;   
            }    
             

            $response = [
                'Bookings' => $Booking,
             ];   

             return comman_custom_response($response);

    }


    public function getBookingList(Request $request){
        return [];
        $booking = Booking::myBooking()->with('customer','provider','service');

        if($request->has('status') && isset($request->status)){
            $booking->where('status',$request->status);
        }

        $per_page = config('constant.PER_PAGE_LIMIT');
        if( $request->has('per_page') && !empty($request->per_page)){
            if(is_numeric($request->per_page)){
                $per_page = $request->per_page;
            }
            if($request->per_page === 'all' ){
                $per_page = $booking->count();
            }
        }
        $orderBy = 'desc';
        if( $request->has('orderby') && !empty($request->orderby)){
            $orderBy = $request->orderby;
        }

        $booking = $booking->orderBy('updated_at',$orderBy)->paginate($per_page);
        $items = BookingResource::collection($booking);

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

    public function getBookingDetail(Request $request){

        $id = $request->booking_id;
        
        $booking_data = Booking::with('customer','provider','service','bookingRating')->where('id',$id)->first();
        if($booking_data == null){
            $message = __('messages.booking_not_found');
            return comman_message_response($message,400);  
        }
         $booking_detail = new BookingDetailResource($booking_data);
        
        $rating_data = BookingRatingResource::collection($booking_detail->bookingRating);
        $service = new ServiceResource($booking_detail->service);
        $customer = new UserResource($booking_detail->customer);
        $provider_data = new UserResource($booking_detail->provider);
        $handyman_data = HandymanResource::collection($booking_detail->handymanAdded);

        $customer_review = null;
        if($request->customer_id != null){
            $customer_review = BookingRating::where('customer_id',$request->customer_id)->where('service_id',$booking_detail->service_id)->where('booking_id',$id)->first();
            if (!empty($customer_review))
            {
                $customer_review = new BookingRatingResource($customer_review);
            }
        }

        $auth_user = auth()->user();
        if(count($auth_user->unreadNotifications) > 0 ) {
            $auth_user->unreadNotifications->where('data.id',$id)->markAsRead();
        }

        $booking_activity = BookingActivity::where('booking_id',$id)->get();
        $serviceProof = ServiceProofResource::collection(ServiceProof::with('service','handyman','booking')->where('booking_id',$id)->get());
        $response = array(
            'booking_detail'    => $booking_detail,
            'service'  => $service,
            'customer'  => $customer,
            'booking_activity'  => $booking_activity,
            'rating_data'       => $rating_data,
            'handyman_data'     => $handyman_data,
            'provider_data'     => $provider_data,
            'coupon_data'       => $booking_detail->couponAdded,
            'customer_review'   => $customer_review,
            'service_proof' => $serviceProof
      );

        return comman_custom_response($response);
    }

    public function saveBookingRating(Request $request)
    {
        $rating_data = $request->all();
        $result = BookingRating::updateOrCreate(['id' => $request->id], $rating_data);

        $message = __('messages.update_form',[ 'form' => __('messages.rating') ] );
		if($result->wasRecentlyCreated){
			$message = __('messages.save_form',[ 'form' => __('messages.rating') ] );
		}

        return comman_message_response($message);
    }

    public function deleteBookingRating(Request $request)
    {
        $user = \Auth::user();
        
        $book_rating = BookingRating::where('id',$request->id)->where('customer_id',$user->id)->delete();
        
        $message = __('messages.delete_form',[ 'form' => __('messages.rating') ] );

        return comman_message_response($message);
    }

    public function bookingStatus(Request $request)
    {
        $booking_status = BookingStatus::orderBy('sequence')->get();
        return comman_custom_response($booking_status);
    }

    public function bookingUpdate(Request $request)
    {

        $data = $request->all();
        $id = $request->id;
        // $data['date'] = isset($request->date) ? date('Y-m-d H:i:s',strtotime($request->date)) : date('Y-m-d H:i:s');
        $data['start_at'] = isset($request->start_at) ? date('Y-m-d H:i:s',strtotime($request->start_at)) : null;
        $data['end_at'] = isset($request->end_at) ? date('Y-m-d H:i:s',strtotime($request->end_at)) : null;

        
        $bookingdata = Booking::find($id);
        $paymentdata = Payment::where('booking_id',$id)->first();
        if($data['status'] === 'hold'){
            if($bookingdata->start_at == null && $bookingdata->end_at == null){
                $duration_diff = $data['duration_diff'];
                $data['duration_diff'] = $duration_diff;
            }else{
                if($bookingdata->status == $data['status']){
                    $booking_start_date = $bookingdata->start_at;
                    $request_start_date = $data['start_at'];
                    if($request_start_date > $booking_start_date){
                        $msg = __('messages.already_in_status',[ 'status' => $data['status'] ] );
                        return comman_message_response($msg);
                    }
                }else{
                    $duration_diff = $bookingdata->duration_diff;
                 
                    if($bookingdata->start_at != null && $bookingdata->end_at != null){
                        $new_diff = $data['duration_diff'];
                    }else{
                        $new_diff = $data['duration_diff'];
                    }
                    $data['duration_diff'] = $duration_diff + $new_diff;
                }
            }
        }
        if($data['status'] === 'completed'){
            $duration_diff = $bookingdata->duration_diff;
            $new_diff = $data['duration_diff'];
            $data['duration_diff'] = $duration_diff + $new_diff;
        }
        if($bookingdata->status != $data['status']) {
            $activity_type = 'update_booking_status';
        }
        if($data['status'] == 'cancelled'){
            $activity_type = 'cancel_booking';
        }
        if($data['status'] == 'rejected'){
            if($bookingdata->handymanAdded()->count() > 0){
                $assigned_handyman_ids = $bookingdata->handymanAdded()->pluck('handyman_id')->toArray();
                $bookingdata->handymanAdded()->delete();
                $data['status'] = 'accept';
            } 
            // $activity_type = 'reject_booking';
        }
        if($data['status'] == 'accept'){
            $provider_id  = $bookingdata->provider_id ? $bookingdata->provider_id :auth()->user()->id;
            $provider_wallet = Wallet::where('user_id',$provider_id)->first();
            if($provider_wallet){
                $amount  = $provider_wallet->amount;
                if($amount <  0 || $amount < $bookingdata->amount){
                    $message = __('messages.wallent_balance_error');
                    $status_code = 400;
                    return comman_message_response($message,$status_code);
                }
            }
         }
        $data['reason'] = isset($data['reason']) ? $data['reason'] : null;
        $old_status = $bookingdata->status;
        $bookingdata->update($data);
        if($old_status != $data['status'] ){
            $bookingdata->old_status = $old_status;
            $activity_data = [
                'activity_type' => $activity_type,
                'booking_id' => $id,
                'booking' => $bookingdata,
            ];
    
            saveBookingActivity($activity_data);
        }
        if($bookingdata->payment_id != null){
            $data['payment_status'] = isset($data['payment_status']) ? $data['payment_status'] : 'pending';
            $paymentdata->update($data);

            if($bookingdata->payment_id != null){
                $data['payment_status'] = isset($data['payment_status']) ? $data['payment_status'] : 'pending';
                $paymentdata->update($data);
                $activity_data = [
                    'activity_type' => 'payment_message_status',
                    'payment_status'=> $data['payment_status'],
                    'booking_id' => $id,
                    'booking' => $bookingdata,
                ];
                saveBookingActivity($activity_data);
            }
        }
        $message = __('messages.update_form',[ 'form' => __('messages.booking') ] );

        if($request->is('api/*')) {
            return comman_message_response($message);
		}
    }

    public function saveHandymanRating(Request $request)
    {
        $user = auth()->user();
        $rating_data = $request->all();
        $rating_data['customer_id'] = $user->id;
        $result = HandymanRating::updateOrCreate(['id' => $request->id], $rating_data);

        $message = __('messages.update_form',[ 'form' => __('messages.rating') ] );
		if($result->wasRecentlyCreated){
			$message = __('messages.save_form',[ 'form' => __('messages.rating') ] );
		}

        return comman_message_response($message);
    }

    public function deleteHandymanRating(Request $request)
    {
        $user = auth()->user();
        
        $book_rating = HandymanRating::where('id',$request->id)->where('customer_id',$user->id)->delete();
        
        $message = __('messages.delete_form',[ 'form' => __('messages.rating') ] );

        return comman_message_response($message);
    }
    public function bookingRatingByCustomer(Request $request){
        $customer_review = null;
        if($request->customer_id != null){
            $customer_review = BookingRating::where('customer_id',$request->customer_id)->where('service_id',$request->service_id)->where('booking_id',$request->booking_id)->first();
            if (!empty($customer_review))
            {
                $customer_review = new BookingRatingResource($customer_review);
            }
        }
        return comman_custom_response($customer_review);

    }
    public function uploadServiceProof(Request $request){
        $booking = $request->all();
        $result = ServiceProof::create($booking);
        if($request->has('attachment_count')) {
            for($i = 0 ; $i < $request->attachment_count ; $i++){
                $attachment = "booking_attachment_".$i;
                if($request->$attachment != null){
                    $file[] = $request->$attachment;
                }
            }
            storeMediaFile($result,$file, 'booking_attachment');
        }
		if($result->wasRecentlyCreated){
			$message = __('messages.save_form',[ 'form' => __('messages.attachments') ] );
		}
        return comman_message_response($message);
    }
}