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
   
<div id="top" style="background-image: url('{{ asset('public/assetfront/images/ast/1.jpg')}}'); ">

  <div class="top2_wrapper" id="top2">
    <div class="container">
      <div class="top2 clearfix">
      
        <div class="navbar navbar_ navbar-default">
         
          <div class="navbar-collapse navbar-collapse_ collapse">
            <ul class="nav navbar-nav sf-menu clearfix">
              <li ><a href="{{url('/')}}">
              Home 
          </a> </li>
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

    <div class="title1 animated" data-animation="fadeInUp" data-animation-delay="200">
    @if(Session::get('locale') == "en") 
      Objective
      @else
      Objectif
    @endif
     </div>

    <br><br>

    <div class="row">
    <div class="post-story-body" data-animation="fadeInUp" data-animation-delay="300">
    @if(Session::get('locale') == "en") 

        <p>Je Veux Services Inc is committed to creating a work environment in which each individual is treated with respect and dignity. Every member has the right to work in a professional atmosphere that takes equal employment opportunity seriously and prohibits unlawful discriminatory practices, including harassment. Therefore, Je Veux Services Inc expects all worker-to-worker relationships to be professional and free from bias and explicit harassment.</p>
        <p>Je Veux Services Inc will use all reasonable efforts to ensure that all affected persons know and are aware of these policies and are aware that any complaint in violation of these policies will be investigated and resolved in a fair and appropriate.</p>
        <p>Any worker who has questions or doubts about these policies should contact the Human Resources Manager or a member of the Personnel Practices Committee.</p>
        <p>JeVeux policies may not be used as a basis to exclude individuals of a particular gender, or any other protected characteristic, from participation in business or work-related social activities or discussions. In other words, no one should make the mistake of applying discrimination or exclusion to avoid allegations of harassment.</p>
        <p>Je Veux Services Inc has an obligation to provide equal employment opportunity without discrimination or harassment based on race, color, religion, sex, sexual orientation, identity or expression. gender, age, disability, marital status, citizenship, national origin, genetic information or any other characteristic protected by law</p>
        @else
        <p> Je Veux Services Inc s'engage a créer un environnement de travail dans lequel chaque individu est traité avec respect et dignité. Chaque membre a le droit de travailler dans une atmosphère professionnelle qui prend au serieux l'égalité des chances en matière d'emploi et interdit les pratiques discriminatoires illégales, y compris le harcèlement. Par conséquent, Je Veux Services Inc  s'attend à ce que toutes les relations entre les travailleurs soient professionnelles et exemptes de préjugés et de harcèlement explicite. </p>
        <p>Je Veux Services Inc appliquera tout les efforts raisonnables pour assurer que toutes les personnes concernées connaissent et soient au courant de ces politiques et soient conscientes que toute plainte en violation de ces politiques fera l'objet d'une enquête et sera résolue de manière juste et appropriée.  </p>
        <p>Tout travailleur qui a des questions ou des doutes au sujet de ces politiques doit communiquer avec le directeur des ressources humaines ou un membre du comité des pratiques en matière de personnel.  </p>
        <p> Les politiques de JeVeux ne peuvent pas être utilisées comme base pour exclure des individus d'un sexe particulier, ou de toute autre caractéristique protégée, de la participation à des activités ou discussions sociales liées aux affaires ou au travail. En d'autres mots, personne ne devrait commettre l'erreur d’appliquer de la discrimination ou l'exclusion pour éviter les allégations de harcèlement.  </p>
        <p> Je Veux Services Inc a comme obligation d'assurer l'égalité des chances en matière d'emploi sans discrimination ni harcèlement fondé sur la race, la couleur, la religion, le sexe, l'orientation sexuelle, l'identité ou l'expression de genre, l'âge, le handicap, l'état matrimonial, la citoyenneté, l'origine nationale, informations génétiques ou toute autre caractéristique protégée par la loi.  </p>
    @endif
    </div>
    </div>

  </div>
</div>
<div id="about">
  <div class="container">
    <div class="title1 animated" data-animation="fadeInUp" data-animation-delay="200">
    @if(Session::get('locale') == "en") 
      Reprisals 
      @else
      Représailles
    @endif</div>
    <br><br>
    <div class="row">
    <div class="post-story-body" data-animation="fadeInUp" data-animation-delay="300">
        <p>
    @if(Session::get('locale') == "en") 

        Je Veux Services Inc encourages the reporting of all perceived incidents of discrimination or harassment. Je Veux Services Inc. has a policy of promptly and thoroughly investigating such reports. Je Veux Services Inc prohibits retaliation against anyone who reports discrimination or harassment or participates in an investigation of such reports.
        @else
        Je Veux Services Inc encourage le signalement de tous les incidents perçus de discrimination ou de harcèlement. Je Veux Services Inc a pour politique d'enquêter rapidement et de manière approfondie sur ces signalements. Je Veux Services Inc interdit les représailles contre toute personne qui signale une discrimination ou un harcèlement ou qui participe à une enquête sur de tels signalements.
    @endif</p>
    </div>
    </div>
  </div>
