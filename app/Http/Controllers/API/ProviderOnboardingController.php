<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\DB;
use App\Models\ProviderBankAccount;
use App\Models\ProviderDocument;
use ImageKit\ImageKit;
use App\Models\User;

class ProviderOnboardingController extends Controller
{
    public function bank_accounts()
    {
        global $userData;
        
        try {
            return response()->json([
                'status'  => true,
                'data'    => ProviderBankAccount::where('user_id', '=', $userData->id)->firstOrFail()
            ]);
        } catch( \Illuminate\Database\Eloquent\ModelNotFoundException $e ) {
            return response()->json([
                'status'  => false,
                'data'    => null,
                'message' => 'No data found'
            ], 404);
        }
    }

    public function save_bank_accounts(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'bank_name' => 'required|max:255',
            'account_number'    => 'required',
            'transit_no'    => 'required',
            'institution_no'    => 'required'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status'  => false,
                'message' => 'Validation error',
                'errors'  =>$validator->errors()->all()
            ], 422);
        }

        global $userData;

        // check if exist then update else create
        ProviderBankAccount::updateOrCreate(
            ['user_id' => $userData->id],
            [
                'bank_name' => $request->input('bank_name'),
                'account_number' => $request->input('account_number'),
                'ifsc_code' => $request->input('ifsc_code'),
                'transit_no'    => $request->input('transit_no'),
                'institution_no'    => $request->input('institution_no')
            ]
        );

        $user = User::find($userData->id);
        $user->onboarding_step_status = 'bank_complete';
        $user->save();

        return response()->json([
            'status'  => true,
            'message' => 'Bank account saved successfully'
        ]);
    }

    public function get_aadhar()
    {
        global $userData;
        
        try {
            return response()->json([
                'status'  => true,
                'data'    => ProviderDocument::getAadharInfo($userData->id)
            ]);
        } catch( \Illuminate\Database\Eloquent\ModelNotFoundException $e ) {
            return response()->json([
                'status'  => false,
                'data'    => null,
                'message' => 'No data found'
            ], 404);
        }
    }

    public function save_aadhar(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'aadhar_number' => 'required',
            'front_picture'    => 'required|image',
            'back_picture'    => 'required|image',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status'  => false,
                'message' => 'Validation error',
                'errors'  =>$validator->errors()->all()
            ], 422);
        }

        global $userData;

        $data = [   
            'document_number' => $request->get('aadhar_number'),
            'provider_id'   => $userData->id
        ];

        $front_picture = $request->file('front_picture');
        $back_picture = $request->file('back_picture');

        $imageKit = new ImageKit(
            env('IMAGEKIT_PUBLIC_KEY'),
            env('IMAGEKIT_PRIVATE_KEY'),
            env('IMAGEKIT_URL_ENDPOINT')
        );

        $fileName = uniqid() . '.' . $front_picture->getClientOriginalExtension();
        $front_picture->move(public_path('uploads/'), $fileName);

        $uploadFile = $imageKit->uploadFile([
            'file' =>  fopen( public_path('uploads/'). $fileName, "r"),
            'fileName' => $fileName,
            'useUniqueFileName' => true
        ]);

        unlink( public_path('uploads/'). $fileName );

        $data['document_front_photo']= $uploadFile->result->url;

        $fileName = uniqid() . '.' . $back_picture->getClientOriginalExtension();
        $back_picture->move(public_path('uploads/'), $fileName);

        $uploadFile = $imageKit->uploadFile([
            'file' =>  fopen( public_path('uploads/'). $fileName, "r"),
            'fileName' => $fileName,
            'useUniqueFileName' => true
        ]);

        unlink( public_path('uploads/'). $fileName );

        $data['document_back_photo']= $uploadFile->result->url;

        ProviderDocument::saveAadharInfo($data);

        $user = User::find($userData->id);
        $user->onboarding_step_status = 'aadhar_complete';
        $user->save();

        return response()->json([
            'status'  => true,
            'message' => 'Aadhar info saved successfully'
        ]);
    }

    public function get_pan()
    {
        global $userData;

        try {
            return response()->json([
                'status'  => true,
                'data'    => ProviderDocument::getPanInfo($userData->id)
            ]);
        } catch( \Illuminate\Database\Eloquent\ModelNotFoundException $e ) {
            return response()->json([
                'status'  => false,
                'data'    => null,
                'message' => 'No data found'
            ], 404);
        }
    }
    
    public function save_pan(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'pan_number' => 'required',
            'front_picture'    => 'required|image',
            'back_picture'    => 'required|image',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status'  => false,
                'message' => 'Validation error',
                'errors'  =>$validator->errors()->all()
            ], 422);
        }

        global $userData;

        $data = [   
            'document_number' => $request->get('pan_number'),
            'provider_id'   => $userData->id
        ];

        $front_picture = $request->file('front_picture');
        $back_picture = $request->file('back_picture');

        $imageKit = new ImageKit(
            env('IMAGEKIT_PUBLIC_KEY'),
            env('IMAGEKIT_PRIVATE_KEY'),
            env('IMAGEKIT_URL_ENDPOINT')
        );

        $fileName = uniqid() . '.' . $front_picture->getClientOriginalExtension();
        $front_picture->move(public_path('uploads/'), $fileName);

        $uploadFile = $imageKit->uploadFile([
            'file' =>  fopen( public_path('uploads/'). $fileName, "r"),
            'fileName' => $fileName,
            'useUniqueFileName' => true
        ]);

        unlink( public_path('uploads/'). $fileName );

        $data['document_front_photo']= $uploadFile->result->url;

        $fileName = uniqid() . '.' . $back_picture->getClientOriginalExtension();
        $back_picture->move(public_path('uploads/'), $fileName);

        $uploadFile = $imageKit->uploadFile([
            'file' =>  fopen( public_path('uploads/'). $fileName, "r"),
            'fileName' => $fileName,
            'useUniqueFileName' => true
        ]);

        unlink( public_path('uploads/'). $fileName );

        $data['document_back_photo']= $uploadFile->result->url;

        ProviderDocument::savePanInfo($data);

        $user = User::find($userData->id);
        $user->onboarding_step_status = 'pan_complete';
        $user->save();

        return response()->json([
            'status'  => true,
            'message' => 'Pan info saved successfully'
        ]);
    }

    public function get_sin()
    {
        global $userData;

        try {
            return response()->json([
                'status'  => true,
                'data'    => ProviderDocument::getSinInfo($userData->id)
            ]);
        } catch( \Illuminate\Database\Eloquent\ModelNotFoundException $e ) {
            return response()->json([
                'status'  => false,
                'data'    => null,
                'message' => 'No data found'
            ], 404);
        }
    } 

    public function save_sin(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'sin_number' => 'required',
            'front_picture'    => 'required|image'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status'  => false,
                'message' => 'Validation error',
                'errors'  =>$validator->errors()->all()
            ], 422);
        }

        global $userData;

        $data = [   
            'document_number' => $request->get('sin_number'),
            'provider_id'   => $userData->id
        ];

        $front_picture = $request->file('front_picture');
   
        $imageKit = new ImageKit(
            env('IMAGEKIT_PUBLIC_KEY'),
            env('IMAGEKIT_PRIVATE_KEY'),
            env('IMAGEKIT_URL_ENDPOINT')
        );

        $fileName = uniqid() . '.' . $front_picture->getClientOriginalExtension();
        $front_picture->move(public_path('uploads/'), $fileName);

        $uploadFile = $imageKit->uploadFile([
            'file' =>  fopen( public_path('uploads/'). $fileName, "r"),
            'fileName' => $fileName,
            'useUniqueFileName' => true
        ]);

        unlink( public_path('uploads/'). $fileName );

        $data['document_front_photo'] = $uploadFile->result->url;
        $data['document_back_photo'] = NULL;

        ProviderDocument::saveSinInfo($data);

        $user = User::find($userData->id);
        $user->onboarding_step_status = 'completed';
        $user->save();

        return response()->json([
            'status'  => true,
            'message' => 'Sin info added successfully'
        ]);
    }
}