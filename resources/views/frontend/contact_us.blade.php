@extends('layouts/master_front')

@section('contentfront')
<!DOCTYPE html>
<html lang="en">
<head>
<title> JeVeux Services   </title>

<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<meta name="author" content="Your name">
<link rel = "icon" href = "{{ asset('public/assetfront/images/logo.png')}}"    type = "image/x-icon">
<link href="{{ asset('public/assetfront/css/bootstrap.css')}}" rel="stylesheet">
<link href="{{ asset('public/assetfront/css/font-awesome.css')}}" rel="stylesheet">
<link href="{{ asset('public/assetfront/css/prettyPhoto.css')}}" rel="stylesheet">
<link href="{{ asset('public/assetfront/css/animate.css')}}" rel="stylesheet">
<link href="{{ asset('public/assetfront/css/style.css')}}" rel="stylesheet">

<script src="{{ asset('public/assetfront/js/jquery.js')}}"></script>
<script src="{{ asset('public/assetfront/js/jquery-migrate-1.2.1.min.js')}}"></script>
<script src="{{ asset('public/assetfront/js/jquery.easing.1.3.js')}}"></script>
<script src="{{ asset('public/assetfront/js/superfish.js')}}"></script>

<script src="{{ asset('public/assetfront/js/yjsg.yjsgroundprogress.js')}}"></script>

<script src="{{ asset('public/assetfront/js/jquery.sticky.js')}}"></script>

<script src="{{ asset('public/assetfront/js/jquery.queryloader2.js')}}"></script>

<script src="{{ asset('public/assetfront/js/jquery.appear.js')}}"></script>

<script src="{{ asset('public/assetfront/js/jquery.ui.totop.js')}}"></script>

<script src="{{ asset('public/assetfront/js/jquery.caroufredsel.js')}}"></script>
<script src="{{ asset('public/assetfront/js/jquery.touchSwipe.min.js')}}"></script>

<script src="{{ asset('public/assetfront/js/jquery.parallax-1.1.3.resize.js')}}"></script>

<script src="{{ asset('public/assetfront/js/SmoothScroll.js')}}"></script>

<script src="{{ asset('public/assetfront/js/jquery.prettyPhoto.js')}}"></script>

<script src="{{ asset('public/assetfront/js/scripts.js')}}"></script>

</head>
<body class="onepage front" data-spy="scroll" data-target="#top" data-offset="81">

<!-- <div id="load"></div> -->

<div id="main">

<div id="home">
   
<div id="top" style="background-image: url('{{ asset('public/assetfront/images/ast/4.jpg')}}'); ">

  <div class="top2_wrapper" id="top2">
    <div class="container">
      <div class="top2 clearfix">
      
        <div class="navbar navbar_ navbar-default">
          <?php 
             $lan = "en";
          ?>
          <div class="navbar-collapse navbar-collapse_ collapse">
            <ul class="nav navbar-nav sf-menu clearfix">
              <li ><a href="{{url('/')}}">
              Home 
          </a> </li>
              <li><a href="{{url('about')}}">About us</a></li>
              <li><a href="{{url('customer_review')}}">Customer Review</a></li>
              <!-- <li><a href="{{url('anti_diccriminatory_policy')}}">Anti discriminatory policy</a></li> -->
              <li><a href="{{url('customer_satisfaction_policy')}}">Customer satisfaction policy</a></li>
              <li class="sub-menu sub-menu-1 active"><a href="{{url('contact_us')}}">Contacts Us</a></li>
              <li class="sub-menu sub-menu-1 active"><a href="#">Language<em></em></a>
                <ul>
                  <li><a href="{{url('lang','en')}}">English</a></li>
                  <li><a href="{{url('lang','fr')}}">French</a></li>
                </ul>
              </li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  </div>

  </div>
</div>

<div id="content">
  <div class="container">

    <h1>
    @if(Session::get('locale') == "en") 
    We would love to hear back from you with any concern regarding our service, through our email support team
      @else

    Nous serious ravis d’avoir de vos nouvelles concernant nos service via notre équipe d’assistance par e-mail.
    @endif
    </h1>
<br>
<br>
<br>
    <div class="row">
      <div class="col-sm-8">

        <div class="content-part">
          <div id="note"></div>
          <div id="fields">
            <form id="ajax-contact-form" class="form-horizontal" action="javascript:alert('success!');">
              <div class="row">
                <div class="col-sm-6">
                  <div class="form-group">
                      <label for="inputName">Your Name</label>
                      <input type="text" class="form-control" id="inputName" name="name" value="Full Name" onBlur="if(this.value=='') this.value='Full Name'" onFocus="if(this.value =='Full Name' ) this.value=''">
                  </div>
                </div>
                <div class="col-sm-6">
                  <div class="form-group">
                      <label for="inputEmail">Email</label>
                      <input type="text" class="form-control" id="inputEmail" name="email" value="E-mail address" onBlur="if(this.value=='') this.value='E-mail address'" onFocus="if(this.value =='E-mail address' ) this.value=''">
                  </div>
                </div>
              </div>

              <div class="row">
                <div class="col-sm-12">
                  <div class="form-group">
                      <label for="inputSubject">Subject</label>
                      <input type="text" class="form-control" id="inputSubject" name="subject" value="Subject" onBlur="if(this.value=='') this.value='Subject'" onFocus="if(this.value =='Subject' ) this.value=''">
                  </div>
                </div>
              </div>

              <div class="row">
                <div class="col-sm-12">
                  <div class="form-group">
                      <label for="inputMessage">Your Message</label>
                      <textarea class="form-control" rows="10" id="inputMessage" name="content" onBlur="if(this.value=='') this.value='Message'"
                                  onFocus="if(this.value =='Message' ) this.value=''">Message</textarea>
                  </div>
                </div>
              </div>              
              <button type="submit" class="btn-default btn-cf-submit">Send message</button>
              <br>
            </form>
          </div>
        </div>
        <br>
      </div>
      <div class="col-sm-4">

        <div class="sidebar-part">
          <h5>address</h5>
          <p>
          5268, Rue saranac<br>
          Montreal (Quebec) H3W2G6 Canada
          </p>

          <div class="hl2"></div>

          <h5>contact info</h5>

          <p>
            E-mail: Jv.Jeveux@gmail.com
 
          </p>

          <!-- <div class="hl2"></div>

          <h5>working hours</h5>

          <p>
            Monday to Friday from 09.00 to 18.00
          </p>
        </div> -->

      </div>
    </div>
  </div>
</div>

@stop