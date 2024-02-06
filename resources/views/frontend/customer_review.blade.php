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
   
<div id="top" style="background-image: url('{{ asset('public/assetfront/images/ast/5.jpg')}}'); ">
  <div class="top2_wrapper" id="top2">
    <div class="container">
      <div class="top2 clearfix">
      
        <div class="navbar navbar_ navbar-default">
          <?php 
             $lan = "en";
          ?>
          <div class="navbar-collapse navbar-collapse_ collapse">
            <ul class="nav navbar-nav sf-menu clearfix">
              <li><a href="{{url('/')}}">           Home           </a> </li>
              <li><a href="{{url('about')}}">About us</a></li>
              <li class="sub-menu sub-menu-1 active"><a href="{{url('customer_review')}}">Customer Review</a></li>
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
      Online customer reviews
    @else
    Avis clients en ligne
    @endif
  
  </div>

    <br><br>

    <div class="row">
    <div class="title2 animated" data-animation="fadeInUp" data-animation-delay="300">
    @if(Session::get('locale') == "en") 
      
    Online customer reviews are a great way to attract and hold a consumer's attention, as well as increase sales. The importance of customer reviews is prodigious because they are very useful for the choice of our consumers in terms of professionals and, moreover, encourage our service providers to stand out with regard to their performance.
    @else
    Les avis clients en ligne sont un excellent moyen d'attirer et de retenir l'attention d'un consommateur, ainsi que d'augmenter les ventes. L'importance des avis clients est prodigieuse car ils sont très utiles pour le choix de nos consommateurs en matière de professionnels et, en outre, encouragent nos prestataires à se démarquer en ce qui concerne leurs performances.
    @endif
</div>
    </div>    <br><br>    
    <div class="row">
      <div class="col-sm-4">
        <div class="about1 clearfix animated" data-animation="fadeInLeft" data-animation-delay="300">
          <a href="#">
            <div class="c1"><i class="fa fa-desktop"></i></div>
            <div class="txt1">
              @if(Session::get('locale') == "en") 

              Better understand your customer and improve customer service.
              @else
              Mieux comprendre ton client et améliorer the service à la clientèle.
              @endif
            </div>
            <div class="txt2">
             @if(Session::get('locale') == "en") 
            Analyzing the comments left by your user, helps you as a company to understand the overall satisfaction of this one. They provided us with feedback on what the customer really wants.
            @else
            Analyzer les commentaires laissé par votre utilisateur, vous aider en tant qu’entreprise à comprendre la satisfaction globale de celui-ci. Ils nous apportent un retour d’information sur ce que le client désire vraiment.
            @endif
        </div>

          </a>
        </div>
      </div>
      <div class="col-sm-4">
        <div class="about1 clearfix animated" data-animation="fadeInUp" data-animation-delay="400">
          <a href="#">
            <div class="c1"><i class="fa fa-life-ring"></i></div>
            <div class="txt1">
              @if(Session::get('locale') == "en") 
                Credibility and social proof
              @else
              Crédibilité et preuve sociale
              @endif
            </div>
            <div class="txt2">
            @if(Session::get('locale') == "en") 
              Without doubt, we have been social beings since time immemorial and are interested in knowing what the other thinks of it before embarking on the unknown. Such as when we ask our friends and family for recommendations, sites with a feedback page allow us to do the same with people with the relevant experience.
            
              @else
              Sans doute, nous sommes des êtres sociaux depuis le temps des temps et, sommes intéressé par connaître ce que l’autre en pense avant de se lancer à l’inconnu. Tel que quand on demande des recommandations à nos amis et notre famille, les sites possédant une page de commentaires nous permet de faire de même avec des gens ayant vécu l’expérience pertinente. 
              @endif
            </div>
             
              
            </a>
        </div>
      </div>
      
      <div class="col-sm-4">
        <div class="about1 clearfix animated" data-animation="fadeInRight" data-animation-delay="500">
          <a href="#">
            <div class="c1"><i class="fa fa-laptop"></i></div>
            <div class="txt1">
              @if(Session::get('locale') == "en") 
              Compete with experience to save margins
              @else
              Compétition avec expérience pour sauver des marges
              @endif
            </div>
            <div class="txt2">
            @if(Session::get('locale') == "en") 

              The comment page allows new users to compare themselves with more experienced users and potentially gain positive visibility towards potential customers and their expectations. Look at it this way, would you rather get the services of someone with a 3 out of 5 star rating, or someone with a 5 out of 5 star performance? So, you just took the weight off the discounts and the price!
         
              @else
              La page de commentaire permet aux nouveaux utilisateurs de se comparer avec des utilisateurs plus expérimentés et potentiellement gagner une visibilité positive envers les potentiels clients et leurs expectations. Regardez-le de cette façon, préfériez-vous obtenir les services de quelqu’un ayant une côte de 3 étoiles sur 5, ou de quelqu’un avec un rendement de 5 étoiles sur 5? Ainsi, vous venez d’enlever le poids sur les rabais et le prix!
              @endif 
              </div>  </a>
        </div>
      </div>

      <div class="col-sm-4">
        <div class="about1 clearfix animated" data-animation="fadeInRight" data-animation-delay="500">
          <a href="#">
            <div class="c1"><i class="fa fa-laptop"></i></div>
            <div class="txt1">
            @if(Session::get('locale') == "en") 
              Enables consumers to have a voice and create loyalty from them
              @else
            	Permet aux consommateurs d’avoir une voix et créer de la loyauté venant de ceux-ci
              @endif</div>
            <div class="txt2">
               @if(Session::get('locale') == "en") 
              Customers who take the time to leave an online review for your business are far more likely to feel loyalty towards you and keep coming back. Through the act of leaving a review and establishing a relationship with your business, this allows consumers to feel they have a voice, whether they are behind a computer screen or on their cell phones because they have their data. the ability to create impact in a positive and meaningful way.
              @else
              Les clients qui prennent le temps de laisser un commentaire en ligne pour votre commerce son de loins plus propices à sentir une certaine loyauté envers vous et continuerons à revenir. À travers l’Acte de laisser un commentaire et d’établir une relation avec votre commerce, ceci permet aux consommateurs de sentir qu’ils ont une voix, malgré qu’ils soient derrière un écran d’ordinateur ou leurs cellulaires car ont leurs donne l’habilité de créer un impact d’une manière positive et valable 
              @endif
              </div>
            </a>
        </div>
      </div>
      <div class="col-sm-4">
        <div class="about1 clearfix animated" data-animation="fadeInRight" data-animation-delay="500">
          <a href="#">
            <div class="c1"><i class="fa fa-laptop"></i></div>
            <div class="txt1">
            @if(Session::get('locale') == "en") 
              Improve Rankings
              @else
              Améliorer les classements
              @endif</div>
            <div class="txt2">
             @if(Session::get('locale') == "en") 
              Reviews seem to be the most important ranking factor in local search. This helps professionals rank well, even if they have low quality link profiles.
              According to SEJ, “Pages with reviews that mention a keyword and/or city name have been shown to have higher rankings in Google's local pack. At a high level, having a keyword you're trying to rank for and a mention of a city you work in to rank for, in reviews, has a strong correlation to Google My Business results. high level ".
              @else
              Les avis semblent être le facteur de classement le plus important dans la recherche locale. Cela aide les professionnels à bien se classer, même s’ils ont des profils de liens de faible qualité.