</div>
<div id="about">
  <div class="container">
    <div class="title1 animated" data-animation="fadeInUp" data-animation-delay="200">
    @if(Session::get('locale') == "en") 
      Sexual harassment
      @else
      Harcèlement sexuel
    @endif </div>
    <br><br>
    <div class="row">
    <div class="post-story-body" data-animation="fadeInUp" data-animation-delay="300">
        <p>
    @if(Session::get('locale') == "en") 

        Sexual harassment is illegal discrimination under federal, state and local laws. For the purposes of this policy, "sexual harassment" is defined, as in the Equal Employment Opportunity Commission guidelines, as unwelcome sexual advances, requests for sexual favors and other behavior verbal or physical of a sexual nature.
        @else
        Le harcèlement sexuel est une une discrimination illégale en vertu des lois fédérales, étatiques et locales. Aux fins de cette politique, le « harcèlement sexuel » est défini, comme dans les lignes directrices de la Commission pour l'égalité des chances en matière d'emploi, comme des avances sexuelles importunes, des demandes de faveurs sexuelles et d'autres comportements verbaux ou physiques de nature sexuelle.
    @endif</p>
    </div>
    </div>
  </div>
</div>

<div id="about">
  <div class="container">
    <div class="title1 animated" data-animation="fadeInUp" data-animation-delay="200">
    @if(Session::get('locale') == "en") 
      Harassment
      @else
      Harcèlement
    @endif </div>
    <br><br>
    <div class="row">
    <div class="post-story-body" data-animation="fadeInUp" data-animation-delay="300">
    @if(Session::get('locale') == "en") 

        <p>
        Harassment based on any other protected characteristic is also strictly prohibited. Under this policy, harassment is verbal, written or physical behavior that denigrates or shows hostility or dislike towards a person because of their race, color, religion, gender, sexual orientation , gender identity or expression, national origin, age, disability, marital status, citizenship, genetic information or any other legally protected characteristic, or that of their parents, friends or associates, and who: (a) has the purpose or effect of creating an intimidating, hostile or offensive work environment, (b) has the purpose or effect of unreasonably interfering with an individual's job performance, or (c) otherwise interferes with employment opportunities of an individual.
        </p>
        <p>
        Harassing conduct includes negative epithets, slurs, or stereotypes; threatening, intimidating or hostile acts; disparaging jokes; and written or graphic material that denigrates or shows hostility or dislike of an individual or group that is posted on walls or elsewhere on employer premises or circulates in the workplace, during working hours or using Company equipment via email, telephone (including voice messages), text messages, social networking sites or other means.
        </p>
        @else
        <p>Le harcèlement sur la base de toute autre caractéristique protégée est également strictement interdit. En vertu de cette politique, le harcèlement est un comportement verbal, écrit ou physique qui dénigre ou montre de l'hostilité ou de l'aversion envers une personne en raison de sa race, sa couleur, sa religion, son sexe, son orientation sexuelle, son identité ou expression de genre, son origine nationale, son âge, son handicap, son état civil, sa citoyenneté, ses informations génétiques ou toute autre caractéristique protégée par la loi, ou celle de ses parents, amis ou associés, et qui : a) a pour objet ou pour effet de créer un environnement de travail intimidant, hostile ou offensant, b ) a pour objet ou pour effet d'interférer de manière déraisonnable avec le rendement au travail d'un individu, ou c) nuit autrement aux possibilités d'emploi d'un individu.</p>
        <p>
        La conduite harcelante comprend les épithètes, les insultes ou les stéréotypes négatifs ; actes menaçants, intimidants ou hostiles ; blagues dénigrantes; et matériel écrit ou graphique qui dénigre ou montre de l'hostilité ou de l'aversion envers un individu ou un groupe qui est placé sur les murs ou ailleurs dans les locaux de l'employeur ou qui circule sur le lieu de travail, pendant les heures de travail ou en utilisant l'équipement de l'entreprise par e-mail, téléphone (y compris la voix messages), des messages texte, des sites de réseaux sociaux ou d'autres moyens.
        </p>

    @endif
    </div>
    </div>
  </div>
