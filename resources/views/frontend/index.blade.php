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
   
<div id="top" style="background-image: url('{{ asset('public/assetfront/images/ast/2.jpg')}}'); ">
  <div class="top2_wrapper" id="top2">
    <div class="container">
      <div class="top2 clearfix">
      
        <div class="navbar navbar_ navbar-default">
          <?php 
             $lan = "en";
          ?>
          <div class="navbar-collapse navbar-collapse_ collapse">
            <ul class="nav navbar-nav sf-menu clearfix">
              <li class="sub-menu sub-menu-1 active"><a href="{{url('/')}}">  Home  </a> </li>
              <li><a href="{{url('about')}}">About us</a></li>
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
<div id="homes">
  <div class="container">

    <div class="title1 animated" data-animation="fadeInUp" data-animation-delay="200">HELLO, WELCOME TO JeVeux Services </div>

    <br><br>

    <div class="row">
    <div class="title2 animated" data-animation="fadeInUp" data-animation-delay="300">
    @if(Session::get('locale') == "en") 

      JeVeux Services Inc. is Canada’s largest online home services platform. Launched in 2022, JeVeux today operates in the province of Quebec. The platform helps customers book reliable & high 
      quality services, beauty treatments, massages, haircuts, home cleaning, handymen, appliance repair, painting, pest 
      control and more - delivered by trained professionals conveniently at home. JeVeux’s vision is to empower 
      millions of professionals worldwide to deliver services at home like never experienced before. 
      @else
      JeVeux Services Inc. est la plus grande plateforme de services à domicile en ligne au Canada. Lancé en 2022, JeVeux opère aujourd'hui dans la province de Québec. La plate-forme aide les clients à réserver de manière fiable et élevée
      prestations de qualité, soins esthétiques, massages, coupes de cheveux, ménage, bricoleurs, dépannage électroménager, peinture, antiparasitaire
      contrôle et plus - livrés par des professionnels formés commodément à la maison. La vision de JeVeux est de responsabiliser
      des millions de professionnels dans le monde entier pour fournir des services à domicile comme jamais auparavant.

    @endif

</div>
    </div>

    <br><br>

    <div class="macs animated" data-animation="fadeInUp" data-animation-delay="600"><img src="images/macs.png" alt="" class="img-responsive"></div>



  </div>
</div>



@stop