Selon SEJ, « les pages avec des avis qui mentionnent un mot-clé et/ou le nom d'une ville, se sont avérées avoir des classements plus élevés dans le pack local de Google. À un niveau élevé, le fait d'avoir un mot-clé pour lequel vous essayez de vous classer et une mention d'une ville dans laquelle vous travaillez pour vous classer, dans les avis, a une forte corrélation avec les résultats Google My Business de haut niveau ».

              @endif
</div>
          </a>
        </div>
      </div>
      <div class="col-sm-4">
        <div class="about1 clearfix animated" data-animation="fadeInRight" data-animation-delay="500">
          <a href="#">
            <div class="c1"><i class="fa fa-laptop"></i></div>
            <div class="txt1">
            @if(Session::get('locale') == "en") 
              Consumers do your marketing for you
              @else
            Les consommateurs font votre marketing pour vous
              @endif
            </div>
            <div class="txt2">
            @if(Session::get('locale') == "en") 
            Positive reviews of online businesses are worth a lot and can provide vendors with benefits that a simple marketing campaign cannot. In a nutshell, they are like micro-marketing campaigns that continue to work long after the online review has been posted, providing a consistent positive image to potential customers and creating continued brand awareness that benefits the business as well as professional in the short and long term.
            @else
            Les avis positifs sur les professionnels en ligne valent beaucoup et peuvent offrir à celui-ci des avantages qu'une simple campagne de marketing ne peut pas offrir. En un mot, ce sont comme des micro-campagnes de marketing qui continuent de fonctionner longtemps après la publication de l'avis en ligne, fournissant ainsi une image positive constante aux clients potentiels et créant une notoriété continue de la marque qui profite à l'entreprise autant qu’au professionnel à court et à long terme.
              @endif
              </div></a>
        </div>
      </div>
      <div class="col-sm-4">
        <div class="about1 clearfix animated" data-animation="fadeInRight" data-animation-delay="500">
          <a href="#">
            <div class="c1"><i class="fa fa-laptop"></i></div>
            <div class="txt1">
            @if(Session::get('locale') == "en") 
              Reviews generate more reviews
            @else
            	Les avis génèrent plus d'avis
              @endif
            </div>
            <div class="txt2">
            @if(Session::get('locale') == "en") 
              When a vendor has already received reviews online, she encourages other visitors to leave their own reviews. The mere appearance of multiple reviews seems to be enough to give new customers the incentive and confidence to submit their own opinion about the services coming from this one.
              @else
              Lorsqu'un professionnel a déjà reçu des avis en ligne, elle encourage les autres visiteurs à laisser leurs propres commentaires. La simple apparition de plusieurs avis semble être suffisante pour donner aux nouveaux clients l'incitation et la confiance nécessaires pour soumettre leur propre opinion sur les services venant de celui-ci.
              @endif </div>
            </a>
        </div>
      </div>




    </div>


  </div>
</div>

@stop