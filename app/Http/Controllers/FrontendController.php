<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Session;
Use Redirect;
use Illuminate\Support\Facades\Hash;

class FrontendController extends Controller
{
    public function index(){
		return redirect('login');
    }
    public function about(){
		
        return view('frontend.about');
    }
    public function customer_review(){
		
        return view('frontend.customer_review');
    }
    public function anti_diccriminatory_policy(){
		
        return view('frontend.anti_diccriminatory_policy');
    }
    public function customer_satisfaction_policy(){
		
        return view('frontend.customer_satisfaction_policy');
    }
    public function contact_us(){
		
        return view('frontend.contact_us');
    }
    public function switchLang($lang)
    {

        //{{ Session::get('locale')}}
        Session::put('locale', $lang);
    
        return Redirect::back();
    }
}
