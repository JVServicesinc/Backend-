<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\API;
/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/
/*
normal api_token
Route::middleware('auth:api')->get('/user', function (Request $request) {
    return $request->user();
});
*/

if ( isset($_SERVER['REQUEST_METHOD']) && $_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    header("Access-Control-Allow-Methods: GET, PUT, POST, DELETE, OPTIONS");
    header('Access-Control-Allow-Origin: *');
    header('Access-Control-Allow-Credentials: true');
    header("Access-Control-Allow-Headers: *");
    die;
}

header("Access-Control-Allow-Methods: GET, PUT, POST, DELETE, OPTIONS");
header('Access-Control-Allow-Credentials: true');
header('Access-Control-Allow-Origin: *');
header("Access-Control-Allow-Headers: *");

/**
 * Global user data
 * 
 * @var null|object $userData
 */
$userData = null;


Route::get('search',[ API\SearchController::class, 'index']);
Route::get('page',[ API\PageController::class, 'index']);

Route::get('services',[ API\ServiceController::class, 'getServices' ]);
Route::get('services/{service_type_id}/categories',[ API\ServiceController::class, 'getServiceCategories' ]);
Route::get('services/{service_type_id}/categories/{category_id}/subcategories',[ API\ServiceController::class, 'getServiceSubcategoires' ]);
Route::get('services/{service_type_id}/subcategories/{sub_cat_id}/services',[ API\ServiceController::class, 'getServicesBySubcategory' ]);
Route::get('services/{service_id}',[ API\ServiceController::class, 'serviceDetails' ]);
Route::get('services/{service_id}/slots/{weekday_number}',[API\ServiceController::class, 'serviceSlots']);
Route::get('store/categories',[ API\StoreCategoryController::class, 'getStoreCategories' ]);
Route::get('products/trending', [API\ProductController::class, 'get_trending_products']);
Route::get('products/categories', [API\ProductController::class, 'get_product_categories']);
Route::get('products/categories/{id}/products', [API\ProductController::class, 'get_product_by_category']);
Route::get('products/{id}', [API\ProductController::class, 'get_product_details']);
Route::post('products/compare', [API\ProductController::class, 'compare_products']);
Route::get('work-type', [API\ProviderController::class, 'work_type']);

Route::get('location/get-address', [API\LocationController::class, 'get_street_address_by_lat_lng']);

Route::get('auth/test', [API\AuthController::class, 'test']);

Route::post('auth/register', [API\AuthController::class, 'register']);
Route::post('auth/user/register', [API\AuthController::class, 'user_register']);
Route::post('auth/user/verify-email', [API\AuthController::class, 'user_verify_email']);
Route::post('auth/user/resend-email-otp', [API\AuthController::class, 'user_resend_email_otp']);
Route::post('auth/login', [API\AuthController::class, 'login']);
Route::post('auth/check-account', [API\AuthController::class, 'check_account']);
Route::post('auth/verify-mobile', [API\AuthController::class, 'verify_mobile']);

Route::post('auth/forgot-password/send-otp', [API\AuthController::class, 'send_forgot_password_otp']);
Route::post('auth/forgot-password/validate-otp', [API\AuthController::class, 'validate_forgot_password_otp']);
Route::post('auth/forgot-password/change-password', [API\AuthController::class, 'change_password']);

