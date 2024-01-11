<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\HomeController;
use App\Http\Controllers\Admin\PermissionController;
use App\Http\Controllers\Admin\RoleController;
use App\Http\Controllers\ServiceController;
use App\Http\Controllers\ServiceSlotController;
use App\Http\Controllers\ProviderTypeController;
use App\Http\Controllers\ProviderController;
use App\Http\Controllers\HandymanController;
use App\Http\Controllers\CouponController;
use App\Http\Controllers\BookingController;
use App\Http\Controllers\SliderController;
use App\Http\Controllers\SettingController;
use App\Http\Controllers\NotificationController;
use App\Http\Controllers\PaymentController;
use App\Http\Controllers\CustomerController;
use App\Http\Controllers\FrontendController;
use App\Http\Controllers\ProviderAddressMappingController;
use App\Http\Controllers\DocumentsController;
use App\Http\Controllers\ProviderDocumentController;
use App\Http\Controllers\RatingReviewController;
use App\Http\Controllers\PaymentGatewayController;
use App\Http\Controllers\TaxController;
use App\Http\Controllers\EarningController;
use App\Http\Controllers\ProviderPayoutController;
use App\Http\Controllers\HandymanPayoutController;
use App\Http\Controllers\HandymanTypeController;
use App\Http\Controllers\ServiceFaqController;
use App\Http\Controllers\WalletController;
use App\Http\Controllers\SubCategoryController;
use App\Http\Controllers\PlanController;
use App\Http\Controllers\ProductCategoryController;
use App\Http\Controllers\ProductController;
use App\Http\Controllers\ProductGalleryController;
use App\Http\Controllers\Webhook;
use App\Http\Controllers\OrderController;
use App\Http\Controllers\ServiceCategoryController;
use App\Http\Controllers\ServiceSubCategoryController;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/
Route::get('/', [FrontendController::class, 'index']);
Route::get('about', [FrontendController::class, 'about']);
Route::get('customer_review', [FrontendController::class, 'customer_review']);
Route::get('anti_diccriminatory_policy', [FrontendController::class, 'anti_diccriminatory_policy']);
Route::get('customer_satisfaction_policy', [FrontendController::class, 'customer_satisfaction_policy']);
Route::get('contact_us', [FrontendController::class, 'contact_us']);
Route::get('lang/{lang}', [FrontendController::class, 'switchLang']);
require __DIR__.'/auth.php';

Route::group(['prefix' => 'auth'], function() {
    Route::get('login', [HomeController::class, 'authLogin'])->name('auth.login');
    Route::get('register', [HomeController::class, 'authRegister'])->name('auth.register');
    Route::get('recover-password', [HomeController::class, 'authRecoverPassword'])->name('auth.recover-password');
    Route::get('confirm-email', [HomeController::class, 'authConfirmEmail'])->name('auth.confirm-email');
    Route::get('lock-screen', [HomeController::class, 'authlockScreen'])->name('auth.lock-screen');
});

Route::get('lang/{locale}', [HomeController::class,'lang'])->name('switch-language');

