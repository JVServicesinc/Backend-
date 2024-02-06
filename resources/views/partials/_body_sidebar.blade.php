<div class="iq-sidebar sidebar-default">
    <div class="iq-sidebar-logo d-flex align-items-end justify-content-between">
        <a href="{{ route('home') }}" class="header-logo">
            <img src="{{ getSingleMedia(settingSession('get'),'site_logo',null) }}" class="img-fluid rounded-normal light-logo site_logo_preview" alt="logo">
            <img src="{{ getSingleMedia(settingSession('get'),'site_logo',null) }}" class="img-fluid rounded-normal darkmode-logo site_logo_preview" alt="logo">
            <span class="white-space-no-wrap">{{ ucfirst(str_replace("_"," ",auth()->user()->user_type)) }}</span>
        </a>
        <div class="side-menu-bt-sidebar-1">
            <svg xmlns="http://www.w3.org/2000/svg" class="text-light wrapper-menu" width="30" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
            </svg>
        </div>
    </div>
    <div class="data-scrollbar" data-scroll="1">
        <nav class="iq-sidebar-menu">
            <ul id="iq-sidebar-toggle" class="side-menu">
                <li>
                    <a class="nav-link" href="{{ url('/') }}/home">
                        <i class="ri-dashboard-line"></i>
                        <span>Dashboard</span>
                    </a>
                </li>
                <!-- <li class="">
                    <a data-toggle="collapse" role="button" aria-expanded="false" aria-controls="collapseExample" class="" href="#category">
                        <i class="ri-shopping-basket-2-line"></i>
                        <span>Category</span>
                        <svg xmlns="http://www.w3.org/2000/svg" class="svg-icon iq-arrow-right arrow-active" height="14" width="15" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
                        </svg>
                    </a>
                    <ul class="submenu collapse  " id="category">
                        <li class="sidebar-layout">
                            <a class="nav-link" href="{{ url('/') }}/category">
                                <i class="ri-list-unordered"></i>
                                <span>Category List</span>
                            </a>
                        </li>
                        <li class="sidebar-layout">
                            <a class="nav-link" href="{{ url('/') }}/create">
                                <i class="ri-add-box-line"></i>
                                <span>Category Add</span>
                            </a>
                        </li>
                    </ul>
                </li> -->
                <?php
                /*
                <li class="">
                    <a data-toggle="collapse" role="button" aria-expanded="false" aria-controls="collapseExample" class="" href="#category-new">
                        <i class="ri-shopping-basket-2-line"></i>
                        <span>Category</span>
                        <svg xmlns="http://www.w3.org/2000/svg" class="svg-icon iq-arrow-right arrow-active" height="14" width="15" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
                        </svg>
                    </a>
                    <ul class="submenu collapse  " id="category-new">
                        <li class="sidebar-layout">
                            <a data-toggle="collapse" role="button" aria-expanded="false" aria-controls="collapseExample" class="" href="#self">
                                <i class="ri-list-unordered"></i>
                                <span>Self Care</span>
                                <svg xmlns="http://www.w3.org/2000/svg" class="svg-icon iq-arrow-right arrow-active" height="14" width="15" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
                                </svg>
                            </a>
                            <ul class="submenu collapse  " id="self">
                                <li class="sidebar-layout">
                                    <a class="nav-link" href="{{ url('/') }}/category?type=2">
                                        <i class="ri-list-unordered"></i>
                                        <span>Category</span>
                                    </a>
                                </li>
                                <li class="sidebar-layout">
                                    <a class="nav-link" href="{{ url('/') }}/subcategory?type=2">
                                        <i class="ri-list-unordered"></i>
                                        <span>SubCategory</span>
                                    </a>
                                </li>
                                <li class="sidebar-layout">
                                    <a class="nav-link" href="{{ url('/') }}/service?type=2">
                                        <i class="ri-list-unordered"></i>
                                        <span>Services</span>
                                    </a>
                                </li>
                            </ul>
                        </li>
                        <li class="sidebar-layout">
                            <a data-toggle="collapse" role="button" aria-expanded="false" aria-controls="collapseExample" class="" href="#health">
                                <i class="ri-list-unordered"></i>
                                <span>Home Care</span>
                                <svg xmlns="http://www.w3.org/2000/svg" class="svg-icon iq-arrow-right arrow-active" height="14" width="15" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
                                </svg>
                            </a>
                            <ul class="submenu collapse  " id="health">
                                <li class="sidebar-layout">
                                    <a class="nav-link" href="{{ url('/') }}/category?type=3">
                                        <i class="ri-list-unordered"></i>
                                        <span>Category</span>
                                    </a>
                                </li>
                                <li class="sidebar-layout">
                                    <a class="nav-link" href="{{ url('/') }}/subcategory?type=3">
                                        <i class="ri-list-unordered"></i>
                                        <span>SubCategory</span>
                                    </a>
                                </li>
                                <li class="sidebar-layout">
                                    <a class="nav-link" href="{{ url('/') }}/service?type=3">
                                        <i class="ri-list-unordered"></i>
                                        <span>Services</span>
                                    </a>
                                </li>
                            </ul>
                        </li>
                        <li class="sidebar-layout">
                            <a data-toggle="collapse" role="button" aria-expanded="false" aria-controls="collapseExample" class="" href="#construction">
                                <i class="ri-list-unordered"></i>
                                <span>Construction Care</span>
                                <svg xmlns="http://www.w3.org/2000/svg" class="svg-icon iq-arrow-right arrow-active" height="14" width="15" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
                                </svg>
                            </a>
                            <ul class="submenu collapse  " id="construction">
                                <li class="sidebar-layout">
                                    <a class="nav-link" href="{{ url('/') }}/category?type=1">
                                        <i class="ri-list-unordered"></i>
                                        <span>Category</span>
                                    </a>
                                </li>
                                <li class="sidebar-layout">
                                    <a class="nav-link" href="{{ url('/') }}/subcategory?type=1">
                                        <i class="ri-list-unordered"></i>
                                        <span>SubCategory</span>
                                    </a>
                                </li>
                                <li class="sidebar-layout">
                                    <a class="nav-link" href="{{ url('/') }}/service?type=1">
                                        <i class="ri-list-unordered"></i>
                                        <span>Services</span>
                                    </a>
                                </li>
                            </ul>
                        </li>
                    </ul>
                </li>
                */
                ?>

                <li class="">
                    <a data-toggle="collapse" role="button" aria-expanded="false" aria-controls="collapseExample" class="" href="#jvServices">
                        <i class="ri-shopping-basket-2-line"></i>
                        <span>Jv Services</span>
                        <svg xmlns="http://www.w3.org/2000/svg" class="svg-icon iq-arrow-right arrow-active" height="14" width="15" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
                        </svg>
                    </a>
                    <ul class="submenu collapse" id="jvServices">
                        <li class="sidebar-layout">
                            <a class="nav-link" href="{{ route('service.category.list') }}">
                                <i class="ri-list-unordered"></i>
                                <span>Categoires</span>
                            </a>
                        </li>
                        <li class="sidebar-layout">
                            <a class="nav-link" href="{{ route('service.subcategory.list') }}">
                                <i class="ri-list-unordered"></i>
                                <span>Subcategories</span>
                            </a>
                        </li>
                        <li class="sidebar-layout">
                            <a class="nav-link" href="{{ route('services.list') }}">
                                <i class="ri-list-unordered"></i>
                                <span>Services</span>
                            </a>
                        </li>
                    </ul>
                </li>
                
                <li class="">
                    <a data-toggle="collapse" role="button" aria-expanded="false" aria-controls="collapseExample" class="" href="#document">
                        <i class="ri-shopping-basket-2-line"></i>
                        <span>Jv Stores</span>
                        <svg xmlns="http://www.w3.org/2000/svg" class="svg-icon iq-arrow-right arrow-active" height="14" width="15" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
                        </svg>
                    </a>
                    <ul class="submenu collapse  " id="document">
                        <li class="sidebar-layout">
                            <a class="nav-link" href="{{ route('product.category.list') }}">
                                <i class="ri-list-unordered"></i>
                                <span>Stores Category</span>
                            </a>
                        </li>
                        <li class="sidebar-layout">
                            <a class="nav-link" href="{{ route('product.list') }}">
                                <i class="ri-add-box-line"></i>
                                <span>Products</span>
                            </a>
                        </li>
                    </ul>
                </li>

                <li>
                    <a class="nav-link" href="{{ url('/') }}/customer">
                        <i class="fa fa-users"></i>
                        <span>Customers</span>
                    </a>
                </li>
                <li>
                    <a class="nav-link" href="{{ url('/') }}/bookings">
                        <i class="fa fa-calendar"></i>
                        <span>Service Bookings</span>
                    </a>
                </li>
                <li>
                    <a class="nav-link" href="{{ url('/') }}/orders">
                        <i class="fa fa-shopping-cart"></i>
                        <span>Store Orders</span>
                    </a>
                </li>
                <li>
                    <a class="nav-link" href="{{ url('/') }}/payment">
                        <i class="ri-secure-payment-line"></i>
                        <span>Payment</span>
                    </a>
                </li>
                <li class="">
                    <a data-toggle="collapse" role="button" aria-expanded="false" aria-controls="collapseExample" class="" href="#provider">
                        <i class="la la-users"></i>
                        <span>Provider</span>
                        <svg xmlns="http://www.w3.org/2000/svg" class="svg-icon iq-arrow-right arrow-active" height="14" width="15" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
                        </svg>
                    </a>
                    <ul class="submenu collapse " id="provider">
                        <li class="sidebar-layout">
                            <a class="nav-link" href="{{ url('/') }}/provider">
                                <i class="ri-list-unordered"></i>
                                <span>Provider List</span>
                            </a>
                        </li>
                        <li class="sidebar-layout">
                            <a class="nav-link" href="{{ url('/') }}/provider/list/pending">
                                <i class="ri-list-unordered"></i>
                                <span>Pending Provider</span>
                            </a>
                        </li>
                        <li class="sidebar-layout">
                            <a class="nav-link" href="{{ url('/') }}/providerpayout">
                                <i class="fas fa-exchange-alt"></i>
                                <span>Payout History</span>
                            </a>
                        </li>
                        <li class="sidebar-layout">
                            <a class="nav-link" href="{{ url('/') }}/providertype">
                                <i class="ri-file-list-3-line"></i>
                                <span>Provider Type List</span>
                            </a>
                        </li>
                        <li class="sidebar-layout">
                            <a class="nav-link" href="{{ url('/') }}/provideraddress">
                                <i class="ri-file-list-3-line"></i>
                                <span>Address List</span>
                            </a>
                        </li>
                        <li class="sidebar-layout">
                            <a class="nav-link" href="{{ url('/') }}/providerdocument">
                                <i class="ri-file-list-3-line"></i>
                                <span>Provider Document List</span>
                            </a>
                        </li>
                        <li class="sidebar-layout">
                            <a class="nav-link" href="{{ url('/') }}/wallet">
                                <i class="fas fa-exchange-alt"></i>
                                <span>Wallet List</span>
                            </a>
                        </li>
                    </ul>
                </li>
                <li class="">
                    <a data-toggle="collapse" role="button" aria-expanded="false" aria-controls="collapseExample" class="" href="#document">
                        <i class="ri-shopping-basket-2-line"></i>
                        <span>Document</span>
                        <svg xmlns="http://www.w3.org/2000/svg" class="svg-icon iq-arrow-right arrow-active" height="14" width="15" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
                        </svg>
                    </a>
                    <ul class="submenu collapse  " id="document">
                        <li class="sidebar-layout">
                            <a class="nav-link" href="{{ url('/') }}/document">
                                <i class="ri-list-unordered"></i>
                                <span>Document List</span>
                            </a>
                        </li>
                        <li class="sidebar-layout">
                            <a class="nav-link" href="{{ url('/') }}/document/create">
                                <i class="ri-add-box-line"></i>
                                <span>Document Add</span>
                            </a>
                        </li>
                    </ul>
                </li>
                <li>
                    <a class="nav-link" href="{{ url('/') }}/earning">
                        <i class="fas fa-money-bill-alt"></i>
                        <span>Earning</span>
                    </a>
                </li>
                <li>
                    <a class="nav-link" href="{{ url('/') }}/plans">
                        <i class="ri-list-unordered"></i>
                        <span>Plans</span>
                    </a>
                </li>
                <li>
                    <a class="nav-link" href="{{ url('/') }}/tax">
                        <i class="fas fa-percent"></i>
                        <span>Tax</span>
                    </a>
                </li>
                <li class="">
                    <a data-toggle="collapse" role="button" aria-expanded="false" aria-controls="collapseExample" class="" href="#coupon">
                        <i class="ri-coupon-fill"></i>
                        <span>Coupon</span>
                        <svg xmlns="http://www.w3.org/2000/svg" class="svg-icon iq-arrow-right arrow-active" height="14" width="15" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
                        </svg>
                    </a>
                    <ul class="submenu collapse  " id="coupon">
                        <li class="sidebar-layout">
                            <a class="nav-link" href="{{ route('coupon.index') }}">
                                <i class="ri-list-unordered"></i>
                                <span>Coupon List</span>
                            </a>
                        </li>
                        <li class="sidebar-layout">
                            <a class="nav-link" href="{{ route('coupon.add') }}">
                                <i class="ri-add-box-line"></i>
                                <span>Coupon Add</span>
                            </a>
                        </li>
                    </ul>
                </li>
                <li class="">
                    <a data-toggle="collapse" role="button" aria-expanded="false" aria-controls="collapseExample" class="" href="#slider">
                        <i class="ri-slideshow-line"></i>
                        <span>Slider</span>
                        <svg xmlns="http://www.w3.org/2000/svg" class="svg-icon iq-arrow-right arrow-active" height="14" width="15" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
                        </svg>
                    </a>
                    <ul class="submenu collapse  " id="slider">
                        <li class="sidebar-layout">
                            <a class="nav-link" href="{{ url('/') }}/slider">
                                <i class="ri-list-unordered"></i>
                                <span>Slider List</span>
                            </a>
                        </li>
                        <li class="sidebar-layout">
                            <a class="nav-link" href="{{ url('/') }}/slider">
                                <i class="ri-add-box-line"></i>
                                <span>Slider Add</span>
                            </a>
                        </li>
                    </ul>
                </li>
                <li class="">
                    <a data-toggle="collapse" role="button" aria-expanded="false" aria-controls="collapseExample" class="" href="#pages">
                        <i class="ri-pages-line"></i>
                        <span>Pages</span>
                        <svg xmlns="http://www.w3.org/2000/svg" class="svg-icon iq-arrow-right arrow-active" height="14" width="15" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
                        </svg>
                    </a>
                    <ul class="submenu collapse  " id="pages">
                        <li class="sidebar-layout">
                            <a class="nav-link" href="{{ url('/') }}/pages/term-condition">
                                <i class="fas fa-file-contract"></i>
                                <span>Terms Condition</span>
                            </a>
                        </li>
                        <li class="sidebar-layout">
                            <a class="nav-link" href="{{ url('/') }}/pages/privacy-policy">
                                <i class="ri-file-shield-2-line"></i>
                                <span>Privacy Policy</span>
                            </a>
                        </li>
                        <li class="sidebar-layout">
                            <a class="nav-link" href="{{ url('/') }}/pages/about">
                                <i class="ri-file-shield-2-line"></i>
                                <span>About</span>
                            </a>
                        </li>
                    </ul>
                </li>
                <li>
                    <a class="nav-link" href="{{ url('/') }}/setting">
                        <i class="ri-settings-2-line"></i>
                        <span>Setting</span>
                    </a>
                </li>
                <li class="">
                    <a data-toggle="collapse" role="button" aria-expanded="false" aria-controls="collapseExample" class="" href="#account_setting">
                        <i class="ri-list-settings-line"></i>
                        <span>Account Setting</span>
                        <svg xmlns="http://www.w3.org/2000/svg" class="svg-icon iq-arrow-right arrow-active" height="14" width="15" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
                        </svg>
                    </a>
                    <ul class="submenu collapse  " id="account_setting">
                        <li class="sidebar-layout">
                            <a class="nav-link" href="{{ url('/') }}/role">
                                <i class="ri-list-unordered"></i>
                                <span>Role List</span>
                            </a>
                        </li>
                        <li class="sidebar-layout">
                            <a class="nav-link" href="{{ url('/') }}/permission">
                                <i class="ri-add-box-line"></i>
                                <span>Permission List</span>
                            </a>
                        </li>
                    </ul>
                </li>
            </ul>
        </nav>
        <div class="pt-5 pb-5"></div>
    </div>
</div>