Route::group(['middleware' => [ 'jwtVerifier' ]], function () {
    Route::prefix('onboarding')->group(function () {
        Route::get('/kyc/bank-accounts', [API\ProviderOnboardingController::class, 'bank_accounts']);
        Route::post('/kyc/bank-accounts', [API\ProviderOnboardingController::class, 'save_bank_accounts']);
        Route::get('/kyc/aadhar', [API\ProviderOnboardingController::class, 'get_aadhar']);
        Route::post('/kyc/aadhar', [API\ProviderOnboardingController::class, 'save_aadhar']);
        Route::get('/kyc/pan', [API\ProviderOnboardingController::class, 'get_pan']);
        Route::post('/kyc/pan', [API\ProviderOnboardingController::class, 'save_pan']);
        Route::get('/kyc/sin', [API\ProviderOnboardingController::class, 'get_sin']);
        Route::post('/kyc/sin', [API\ProviderOnboardingController::class, 'save_sin']);
    });

    Route::post('user/device-token', [API\User\UserController::class, 'save_device_token']);
    
    Route::get('user/profile', [API\User\UserController::class, 'user_profile']);
    Route::post('user/profile', [API\User\UserController::class, 'user_profile_update']);
    Route::post('user/delete', [API\User\UserController::class, 'delete_user']);

    Route::get('user/addresses', [API\User\UserController::class, 'user_addresses']);
    Route::post('user/addresses', [API\User\UserController::class, 'add_user_addresses']);
    Route::get('user/addresses/{address_id}', [API\User\UserController::class, 'user_address_details']);
    Route::post('user/addresses/{address_id}/delete', [API\User\UserController::class, 'user_address_delete']);
    Route::post('user/addresses/{address_id}/update', [API\User\UserController::class, 'user_address_update']);
    Route::post('user/addresses/{address_id}/make-default', [API\User\UserController::class, 'user_address_make_default']);

    Route::post('/orders/{order_id}/payment-intent', [API\OrderController::class, 'payment_intent']);

    Route::post('/orders', [API\OrderController::class, 'create_order']);
    Route::get('/orders', [API\OrderController::class, 'list_orders']);
    Route::get('/orders/{order_id}', [API\OrderController::class, 'order_details']);
    Route::post('/orders/confirm', [API\OrderController::class, 'order_confirm']);
    Route::post('/orders/validate-booking-otp', [API\OrderController::class, 'validate_booking_otp']);
    Route::post('/orders/accept', [API\OrderController::class, 'accept_booking']);
    Route::post('/orders/reject', [API\OrderController::class, 'reject_booking']);
    
    Route::get('/wishlists', [API\WishlistController::class, 'wishlists']);
    Route::post('/wishlists', [API\WishlistController::class, 'create_wishlist']);
    Route::post('/wishlists/{id}/remove', [API\WishlistController::class, 'remove_wishlist']);
    Route::post('/wishlists/check', [API\WishlistController::class, 'check_product_or_service_exit']);

    Route::post('products/{id}/rating', [API\ProductController::class, 'add_rating']);
    Route::post('products/{product_id}/rating/{rating_id}/update', [API\ProductController::class, 'update_rating']);
    Route::post('products/{product_id}/rating/{rating_id}/delete', [API\ProductController::class, 'delete_rating']);

    Route::get('provider/offline-reasons', [API\ProviderController::class, 'offline_reasons']);
    Route::post('provider/change-status', [API\ProviderController::class, 'change_status']);
    Route::get('provider/service-types', [API\ProviderController::class, 'service_types']);
    Route::get('provider/service-categoires', [API\ProviderController::class, 'service_categories']);
    Route::get('provider/service-categoires/{category_id}/subcategory', [API\ProviderController::class, 'service_sub_categories']);
    Route::post('provider/services/add', [API\ProviderController::class, 'add_service']);
    Route::get('provider/services', [API\ProviderController::class, 'services']);
    Route::post('provider/slots', [API\ProviderController::class, 'update_slots']);
    Route::get('provider/slots', [API\ProviderController::class, 'slots']);
    Route::get('provider/bookings', [API\ProviderController::class, 'bookings']);
    Route::get('provider/bookings/{booking_id}', [API\ProviderController::class, 'booking_details']);
});

Route::get('/cart', [API\CartController::class, 'cart_items']);
Route::post('/cart/sync', [API\CartController::class, 'sync_cart'])->middleware('jwtVerifier');
Route::post('/cart/add', [API\CartController::class, 'add_cart_item']);
Route::post('/cart/auth/add', [API\CartController::class, 'add_auth_cart_item'])->middleware('jwtVerifier');
Route::post('/cart/{cart_id}/items/{cart_item_id}/remove', [API\CartController::class, 'remove_cart_item']);
Route::post('/cart/{cart_id}/update', [API\CartController::class, 'update_cart_item']);
Route::post('/cart/{cart_id}/service/{cart_item_id}/slot', [API\CartController::class, 'update_cart_service_item_slot']);

Route::post('/contact', [API\ContactController::class, 'send_message']);