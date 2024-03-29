<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Service;
use App\Models\Coupon;
use App\Models\BookingRating;
use App\Models\UserFavouriteService;
use App\Models\ServiceFaq;
use App\Models\User;
use App\Models\ServiceSlots;
use App\Http\Resources\API\ServiceResource;
use App\Http\Resources\API\UserResource;
use App\Http\Resources\API\ServiceDetailResource;
use App\Http\Resources\API\BookingRatingResource;
use App\Http\Resources\API\CouponResource;
use App\Http\Resources\API\UserFavouriteResource;
use App\Http\Resources\API\ProviderTaxResource;
use App\Models\ProviderServiceAddressMapping;
use App\Models\ProviderTaxMapping;
use Illuminate\Support\Facades\DB;

class ServiceController extends Controller
{
	public function getServiceList(Request $request)
    {

        $service = Service::with(['providers','category','serviceRating']);

        // dd($service);

        if($request->has('status') && isset($request->status)){
            $service->where('status',$request->status);
        }
        
        if($request->has('provider_id')){
            $service->where('provider_id',$request->provider_id);        
        }
        
        if($request->has('category_id')){
            $service->where('category_id',$request->category_id);
        }
		if($request->has('subcategory_id')){
            $service->where('subcategory_id',$request->subcategory_id);
        }
        if($request->has('is_featured')){
            $service->where('is_featured',$request->is_featured);
        }
        if($request->has('is_discount')){
            $service->where('discount','>',0)->orderBy('discount','desc');
        }
        if($request->has('is_rating') && $request->is_rating != ''){
            $service->whereHas('serviceRating', function($q) use ($request) {
                $q->select('service_id',DB::raw('round(AVG(rating),0) as total_rating'))->groupBy('service_id');
                return $q;
            });
        }
        if($request->has('is_price_min') && $request->is_price_min != '' || $request->has('is_price_max') && $request->is_price_max != ''){
            $service->whereBetween('price', [$request->is_price_min, $request->is_price_max]); 
        }
        if ($request->has('city_id')) {
            $service->whereHas('providers', function ($a) use ($request) {
                $a->where('city_id', $request->city_id);
            });
        }
        
        if($request->has('provider_id') && $request->provider_id != '' ){
            $service->whereHas('providers', function ($a) use ($request) {
                $a->where('status', 1);
            });
        }else{
            if(default_earning_type() === 'subscription'){
                $service->whereHas('providers', function ($a) use ($request) {
                    $a->where('status', 1)->where('is_subscribe',1);
                });
            }
        }
        if ($request->has('latitude') && !empty($request->latitude) && $request->has('longitude') && !empty($request->longitude)) {
            $get_distance = getSettingKeyValue('DISTANCE','DISTANCE_RADIOUS');
            $get_unit = getSettingKeyValue('DISTANCE','DISTANCE_TYPE');
            
            $locations = $service->locationService($request->latitude,$request->longitude,$get_distance,$get_unit);
            $service_in_location = ProviderServiceAddressMapping::whereIn('provider_address_id',$locations)->get()->pluck('service_id');
            $service->with('providerServiceAddress')->whereIn('id',$service_in_location);
        }

        if($request->has('search')){
            $service->where('name','like',"%{$request->search}%");
        }

        $per_page = config('constant.PER_PAGE_LIMIT');
        if( $request->has('per_page') && !empty($request->per_page)){
            if(is_numeric($request->per_page)){
                $per_page = $request->per_page;
            }
            if($request->per_page === 'all' ){
                $per_page = $service->count();
            }
        }

//        dd($request->per_page);

        $service = $service->where('status',1)->orderBy('created_at','desc')->paginate($per_page);


        $servicesss = Service::where('status',1)->orderBy('created_at','desc')->get();

        foreach($servicesss as $ser)
        {

            $ser->providers_data = [];
            if(!empty($ser->providers_val))
            {
                
                $a = explode(',', $ser->providers_val);

                $u = User::whereIn('id', $a)->pluck('display_name', 'id');

                $ser->providers_data = $u; 

                // dd('ser',$ser);
            }    
        }    

        $items = ServiceResource::collection($service);

        $user = User::orderBy('id', 'DESC')->get();

        // dd($user);

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
            'providers' => $user,
            'services' => $servicesss,
            'max'=> $service->max('price'),
            'min'=> $service->min('price'),
        ];
        
