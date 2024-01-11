<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Coupon;

class CouponController extends Controller
{
    public function index()
    {
        return view('coupon.index', [
            'coupons' =>  Coupon::getCoupons()
        ]);
    }

    public function create()
    {
        return view('coupon.create');
    }

    public function store(Request $request)
    {
        $request->validate([
            'code' => 'required|max:255',
            'discount_type' => 'required',
            'discount' => 'required',
            'expire_date' => 'required',
            'image'       => 'required'
        ], [
            'code.required' => 'Coupon code required',
            'discount_type.required' => 'Discount is required',
            'expire_date.required' => 'Expire date is required',
        ]);

        $data = $request->all();

        if($request->file('image')){
			$imagekitFile = imageKitFileUpload(
                $request->file('image')
            );

            if( $imagekitFile !== false ) {
                $data['image']= $imagekitFile;
            }
		}

        Coupon::create($data);

        return redirect(route('coupon.index'))->withSuccess('Coupon added successfully');
    }

    public function edit($coupon_id)
    {
        $coupon = Coupon::findOrFail($coupon_id);

        return view('coupon.edit', [
            'coupon'   => $coupon,
        ]);
    }

    public function update(Request $request, $coupon_id)
    {
        $request->validate([
            'code' => 'required|max:255',
            'discount_type' => 'required',
            'discount' => 'required',
            'expire_date' => 'required'
        ], [
            'code.required' => 'Coupon code required',
            'discount_type.required' => 'Discount is required',
            'expire_date.required' => 'Expire date is required',
        ]);

        $data = [
            'code' => $request->input('code'),
            'discount_type' => $request->input('discount_type'),
            'discount' => $request->input('discount'),
            'expire_date' => $request->input('expire_date'),
            'desp' => $request->input('desp')
        ];

        if($request->file('image')){
			$imagekitFile = imageKitFileUpload(
                $request->file('image')
            );

            if( $imagekitFile !== false ) {
                $data['image']= $imagekitFile;
            }
		}

        Coupon::where('id', $coupon_id)->update($data);

        return redirect(route('coupon.index'))->withSuccess('Coupon updated successfully');
    }

    public function delete($coupon_id)
    {
        $coupon = Coupon::findOrFail($coupon_id);
        $coupon->deleted_at = date('Y-m-d H:i:s');
        $coupon->save();

        return redirect(route('coupon.index'))->withSuccess('Coupon deleted successfully');
    }
}
