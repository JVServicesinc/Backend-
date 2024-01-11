<?php

namespace App\Http\Controllers\API\User;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use App\Models\UserAddress;

class UserController extends Controller
{
    public function save_device_token(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'device_token' => 'required|string'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status'  => false,
                'message' => 'Validation error',
                'errors'  =>$validator->errors()->all()
            ], 422);
        }

        global $userData;

        User::saveDeviceToken($userData->id, $request->input('device_token'));
       
        return response()->json([
            'status'  => true,
            'message'    => 'device token saved successfully'
        ]);
    }

    public function user_addresses()
    {
        global $userData;

        return response()->json([
            'status'  => true,
            'data' => UserAddress::where('user_id', $userData->id)->orderBy('created_at', 'DESC')->get()
        ]);
    }

    public function add_user_addresses(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'first_name' => 'required|string',
            'last_name' => 'required|string',
            'country_name' => 'required|string',
            'street_address' => 'required|string',
            'city' => 'required|string',
            'province' => 'required|string',
            'zip_code' => 'required',
            'country_code' => 'required',
            'phone' => 'required',
            'email' => 'required|email:rfc'
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
        $post_data['user_id'] = $userData->id;
        UserAddress::create($post_data);

        return response()->json([
            'status'  => true,
            'message'    => 'user address added successfully'
        ]);
    }

    public function user_address_delete($address_id)
    {
        UserAddress::destroy($address_id);

        return response()->json([
            'status'  => true,
            'message' => 'address delete successfully'
        ]);
    }

    public function user_address_update(Request $request, $address_id)
    {
        $validator = Validator::make($request->all(), [
            'first_name' => 'required|string',
            'last_name' => 'required|string',
            'country_name' => 'required|string',
            'street_address' => 'required|string',
            'city' => 'required|string',
            'province' => 'required|string',
            'zip_code' => 'required',
            'country_code' => 'required',
            'phone' => 'required',
            'email' => 'required|email:rfc'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status'  => false,
                'message' => 'Validation error',
                'errors'  =>$validator->errors()->all()
            ], 422);
        }

        UserAddress::where('id', $address_id)->update( $request->all() );
        
        return response()->json([
            'status'  => true,
            'data' => 'address updated successfully'
        ]);
    }

    public function user_address_details($address_id)
    {
        return response()->json([
            'status'  => true,
            'data' => UserAddress::where('id', $address_id)->first()
        ]);
    }

    public function user_profile_update(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'full_name'     => 'required'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status'  => false,
                'message' => 'Validation error',
                'errors'  =>$validator->errors()->all()
            ], 422);
        }

        $data = [
            'full_name' => $request->input('full_name')
        ];

        if($request->file('user_image')){
			$imagekitFile = imageKitFileUpload(
                $request->file('user_image')
            );

            if( $imagekitFile !== false ) {
                $data['user_image']= $imagekitFile;
            }
		}

        User::updateProfile($data);

        return response()->json([
            'status'  => true,
            'message'    => 'user profile updated successfully'
        ]);
    }


    public function user_profile()
    {
        global $userData;

        $sql = "SELECT 
            u.id, 
            u.full_name, 
            u.email,
            u.country_code,
            u.mobile, 
            u.user_type, 
            u.onboarding_step_status, 
            u.provider_status,
            CASE
                WHEN u.user_image IS NULL THEN ''
                ELSE get_image_url(u.user_image)
            END AS user_profile_image
        FROM users AS u
        INNER JOIN roles AS r ON r.id = u.role_id
        WHERE u.id = :id";

        $user = DB::selectOne($sql, ['id' => $userData->id]);

        if( $user->user_type == 'user' ) {
            // check cart hash exist or not
            $sql = "SELECT 
                uniq_cart_id AS cart_id, 
                customer_lat,
                customer_lng,
                item_type,
                CASE
                    WHEN item_type = 'product' THEN (
                        SELECT SUM(qty)
                        FROM jv_customer_cart_items
                        WHERE cart_id = jv_customer_cart.id
                    )
                    ELSE (
                        SELECT SUM(qty)
                        FROM jv_customer_cart_service_items
                        WHERE cart_id = jv_customer_cart.id
                    )
                END AS total_cart_qty
            FROM jv_customer_cart 
            WHERE customer_id = $user->id";
            
            $user->cart_info = DB::selectOne($sql);
        }

        return response()->json([
            'status'  => true,
            'data'    => $user
        ]);
    }

    public function delete_user(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email'     => 'required|email:rfc'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status'  => false,
                'message' => 'Validation error',
                'errors'  =>$validator->errors()->all()
            ], 422);
        }

        User::deleteUser($request->get('email'));

        return response()->json([
            'status'  => true,
            'data'    => 'user deleted successfully'
        ]);
    }
}
