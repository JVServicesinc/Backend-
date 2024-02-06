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
   
<div id="top" style="background-image: url('{{ asset('public/assetfront/images/ast/3.jpg')}}'); ">
  <div class="top2_wrapper" id="top2">
    <div class="container">
      <div class="top2 clearfix">
      
        <div class="navbar navbar_ navbar-default">
          <?php 
             $lan = "en";
          ?>
          <div class="navbar-collapse navbar-collapse_ collapse">
            <ul class="nav navbar-nav sf-menu clearfix">
              <li ><a href="{{url('/')}}"> Home </a> </li>
              <li class="sub-menu sub-menu-1 active"><a href="{{url('about')}}">About us</a></li>
              <li><a href="{{url('customer_review')}}">Customer Review</a></li>
              <!-- <li><a href="{{url('anti_diccriminatory_policy')}}">Anti discriminatory policy</a></li> -->
              <li><a href="{{url('customer_satisfaction_policy')}}">Customer satisfaction policy</a></li>
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
      
    ABOUT US
@else
À PROPOS DE NOUS
@endif

   </div>

    <br><br>

    <div class="row">
    <div class="title2 animated" data-animation="fadeInUp" data-animation-delay="300">
    @if(Session::get('locale') == "en") 
      
    How We do it 
JeVeux services provides a platform that allows skilled and experienced professionals to connect with users looking for 
specific services. All the professionals, though experienced and skilled, undergo intensive training modules before being 
allowed to list their services on the platform. Once on the platform, our match-making algorithm identifies professionals 
who are closest to the users' requirements and available at the requested time and date.

@else
Comment nous le faisons
JeVeux services fournit une plate-forme qui permet aux professionnels qualifiés et expérimentés de se connecter avec les utilisateurs à la recherche de
prestations spécifiques. Tous les professionnels, bien qu'expérimentés et compétents, suivent des modules de formation intensifs avant d'être
autorisés à répertorier leurs services sur la plateforme. Une fois sur la plateforme, notre algorithme de match-making identifie les professionnels
les plus proches des besoins des utilisateurs et disponibles à l'heure et à la date demandées.


    @endif

</div>
    </div>

    <br><br>

    <div class="macs animated" data-animation="fadeInUp" data-animation-delay="600"><img src="images/macs.png" alt="" class="img-responsive"></div>



  </div>
</div>





@stop