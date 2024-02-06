<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use App\Models\User;
use App\Models\ProviderType;
use App\Models\Servicestype;
use App\Models\Category;
use App\Models\SubCategory;
use App\Models\Service;
use App\Models\Provider;
use App\Models\Order;

class ProviderController extends Controller
{
    public function booking_details($booking_id)
    {
        return response()->json([
            'status'  => true,
            'data'    => Order::getBookingDetails($booking_id)
        ]);
    }

    public function bookings(Request $request)
    {
        global $userData;

        $filters = [
            'order_status' => $request->get('order_status') ?? 'pending'
        ];

        return response()->json([
            'status'  => true,
            'data'    => Provider::getBookings(
                $userData->id,
                $filters,
                '',
                $request->get('page') ?? 1
            )
        ]);
    }

    public function update_slots(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'slots'     => [
                'required',
                function ($attribute, $value, $fail)  {

                    $slots = json_decode($value);
                    if( !is_array($slots) ) {
                        $fail('Invalid slots');
                    }

                    if( count($slots) != 7 ) {
                        $fail('slots must be for 7 days');
                    }
                }
            ]
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status'  => false,
                'message' => 'Validation error',
                'errors'  =>$validator->errors()->all()
            ], 422);
        }

        global $userData;

        Provider::saveSlots(
            $request->input('slots'),
            $userData->id
        );

        return response()->json([
            'status'  => true,
            'message'    => 'slots saved successfully'
        ]);

    }

    public function slots()
    {
        global $userData;

        $provider_id = $userData->id;

        return response()->json([
            'status'  => true,
            'data'    => Provider::getSlots($provider_id)
        ]);

    }

    public function service_types()
    {
        return response()->json([
            'status'  => true,
            'data'    => Servicestype::all('id', 'name')
        ]);
    }

    public function service_categories(Request $request)
    {
        $service_type_id = $request->get('service_type_id');

        return response()->json([
            'status'  => true,
            'data'    => Category::where('ser_type_id', $service_type_id)->get()
        ]);
    }

    public function service_sub_categories(Request $request, $category_id)
    {
        return response()->json([
            'status'  => true,
            'data'    => SubCategory::where('category_id', $category_id)->get()
        ]);
    }

    public function add_service(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name'     => 'required',
            'category_id'     => 'required',
            'subcategory_id'     => 'required',
            'price'     => 'required',
            'duration'     => 'required',
            'description'     => 'required'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status'  => false,
                'message' => 'Validation error',
                'errors'  =>$validator->errors()->all()
            ], 422);
        }

        $post_data = $request->all();
        global $userData;
        $post_data['provider_id'] = $userData->id;

        Service::create($post_data);

        return response()->json([
            'status'  => true,
            'message'    => 'service successfully'
        ]);
    }

    public function services()
    {
        global $userData;
        
        return response()->json([
            'status'  => true,
            'message'    => Service::getServices($userData->id)
        ]);
    }

    public function offline_reasons(Request $request)
    {
        return response()->json([
            'status'  => true,
            'data'     => [
                'Battery is almost dead',
                'Too much booking served today',
                'Some Personal Reasons'
            ],
            'message'    => ''
        ]);
    }

    public function change_status(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'status'     => 'required|in:online,offline',
            'reason'     => 'required'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status'  => false,
                'message' => 'Validation error',
                'errors'  =>$validator->errors()->all()
            ], 422);
        }

        $status = $request->input('status');
        $reason = $request->input('reson');

        User::changeStatus($status, $reason);

        return response()->json([
            'status'  => true,
            'message'    => 'status changed successfully'
        ]);
    }

    public function work_type(Request $request)
    {
        $work_type_data =   ProviderType::all('name')->toArray();

        return response()->json([
            'status'  => true,
            'data'    => array_column($work_type_data, 'name')
        ]);
    }
}