Route::group(['middleware' => ['auth', 'verified']], function()
{
    Route::get('/home', [HomeController::class, 'index'])->name('home');
    Route::group(['namespace' => '' ], function () {
        Route::resource('permission',PermissionController::class);
        Route::get('permission/add/{type}',[PermissionController::class,'addPermission'])->name('permission.add');
        Route::post('permission/save',[PermissionController::class,'savePermission'])->name('permission.save');

    });
    Route::resource('role', RoleController::class);

    Route::get('changeStatus', [ HomeController::class, 'changeStatus'])->name('changeStatus');

    Route::get('service/categories', [ServiceCategoryController::class, 'list'])->name('service.category.list');
    Route::get('service/categories/add', [ServiceCategoryController::class, 'add'])->name('service.category.add');
    Route::post('service/categories/store', [ServiceCategoryController::class, 'store'])->name('service.category.store');
    Route::get('service/categories/{id}/edit', [ServiceCategoryController::class, 'edit'])->name('service.category.edit');
    Route::post('service/categories/{id}/update', [ServiceCategoryController::class, 'update'])->name('service.category.update');
    Route::get('service/categories/{id}/delete', [ServiceCategoryController::class, 'delete'])->name('service.category.delete');
    Route::get('service/categories/subcategory-list', [ServiceCategoryController::class, 'get_subcategory_list'])->name('service.category.sub_category_list');

    Route::get('service/subcategories', [ServiceSubCategoryController::class, 'list'])->name('service.subcategory.list');
    Route::get('service/subcategories/add', [ServiceSubCategoryController::class, 'add'])->name('service.subcategory.add');
    Route::post('service/subcategories/store', [ServiceSubCategoryController::class, 'store'])->name('service.subcategory.store');
    Route::get('service/subcategories/{id}/edit', [ServiceSubCategoryController::class, 'edit'])->name('service.subcategory.edit');
    Route::post('service/subcategories/{id}/update', [ServiceSubCategoryController::class, 'update'])->name('service.subcategory.update');
    Route::get('service/subcategories/{id}/delete', [ServiceSubCategoryController::class, 'delete'])->name('service.subcategory.delete');

    Route::get('services', [ServiceController::class, 'list'])->name('services.list');
    Route::get('services/add', [ServiceController::class, 'add'])->name('services.add');
    Route::post('services/store', [ServiceController::class, 'store'])->name('services.store');
    Route::get('services/{id}/edit', [ServiceController::class, 'edit'])->name('services.edit');
    Route::post('services/{id}/update', [ServiceController::class, 'update'])->name('services.update');
    Route::get('services/{id}/delete', [ServiceController::class, 'delete'])->name('services.delete');

    Route::get('services/{service_id}/slots', [ServiceSlotController::class, 'list'])->name('services.slots.list');
    Route::get('services/{service_id}/slots/add', [ServiceSlotController::class, 'add'])->name('services.slots.add');
    Route::post('services/{service_id}/slots/store', [ServiceSlotController::class, 'store'])->name('services.slots.store');
    Route::get('services/{service_id}/slots/{id}/edit', [ServiceSlotController::class, 'edit'])->name('services.slots.edit');
    Route::post('services/{service_id}/slots/{id}/update', [ServiceSlotController::class, 'update'])->name('services.slots.update');
    Route::get('services/{service_id}/slots/{id}/delete', [ServiceSlotController::class, 'delete'])->name('services.slots.delete');

    Route::post('service-action',[ServiceController::class, 'action'])->name('service.action');
    Route::resource('provider', ProviderController::class);
    Route::resource('provideraddress', ProviderAddressMappingController::class);
    Route::get('provider/list/{status?}', [ProviderController::class,'index'])->name('provider.pending');
    Route::post('provider-action',[ProviderController::class, 'action'])->name('provider.action');
    Route::resource('providertype', ProviderTypeController::class);
    Route::post('providertype-action',[ProviderTypeController::class, 'action'])->name('providertype.action');
    Route::resource('handyman', HandymanController::class);
    Route::get('handyman/list/{status?}', [HandymanController::class,'index'])->name('handyman.pending');
    Route::post('handyman-action',[HandymanController::class, 'action'])->name('handyman.action');

    Route::get('coupons', [CouponController::class, 'index'])->name('coupon.index');
    Route::get('coupons/create', [CouponController::class, 'create'])->name('coupon.add');
    Route::post('coupons/store', [CouponController::class, 'store'])->name('coupon.store');
    Route::get('coupons/{id}/edit', [CouponController::class, 'edit'])->name('coupon.edit');
    Route::post('coupons/{id}/update', [CouponController::class, 'update'])->name('coupon.update');
    Route::get('coupons/{id}/delete', [CouponController::class, 'delete'])->name('coupon.delete');
    

    Route::get('bookings', [BookingController::class, 'index'])->name('bookings.list');
    Route::get('bookings/list', [BookingController::class, 'datatable'])->name('bookings.datatable');
    Route::get('bookings/{id}/details', [BookingController::class, 'show'])->name('bookings.show');

    Route::get('orders', [OrderController::class, 'index'])->name('orders.list');
    Route::get('orders/list', [OrderController::class, 'datatable'])->name('orders.datatable');
    Route::get('orders/{id}/details', [OrderController::class, 'show'])->name('orders.show');

    Route::post('booking-save', [ App\Http\Controllers\BookingController::class, 'store' ] )->name('booking.save');
    Route::post('booking-action',[BookingController::class, 'action'])->name('booking.action');
    Route::resource('slider', SliderController::class);
    Route::post('slider-action',[SliderController::class, 'action'])->name('slider.action');
    Route::resource('payment', PaymentController::class);
    Route::post('save-payment',[App\Http\Controllers\API\PaymentController::class, 'savePayment'])->name('payment.save');
    Route::resource('customer', CustomerController::class);
    Route::post('user-action',[CustomerController::class, 'action'])->name('user.action');

    Route::get('booking-assign-form/{id}',[BookingController::class,'bookingAssignForm'])->name('booking.assign_form');
    Route::post('booking-assigned',[BookingController::class,'bookingAssigned'])->name('booking.assigned');

    // Setting
    Route::get('setting/{page?}',[ SettingController::class, 'settings'])->name('setting.index');
    Route::post('/layout-page',[ SettingController::class, 'layoutPage'])->name('layout_page');
    Route::post('/layout-page',[ SettingController::class, 'layoutPage'])->name('layout_page');
    Route::post('settings/save',[ SettingController::class , 'settingsUpdates'])->name('settingsUpdates');
    Route::post('save-app-download',[ SettingController::class , 'saveAppDownloadSetting'])->name('saveAppDownload');
    Route::post('dashboard-setting',[ SettingController::class , 'dashboardtogglesetting'])->name('togglesetting');
    Route::post('provider-dashboard-setting',[ SettingController::class , 'providerdashboardtogglesetting'])->name('providertogglesetting');
    Route::post('handyman-dashboard-setting',[ SettingController::class , 'handymandashboardtogglesetting'])->name('handymantogglesetting');
    Route::post('config-save',[ SettingController::class , 'configUpdate'])->name('configUpdate');

    
    Route::post('env-setting', [ SettingController::class , 'envChanges'])->name('envSetting');
    Route::post('update-profile', [ SettingController::class , 'updateProfile'])->name('updateProfile');
    Route::post('change-password', [ SettingController::class , 'changePassword'])->name('changePassword');

    Route::get('notification-list',[ NotificationController::class ,'notificationList'])->name('notification.list');
    Route::get('notification-counts',[ NotificationController::class ,'notificationCounts'])->name('notification.counts');
    Route::get('notification',[ NotificationController::class ,'index'])->name('notification.index');

    Route::post('remove-file', [ App\Http\Controllers\HomeController::class, 'removeFile' ] )->name('remove.file');
    Route::post('get-lang-file', [ App\Http\Controllers\LanguageController::class, 'getFile' ] )->name('getLangFile');
    Route::post('save-lang-file', [ App\Http\Controllers\LanguageController::class, 'saveFileContent' ] )->name('saveLangContent');

    Route::get('pages/term-condition',[ SettingController::class, 'termAndCondition'])->name('term-condition');
    Route::post('term-condition-save',[ SettingController::class, 'saveTermAndCondition'])->name('term-condition-save');

    Route::get('pages/privacy-policy',[ SettingController::class, 'privacyPolicy'])->name('privacy-policy');
    Route::post('privacy-policy-save',[ SettingController::class, 'savePrivacyPolicy'])->name('privacy-policy-save');


    Route::get('pages/about',[ SettingController::class, 'pageAbout'])->name('page-about');
    Route::post('page-about-save',[ SettingController::class, 'savePageAbout'])->name('page-about-save');

    Route::resource('document', DocumentsController::class);
    Route::post('document-action',[DocumentsController::class, 'action'])->name('document.action');

    Route::resource('providerdocument', ProviderDocumentController::class);
    Route::post('providerdocument-action',[ProviderDocumentController::class, 'action'])->name('providerdocument.action');

    Route::resource('ratingreview', RatingReviewController::class);
    Route::post('ratingreview-action',[RatingReviewController::class, 'action'])->name('ratingreview.action');

    Route::post('/payment-layout-page',[ PaymentGatewayController::class, 'paymentPage'])->name('payment_layout_page');
    Route::post('payment-settings/save',[ PaymentGatewayController::class , 'paymentsettingsUpdates'])->name('paymentsettingsUpdates');
    Route::post('get_payment_config',[ PaymentGatewayController::class , 'getPaymentConfig'])->name('getPaymentConfig');

    Route::resource('tax', TaxController::class);
    Route::get('earning',[EarningController::class,'index'])->name('earning');
    Route::get('earning-data',[EarningController::class,'setEarningData'])->name('earningData');

    Route::get('handyman-earning',[EarningController::class,'handymanEarning'])->name('handymanEarning');
    Route::get('handyman-earning-data',[EarningController::class,'handymanEarningData'])->name('handymanEarningData');

    Route::resource('providerpayout', ProviderPayoutController::class);
    Route::get('providerpayout/create/{id}', [ProviderPayoutController::class,'create'])->name('providerpayout.create');
    Route::post('sidebar-reorder-save',[ SettingController::class, 'sequenceSave'])->name('reorderSave');

    Route::resource('handymanpayout', HandymanPayoutController::class);
    Route::get('handymanpayout/create/{id}', [HandymanPayoutController::class,'create'])->name('handymanpayout.create');

    Route::resource('handymantype', HandymanTypeController::class);
    Route::post('handymantype-action',[HandymanTypeController::class, 'action'])->name('handymantype.action');

    Route::resource('servicefaq', ServiceFaqController::class);
    Route::post('send-push-notification', [ SettingController::class , 'sendPushNotification'])->name('sendPushNotification');
    Route::post('save-earning-setting', [ SettingController::class , 'saveEarningTypeSetting'])->name('saveEarningTypeSetting');

    Route::resource('wallet', WalletController::class);
    Route::resource('subcategory', SubCategoryController::class);
    Route::post('subcategory-action',[SubCategoryController::class, 'action'])->name('subcategory.action');

    Route::resource('plans', PlanController::class);

    //jv stores 
    Route::get('product/categories', [ProductCategoryController::class, 'list'])->name('product.category.list');
    Route::get('product/categories/add', [ProductCategoryController::class, 'add'])->name('product.category.add');
    Route::post('product/categories/store', [ProductCategoryController::class, 'store'])->name('product.category.store');
    Route::get('product/categories/{id}/edit', [ProductCategoryController::class, 'edit'])->name('product.category.edit');
    Route::post('product/categories/{id}/update', [ProductCategoryController::class, 'update'])->name('product.category.update');
    Route::get('product/categories/{id}/delete', [ProductCategoryController::class, 'delete'])->name('product.category.delete');

    Route::get('products', [ProductController::class, 'list'])->name('product.list');
    Route::get('products/list', [ProductController::class, 'datatable'])->name('product.datatable');
    Route::get('products/add', [ProductController::class, 'add'])->name('product.add');
    Route::post('products/store', [ProductController::class, 'store'])->name('product.store');
    Route::get('products/{id}/edit', [ProductController::class, 'edit'])->name('product.edit');
    Route::post('products/{id}/update', [ProductController::class, 'update'])->name('product.update');
    Route::get('products/{id}/delete', [ProductController::class, 'delete'])->name('product.delete');

    Route::get('products/{product_id}/gallery', [ProductGalleryController::class, 'list'])->name('product.gallery.list');
    Route::get('products/{product_id}/gallery/add', [ProductGalleryController::class, 'add'])->name('product.gallery.add');
    Route::post('products/{product_id}/gallery/store', [ProductGalleryController::class, 'store'])->name('product.gallery.store');
    Route::get('products/{product_id}/gallery/{id}/delete', [ProductGalleryController::class, 'delete'])->name('product.gallery.delete');
});

Route::get('/ajax-list',[HomeController::class, 'getAjaxList'])->name('ajax-list');

Route::any('/webhook/stripe', [Webhook::class, 'stripe']);