</div>
<div id="about">
  <div class="container">
    <div class="title1 animated" data-animation="fadeInUp" data-animation-delay="200">
    @if(Session::get('locale') == "en") 
      Individuals and behaviors covered 
      @else
      Individus et comportements couverts
    @endif</div>
    <br><br>
    <div class="row">
    <div class="post-story-body" data-animation="fadeInUp" data-animation-delay="300">
        <p>
    @if(Session::get('locale') == "en") 

        These policies apply to all applicants and employees, whether related to the conduct of a colleague or someone not directly related to Je Veux Services Inc (e.g., an outside vendor, consultant or client).
        @else
        Ces politiques s'appliquent à tous les candidats et employés, qu'ils soient liés à la conduite d'un collègue ou d'une personne qui n'est pas directement liée à Je Veux Services Inc (par exemple, un fournisseur externe, un consultant ou un client).
    @endif </p>
    </div>
    </div>
  </div>
</div>
<div id="about">
  <div class="container">
    <div class="title1 animated" data-animation="fadeInUp" data-animation-delay="200">
    @if(Session::get('locale') == "en") 
      Report an incident of harassment, discrimination or retaliation
      @else
      Signaler un incident de harcèlement, de discrimination ou de représailles
    @endif</div>
    <br><br>
    <div class="row">
    <div class="post-story-body" data-animation="fadeInUp" data-animation-delay="300">
    @if(Session::get('locale') == "en") 

        <p>
        Je Veux Services Inc encourages the reporting of all perceived incidents of discrimination, harassment or retaliation, regardless of the identity or position of the offender.
        </p>
        <p>
        Individuals who believe they have been victims of such conduct should raise their concerns with their immediate supervisor, any member of the Personnel Practices Committee or Human Resources. See the complaints procedure outlined below.
        </p>
        <p>
        Je Veux Services Inc encourages people who believe they are victims of such behavior to promptly inform the offender that their behavior is unacceptable and to request that it be stopped. Most of the time, this single action will solve the problem. Je Veux Services Inc recognizes, however, that a person may prefer to pursue the situation through complaint procedures.
        </p>
        @else
        <p>Je Veux Services Inc encourage le signalement de tous les incidents perçus de discrimination, de harcèlement ou de représailles, quelle que soit l'identité ou la position du contrevenant. </p>
        <p>Les personnes qui croient avoir été victimes d'une conduite pareille devraient parler de leurs préoccupations avec leur superviseur immédiat, tout membre du comité des pratiques relatives au personnel ou les ressources humaines.. Voir la procédure de plainte décrite ci-dessous.</p>
        <p>Je Veux Services Inc encourage les gens qui pensent être victimes d'un tel comportement à informer rapidement le contrevenant que son comportement est inacceptable et à demander qu'il soit mis fin. La plus part du temps, cette seule action résoudra le soucis. Je Veux Services Inc reconnaît toutefois qu'une personne peut préférer poursuivre la situation par le biais de procédures de plainte</p>
    @endif
    </div>
    </div>
  </div>
</div>
<div id="about">
  <div class="container">
    <div class="title1 animated" data-animation="fadeInUp" data-animation-delay="200">Complaints procedure </div>
    <br><br>
    <div class="row">
    <div class="post-story-body" data-animation="fadeInUp" data-animation-delay="300">
        <p>
        Individuals who believe they have been the victim of behavior prohibited by this policy or who believe they have witnessed such behavior should discuss their concerns with their immediate supervisor, Human Resources, any member of the Personnel Practices Committee or any ombudsman
        </p>
        <p>Je Veux Services Inc encourages the prompt reporting of complaints or concerns so that prompt and constructive action can be taken before relationships become irreparably strained. Therefore, although no fixed reporting period has been established, early reporting and intervention have proven to be the most effective method of resolving real or perceived incidents of harassment.</p>
        <p>Any reported allegation of harassment, discrimination or retaliation will be promptly investigated. The investigation may include individual interviews with the parties involved and, if necessary, with persons who may have observed the alleged behavior or have other relevant information.</p>
        <p>Je Veux Services Inc will maintain confidentiality throughout the investigation process to the extent consistent with proper investigation and appropriate corrective action.</p>
        <p>Retaliation against any person for reporting harassment or discrimination or for participating in the investigation of a complaint of harassment or discrimination is a serious violation of this policy and, like the harassment or discrimination itself, will subject to disciplinary action.</p>
        <p>Acts of retaliation must be reported immediately and will be promptly investigated and resolved.</p>
        <p>Any misconduct that constitutes harassment, discrimination or retaliation will be dealt with appropriately. Reactive action may include, for example, training, referral to counsel, or disciplinary action such as a warning, reprimand, denial of a promotion or salary increase, reassignment, temporary suspension without pay or termination, as Je Veux Services Inc deems appropriate under the Terms.</p>
        <p>If a party to a complaint disagrees with its resolution, that party may appeal to the Executive Director or Chief Operating Officer of Je Veux Services Inc.</p>
        <p>False and malicious complaints of harassment, discrimination, or retaliation (as opposed to complaints that, even if erroneous, are made in good faith) may be subject to appropriate disciplinary action.</p>
    </div>
    </div>
  </div>
</div>


@stop