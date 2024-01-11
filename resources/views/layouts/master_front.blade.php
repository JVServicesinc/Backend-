

@yield('contentfront')


<div id="features">
  <div class="container">

    <div class="title1 animated" data-animation="fadeInUp" data-animation-delay="200">JeVeux Services</div>

    

    <br><br>

    <div class="features">
      <div class="row">
        <div class="col-sm-4">
          <div class="left_box">
            <div class="features1 animated" data-animation="fadeInLeft" data-animation-delay="400">
              <div class="ic1"><i class="fa fa-apple"></i></div>
              <div class="txt1"></div>
              <div class="txt2"></div>
            </div>
            <div class="features1 animated" data-animation="fadeInLeft" data-animation-delay="500">
              <div class="ic1"><i class="fa fa-android"></i></div>
              <div class="txt1"></div>
              <div class="txt2"></div>
            </div>
            <div class="features1 animated" data-animation="fadeInLeft" data-animation-delay="600">
              <div class="ic1"><i class="fa fa-apple"></i></i></div>
              <div class="txt1"></div>
              <div class="txt2"></div>
            </div>
          </div>
        </div>
        <div class="col-sm-4 col-sm-push-4">
          <div class="right_box">
            <div class="features1 animated" data-animation="fadeInRight" data-animation-delay="400">
              <div class="ic1"><i class="fa fa-android"></i></div>
              <div class="txt1"></div>
              <div class="txt2"></div>
            </div>
            <div class="features1 animated" data-animation="fadeInRight" data-animation-delay="500">
              <div class="ic1"><i class="fa fa-apple"></i></div>
              <div class="txt1"></div>
              <div class="txt2"></div>
            </div>
            <div class="features1 animated" data-animation="fadeInRight" data-animation-delay="600">
              <div class="ic1"><i class="fa fa-android"></i></div>
              <div class="txt1"></div>
              <div class="txt2"></div>
            </div>
          </div>
        </div>
        <div class="col-sm-4 col-sm-pull-4">
          <div class="center_box animated" data-animation="fadeInUp" data-animation-delay="700"><img src="{{asset('public/assetfront/images/iphone.png')}}" alt="" class="img-responsive"></div>
          <div class="center_box animated" data-animation="fadeInUp" data-animation-delay="700"><img src="{{asset('public/assetfront/images/play_store.png')}}" alt="" class="img-responsive"></div>
          <div class="title2 animated" data-animation="fadeInUp" data-animation-delay="200"><a href="https://play.google.com/store/apps/details?id=com.jvservice.user"> JeVeux Services User </a></div>
          <div class="title2 animated" data-animation="fadeInUp" data-animation-delay="200"><a href="https://play.google.com/store/apps/details?id=com.jvservice.provider"> JeVeux Services Professional </a></div>
          <br>

          <div class="center_box animated" data-animation="fadeInUp" data-animation-delay="700"><img src="{{asset('public/assetfront/images/app_store.png')}}" alt="" class="img-responsive"></div>
          <div class="title2 animated" data-animation="fadeInUp" data-animation-delay="200"><a href="https://apps.apple.com/ca/app/jeveux-services-user/id1624707290"> JeVeux Services User </a></div>
          <div class="title2 animated" data-animation="fadeInUp" data-animation-delay="200"><a href="https://apps.apple.com/ca/app/jeveux-services-professional/id1624830876"> JeVeux Services Professional </a></div>

        </div>
        
      </div>
    </div>

  </div>
</div>
<!-- <div class="row">
        <div class="col-sm-4">
        </div>
</div> -->
<!-- <div class="bot1" style="background-image: url('{{ asset('public/assetfront/images/ast/7.jpg')}}');  background-size: cover; background-repeat: repeat-y; background-position: center ;">
</div> -->
<div class="bot1" >
  <div class="container">
    <div class="row">
      <div class="col-sm-6">
        <div class="bot_title">footer menu</div>
        <ul class="bot_menu clearfix">
            <li><a href="{{url('/')}}">Home</a></li>
            <li><a href="{{url('about')}}">About us</a></li>
            <li><a href="{{url('customer_review')}}">Customer Review </a></li>
            <li><a href="{{url('anti_diccriminatory_policy')}}">Anti discriminatory policy</a></li>
            <li><a href="{{url('customer_satisfaction_policy')}}">Customer satisfaction policy</a></li>
            <li><a href="{{url('contact_us')}}">Contact us</a></li>
          </ul>
      </div>
      <div class="col-sm-6">
        <div class="bot_title">company address</div>
        <div class="smallicons clearfix">
          <i class="fa fa-map-o"></i><span>5268, Rue saranac<br>Montreal (Quebec) H3W2G6 Canada</span>
        </div>
        <!-- <div class="smallicons clearfix">
          <i class="fa fa-phone"></i><span>Phone: +1 (917) 3386810</span>
        </div> -->
        <div class="smallicons clearfix">
          <i class="fa fa-envelope-o"></i><span>Email: <a href="#">Jv.Jeveux@gmail.com</a></span>
        </div>
        <!-- <div class="smallicons clearfix">
          <i class="fa fa-print"></i><span>FAX: +1 (917) 3386810</span>
        </div> -->
      </div>
    
    </div>
  </div>
</div>

<div class="bot2">
  <div class="container">
    <!-- copyright &copy; 2020 web technology s.r.o. All Rights Reserved -->
  </div>
</div>






</div>
<script src="{{ asset('public/assetfront/js/bootstrap.min.js')}}"></script>
</body>

<!-- Mirrored from template-preview.com/bootstrap-templates/black-white/Black-version/index.html by HTTrack Website Copier/3.x [XR&CO'2014], Mon, 25 Jul 2022 12:20:21 GMT -->
</html>