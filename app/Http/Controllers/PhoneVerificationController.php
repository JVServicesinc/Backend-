<?php

namespace App\Http\Controllers;

use App\Models\PhoneVerification;
use App\Http\Requests\StorePhoneVerificationRequest;
use App\Http\Requests\UpdatePhoneVerificationRequest;

class PhoneVerificationController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        //
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \App\Http\Requests\StorePhoneVerificationRequest  $request
     * @return \Illuminate\Http\Response
     */
    public function store(StorePhoneVerificationRequest $request)
    {
        //
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\PhoneVerification  $phoneVerification
     * @return \Illuminate\Http\Response
     */
    public function show(PhoneVerification $phoneVerification)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  \App\Models\PhoneVerification  $phoneVerification
     * @return \Illuminate\Http\Response
     */
    public function edit(PhoneVerification $phoneVerification)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \App\Http\Requests\UpdatePhoneVerificationRequest  $request
     * @param  \App\Models\PhoneVerification  $phoneVerification
     * @return \Illuminate\Http\Response
     */
    public function update(UpdatePhoneVerificationRequest $request, PhoneVerification $phoneVerification)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\PhoneVerification  $phoneVerification
     * @return \Illuminate\Http\Response
     */
    public function destroy(PhoneVerification $phoneVerification)
    {
        //
    }
}
