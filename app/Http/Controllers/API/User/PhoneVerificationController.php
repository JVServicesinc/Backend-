<?php

namespace App\Http\Controllers\API\User;

use App\Models\PhoneVerification;
use App\Http\Requests\StorePhoneVerificationRequest;
use App\Http\Requests\UpdatePhoneVerificationRequest;
use App\Http\Requests\VerifyPhoneRequest;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Log;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Str;

class PhoneVerificationController extends Controller
{
    /*
    * Send OTP on mobile number
    * 
    * @params string $country_code
    * @params string $contact_number
    * @return mixed
    */
    public function sendOTP(Request $request){

        try
        {
            $token = rand(1000, 9999); // Generating random OTP
            $request['token'] = $token; // Setting token for OTP
          
            $responseSms = PhoneVerification::getExistingPhoneVerification($request->contact_number);

            if(!$responseSms){
              return  $responseSms = PhoneVerification::create($request->all());
            }else{
                $responseSms->token = $token;
                $responseSms->save();
            }


            if($responseSms){
                return response()->json([
                    'status' => true,
                    'message' => 'OTP Sent Successfully.',
                    'token' => $token
                ], 200);
            }
        }catch(\Exception $exception){
            \Log::info('Error while sending SMS : '.$exception->getMessage());
        }

        return response()->json([
            'status' => false,
            'message' => 'Something went wrong! Pls Try Again.'
        ]);

    }

    /*
    * Verify OTP on mobile number
    * 
    * @params string $contact_number
    * @params string $token
    * @return mixed
    */
    public function verifyOTP(VerifyPhoneRequest $request){

        try
        {
            $verifyPhone = PhoneVerification::query()
            ->where([
                    'contact_number' => $request->contact_number,
                    'token' => $request->token
                ])->first();

            if($verifyPhone){

                $verifyPhone->delete();

                return response()->json([
                    'status' => true,
                    'message' => 'OTP Verified Successfully.',
                ], 200);
            }
        }catch(\Exception $exception){
            \Log::info('Error while verifying SMS : '.$exception->getMessage());
        }

        return response()->json([
            'status' => false,
            'message' => 'Invalid Mobile or OTP.'
        ]);

    }
}