        return comman_custom_response($response);
    }

    public function getServiceDetail(Request $request){

        $id = $request->service_id;
        $service = Service::with('providers','category','serviceRating')->findorfail($id);
        $service_detail = new ServiceDetailResource($service);
        $related = $service->where('category_id',$service->category_id)->get();
        $related_service = ServiceResource::collection($related);

        $rating_data = BookingRatingResource::collection($service_detail->serviceRating);
                
        $customer_reviews = [];
        if($request->customer_id != null){
            $customer_review = BookingRating::where('customer_id',$request->customer_id)->where('service_id',$id)->get();
            if (!empty($customer_review))
            {
                $customer_reviews = BookingRatingResource::collection($customer_review);
            }
        }
        
        $coupon = Coupon::with('serviceAdded')
                ->where('expire_date','>',date('Y-m-d H:i'))
                ->where('status',1)
                ->whereHas('serviceAdded',function($coupon) use($id){
                    $coupon->where('service_id', $id );
                })->get();
        $coupon_data = CouponResource::collection($coupon);
        $tax = ProviderTaxMapping::with('taxes')->where('provider_id',$service->provider_id)->get();
        $taxes = ProviderTaxResource::collection($tax);
        $servicefaq =  ServiceFaq::where('service_id',$id)->get();
        $response = [
            'service_detail'    => $service_detail,
            'provider'          => new UserResource(optional($service->providers)),
            'rating_data'       => $rating_data,
            'customer_review'   => $customer_reviews,
            'coupon_data'       => $coupon_data,
            'taxes'             => $taxes,
            'related_service'   => $related_service,
            'service_faq'        => $servicefaq
        ];

        return comman_custom_response($response);
    }

    public function getServiceRating(Request $request){

        $rating_data = BookingRating::where('service_id',$request->service_id);

        // $per_page = config('constant.PER_PAGE_LIMIT');
        // if( $request->has('per_page') && !empty($request->per_page)){
        //     if(is_numeric($request->per_page)){
        //         $per_page = $request->per_page;
        //     }
        //     if($request->per_page === 'all' ){
        //         $per_page = $rating_data->count();
        //     }
        // }

       // $rating_data = $rating_data->orderBy('id','desc')->paginate($per_page);
       $rating_data = $rating_data->orderBy('id','desc');
        $items = BookingRatingResource::collection($rating_data);

        $response = [
            // 'pagination' => [
            //     'total_items' => $items->total(),
            //     'per_page' => $items->perPage(),
            //     'currentPage' => $items->currentPage(),
            //     'totalPages' => $items->lastPage(),
            //     'from' => $items->firstItem(),
            //     'to' => $items->lastItem(),
            //     'next_page' => $items->nextPageUrl(),
            //     'previous_page' => $items->previousPageUrl(),
            // ],
            'data' => $items,
        ];
        
        return comman_custom_response($response);
    }

    public function saveFavouriteService(Request $request)
    {
        $user_favourite = $request->all();

        $result = UserFavouriteService::updateOrCreate(['id' => $request->id], $user_favourite);

        $message = __('messages.update_form',[ 'form' => __('messages.favourite') ] );
		if($result->wasRecentlyCreated){
			$message = __('messages.save_form',[ 'form' => __('messages.favourite') ] );
		}

        return comman_message_response($message);
    }

    public function deleteFavouriteService(Request $request)
    {
        
        $service_rating = UserFavouriteService::where('user_id',$request->user_id)->where('service_id',$request->service_id)->delete();
        
        $message = __('messages.delete_form',[ 'form' => __('messages.favourite') ] );

        return comman_message_response($message);
    }

    public function getUserFavouriteService(Request $request)
    {
        $user = auth()->user();

        $favourite = UserFavouriteService::where('user_id',$user->id);

        $per_page = config('constant.PER_PAGE_LIMIT');

        if( $request->has('per_page') && !empty($request->per_page)){
            if(is_numeric($request->per_page)){
                $per_page = $request->per_page;
            }
            if($request->per_page === 'all' ){
                $per_page = $favourite->count();
            }
        }

        $favourite = $favourite->orderBy('created_at','desc')->paginate($per_page);

        $items = UserFavouriteResource::collection($favourite);

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
    public function getTopRatedService(){
        $rating_data = BookingRating::orderBy('rating','desc')->limit(5)->get();
        $items = BookingRatingResource::collection($rating_data);

        $response = [
            'data' => $items,
        ];
        
        return comman_custom_response($response);
    }


    public function getServices(Request $request)
    {
        $sql = "SELECT 
            id,
            name,
            namefr,
            LOWER( REPLACE(name, ' ', '-') ) AS slug,
            description,
            descriptionfr
        FROM jv_service_types 
        ORDER BY show_order
        LIMIT 3";

        $service_types = DB::select($sql);

        foreach($service_types as $service_type) {
            // find main jv_service_categories
            $categoires = DB::select("SELECT 
                t1.id,
                t1.name,
                t1.namefr,
                LOWER( REPLACE(t1.name, ' ', '-') ) AS slug,
                t1.is_featured,
                t1.description,
                t1.descriptionfr,
                t1.image as image_url
            FROM jv_service_categories AS t1
            WHERE t1.status = 1 AND t1.ser_type_id = ? AND t1.deleted_at IS NULL
            LIMIT 4", [$service_type->id]);
    
            foreach($categoires as $cat) {
                $cat->image_url = env('IMAGEKIT_URL_ENDPOINT') .  $cat->image_url;
            }

            $service_type->jv_service_categories = $categoires;
        }

        return response()->json([
            'status' => true,
            'data' => $service_types
        ]);
    }

    public function getServiceCategories(Request $request, $service_type_id)
    {
        // find all catgories for this service
        $sql = "SELECT 
            c.id,
            c.name,
            c.namefr,
            LOWER( REPLACE(c.name, ' ', '-') ) AS slug,
            c.description,
            c.is_featured,
            c.descriptionfr,
            c.image as image_url
        FROM jv_service_categories AS c
        WHERE c.ser_type_id = ?
        ORDER BY c.name ASC";

        $categoires = DB::select($sql, [$service_type_id]);

        foreach($categoires as $cat) {
            $cat->image_url = env('IMAGEKIT_URL_ENDPOINT') .  $cat->image_url;
        }

        return response()->json([
            'status' => true,
            'data' => $categoires
        ]);
    }

    public function getServiceSubcategoires(Request $request, $service_type_id, $category_id)
    {
        $sql = "SELECT 
            id,
            sub_image AS image_url,
            name,
            namefr,
            LOWER( REPLACE(name, ' ', '-') ) AS slug,
            description,
            descriptionfr,
            is_featured
            FROM jv_service_subcategories
            WHERE category_id = ?";

        $subcategoires = DB::select($sql, [$category_id]);

        foreach($subcategoires as $data) {
            $data->image_url = env('IMAGEKIT_URL_ENDPOINT') . $data->image_url;
        }

        return response()->json([
            'status' => true,
            'data' => $subcategoires
        ]);
    }

    public function getServicesBySubcategory(Request $request, $service_type_id, $sub_cat_id)
    {
        $sql = "SELECT 
        s.id,
        s.name,
        s.namefr,
        s.image AS image_url,
        LOWER( REPLACE(REPLACE(s.name, '- ', ''), ' ', '-') ) AS slug,
        s.price,
        s.type AS discount_type,
        s.duration AS service_duration,
        s.description,
        s.descriptionfr,
        s.is_featured
        FROM jv_services AS s
        WHERE s.subcategory_id = ? AND s.status = 1 AND s.deleted_at IS NULL";

        $services = DB::select($sql, [$sub_cat_id]);

        foreach($services as $data) {
            // find media urls
            $urls = [
                env('IMAGEKIT_URL_ENDPOINT') . $data->image_url
            ];

            $data->image_urls = $urls;
        }

        return response()->json([
            'status' => true,
            'data' => $services
        ]);
    }

    public function serviceDetails($service_id)
    {
        $sql = "SELECT 
        s.id,
        s.name,
        s.namefr,
        s.image AS image_url,
        LOWER( REPLACE(REPLACE(s.name, '- ', ''), ' ', '-') ) AS slug,
        s.price,
        s.duration AS service_duration,
        s.description,
        s.descriptionfr,
        s.is_featured
        FROM jv_services AS s
        WHERE s.id = ? AND s.status = 1 AND s.deleted_at IS NULL";

        $service = DB::selectOne($sql, [$service_id]);

        $urls = [
            env('IMAGEKIT_URL_ENDPOINT') . $service->image_url
        ];
     
        $service->image_urls = $urls;

        return response()->json([
            'status' => true,
            'data' => $service
        ]);
    }

    public function serviceSlots($service_id, $weekday_number)
    {
        return response()->json([
            'status' => true,
            'data' => ServiceSlots::getServiceTimings($service_id, $weekday_number)
        ]);
    }
}