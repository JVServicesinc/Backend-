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
   
<div id="top" style="background-image: url('{{ asset('public/assetfront/images/ast/6.jpg')}}'); ">
  <div class="top2_wrapper" id="top2">
    <div class="container">
      <div class="top2 clearfix">
      
        <div class="navbar navbar_ navbar-default">
          <?php 
             $lan = "en";
          ?>
          <div class="navbar-collapse navbar-collapse_ collapse">
            <ul class="nav navbar-nav sf-menu clearfix">
              <li><a href="{{url('/')}}">
              Home 
          </a> </li>
              <li ><a href="{{url('about')}}">About us</a></li>
              <li><a href="{{url('customer_review')}}">Customer Review</a></li>
              <!-- <li><a href="{{url('anti_diccriminatory_policy')}}">Anti discriminatory policy</a></li> -->
              <li class="sub-menu sub-menu-1 active"><a href="{{url('customer_satisfaction_policy')}}">Customer satisfaction policy</a></li>
              <li><a href="{{url('contact_us')}}">Contacts Us</a></li>
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

</br>
</br>
</br>

    <div id="about">
        <div class="container">
            <div class="title1 animated" data-animation="fadeInUp" data-animation-delay="200">
    @if(Session::get('locale') == "en") 
              
            Customer satisfaction policy
            @else
            Polities de satisfaction client
    @endif</div>
            <br><br>
                <div class="row">
                    <div class="title2 animated" data-animation="fadeInUp" data-animation-delay="300">
              @if(Session::get('locale') == "en") 

                        <p>If you’re not pleased with our services or if you did not have a good experience you will be refunded fully.</p>
                        <p>You must provide a detail description of your experience with our vendor and why we did not meet your expectations.</p>
                        @else
                        <p>Si vous n'êtes pas satisfait de notre service ou si vous n'avez pas eu une bonne expérience avec notre jeveux professionnel vous serez intégralement remboursé.</p>
                        <p>Vous devez fournir use description détaillèe de voter expérience avec notre fournisseur et la raison pour laquelle.</p>
    @endif
                    </div>
                </div>
            <br><br>
        </div>
    </div>




@stop