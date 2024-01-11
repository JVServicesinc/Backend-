<?php

namespace App\Http\Controllers\API;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Mail;
use App\Http\Controllers\Controller;
use App\Models\Contact;

class ContactController extends Controller
{
    public function send_message(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'customer_email'     => 'required|email:rfc',
            'customer_name'  => 'required'
        ]);
    
        if ($validator->fails()) {
            return response()->json([
                'status'  => false,
                'message' => 'Validation error',
                'errors'  => $validator->errors()->all()
            ], 422);
        }

        Contact::create($request->all());

        return response()->json([
            'status'  => true,
            'message' => 'message send successfully'
        ]);
    }
}
