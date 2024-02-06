<?php

namespace App\Http\Controllers\API;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Mail;
use App\Http\Controllers\Controller;
use App\Models\User;
use App\Mail\CustomerRegistered;

class AuthController extends Controller
{
    public function verify_mobile(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'mobile'     => 'required|digits:10|exists:users'
        ], [
            'mobile.exists' => 'No user exist with this mobile'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status'  => false,
                'message' => 'Validation error',
                'errors'  =>$validator->errors()->all()
            ], 422);
        }

        User::markMobileAsVerified(
            $request->input('mobile')
        );

        return response()->json([
            'status'  => true,
            'message' => 'mobile verified successfully'
        ]);
    }

    public function check_account(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email'     => 'required|email:rfc'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status'  => false,
                'message' => 'Validation error',
                'errors'  => $validator->errors()->all()
            ], 422);
        }

        return response()->json([
            'status'  => true,
            'data'    => User::getAccountStatus(
                $request->input('email')
            )
        ]);
    }

    public function change_password(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email'     => 'required|email:rfc|exists:users',
            'password'  => 'required|min:6'
        ], [
            'email.exists' => 'No user exist with this email'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status'  => false,
                'message' => 'Validation error',
                'errors'  => $validator->errors()->all()
            ], 422);
        }

        User::changePassword($request->all());

        return response()->json([
            'status'  => true,
            'message' => 'password changed successfully'
        ]);
    }

    public function validate_forgot_password_otp(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email'     => 'required|email:rfc|exists:users',
            'otp'       => 'required'
        ], [
            'email.exists' => 'No user exist with this email'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status'  => false,
                'message' => 'Validation error',
                'errors'  => $validator->errors()->all()
            ], 422);
        }

        try {
            User::validateForgotPasswordOtp(
                $request->input('email'),
                $request->input('otp')
            );

            return response()->json([
                'status'  => true,
                'message' => 'otp validated successfully'
            ]);
        } catch( \Exception $e ) {
            return response()->json([
                'status'  => false,
                'message' => $e->getMessage()
            ], 422);
        }

    }



    public function send_forgot_password_otp(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email'     => 'required|email:rfc|exists:users'
        ], [
            'email.exists' => 'No user exist with this email'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status'  => false,
                'message' => 'Validation error',
                'errors'  => $validator->errors()->all()
            ], 422);
        }

        User::sendForgotPasswordOtp(
            $request->input('email')
        );

        return response()->json([
            'status'  => true,
            'message' => 'otp send successfully'
        ]);
    }

    public function test(Request $request)
    {
        $emailData = [
            'full_name' => 'Bera Dev',
            'email_otp' => random_int(152368, 999999)
        ];

        Mail::to( 'joykumarbera@gmail.com' )->send(new CustomerRegistered($emailData));
    }

    public function register(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'full_name' => 'required|max:255',
            'mobile'    => 'required|digits:10|unique:users',
            'email'     => 'required|email:rfc|unique:users',
            'city'      => 'required',
            'work_type' => 'required',
            'password'  => 'required|min:6'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status'  => false,
                'message' => 'Validation error',
                'errors'  =>$validator->errors()->all()
            ], 422);
        }

        $data = [
            'full_name' => $request->input('full_name'),
            'mobile'    => $request->input('mobile'),
            'email'     => $request->input('email'),
            'city'      => $request->input('city'),
            'work_type' => $request->input('work_type'),
            'user_type' => $request->input('user_type'),
            'password'  => $request->input('password'),
        ];

        if( !User::registerUser($data) ) {
            return response()->json([
                'status' => false,
                'error'=> 'Server error'
            ], 500);
        }

        return response()->json([
            'status'  => true,
            'message' => 'Registration successfull'
        ]);
    }

    public function user_register(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'full_name' => 'required|max:255',
            'mobile'    => 'required|digits:10|unique:users',
            'email'     => 'required|email:rfc|unique:users',
            'password'  => 'required|min:6',
            'country_code' => 'required|regex:/^\+\d{1,3}$/'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status'  => false,
                'message' => 'Validation error',
                'errors'  =>$validator->errors()->all()
            ], 422);
        }

        $data = [
            'full_name' => $request->input('full_name'),
            'mobile'    => $request->input('mobile'),
            'email'     => $request->input('email'),
            'password'  => $request->input('password'),
            'user_type' => 'user',
            'country_code' => $request->input('country_code'),
        ];

        if( !User::registerUser($data) ) {
            return response()->json([
                'status' => false,
                'error'=> 'Server error'
            ], 500);
        }

        return response()->json([
            'status'  => true,
            'message' => 'Registration successfull'
        ]);
    }

    public function user_verify_email(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email'     => 'required|email:rfc|exists:users',
            'otp'  => 'required'
        ], [
            'email.exists' => 'No user exist with this email'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status'  => false,
                'message' => 'Validation error',
                'errors'  =>$validator->errors()->all()
            ], 422);
        }

        try {
            User::validateEmailOtp(
                $request->input('email'),
                $request->input('otp')
            );

            return response()->json([
                'status'  => true,
                'message' => 'otp validated successfully'
            ]);
        } catch( \Exception $e ) {
            return response()->json([
                'status'  => false,
                'message' => $e->getMessage()
            ], 422);
        }
    }

    public function user_resend_email_otp(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email'     => 'required|email:rfc|exists:users'
        ], [
            'email.exists' => 'No user exist with this email'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status'  => false,
                'message' => 'Validation error',
                'errors'  =>$validator->errors()->all()
            ], 422);
        }
        User::resendEmailOtp(
            $request->input('email')
        );

        return response()->json([
            'status'  => true,
            'message' => 'otp send successfully'
        ]);
    }

    public function login(Request $request )
    {
        $validator = Validator::make($request->all(), [
            'username'   => [
                'required',
                function ($attribute, $value, $fail)  {
                    // try to find user by email or mobile
                    $sql = "SELECT * FROM users WHERE email = :email OR mobile = :mobile";
                    $user = \Illuminate\Support\Facades\DB::selectOne($sql, ['email' => $value, 'mobile' => $value]);

                    if( is_null($user) ) {
                        $fail('No user exist with this username');
                    }

                    if( !is_null($user) && $user->is_email_verified == 0 ) {
                        $fail('Email is not verified');
                    }
                }
            ],
            'password'  => [
                'required',
                'min:6',
                function ($attribute, $value, $fail)  {
                    $sql = "SELECT * FROM users WHERE email = :email OR mobile = :mobile";
                    $user = \Illuminate\Support\Facades\DB::selectOne($sql, ['email' => request()->get('username'), 'mobile' => request()->get('username')]);

                    if( !is_null($user) ) {
                        if( ! Hash::check( $value, $user->password ) ) {
                            $fail('Password does not match');
                        }
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

        $data = [
            'username' => $request->input('username')
        ];

        $result = User::initLogin($data);

        if( $result !== false ) {
            return response()->json([
                'status'  => true,
                'data'      => $result,
                'message' => 'Login successfull'
            ]);
        }

        return response()->json([
            'status' => false,
            'error'=> 'Server error'
        ], 500);
    }
}