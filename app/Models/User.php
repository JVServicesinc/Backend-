<?php

namespace App\Models;

use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Mail;
use Spatie\MediaLibrary\HasMedia;
use Spatie\MediaLibrary\InteractsWithMedia;
use Spatie\Permission\Traits\HasRoles;
use Laravel\Sanctum\HasApiTokens;

use Firebase\JWT\JWT;
use Illuminate\Support\Facades\Hash;
use App\Mail\CustomerRegistered;
use App\Mail\ForgotPasswordOtp;

class User extends Authenticatable implements HasMedia
{
    use HasApiTokens, Notifiable, HasRoles, InteractsWithMedia,SoftDeletes;

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'username', 'first_name', 'last_name', 'email', 'password', 'user_type', 'address', 'contact_number', 'email_verified_at', 'remember_token','handymantype_id',
        'player_id', 'onboarding_step_status', 'country_id', 'state_id',  'city_id' , 'lat', 'longitude', 'address', 'provider_id' , 'status', 'display_name', 'providertype_id' , 'is_featured' , 'time_zone' ,'last_notification_seen' , 'login_type','service_address_id' , 'uid','is_subscribe'
    ];

    /**
     * The attributes that should be hidden for arrays.
     *
     * @var array
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * The attributes that should be cast to native types.
     *
     * @var array
     */
    protected $casts = [
        'email_verified_at' => 'datetime',
        'country_id'        => 'integer',
        'state_id'          => 'integer',
        'city_id'           => 'integer',
        'is_featured'       => 'integer',
        'providertype_id'   => 'integer',
        'provider_id'       => 'integer',
        'service_address_id' => 'integer',
        'status'            => 'integer',
    ];

    public const TYPE_ADMIN = 'admin';
    public const TYPE_DEMO_ADMIN = 'demo_admin';
    public const TYPE_HANDYMAN = 'handyman';
    public const TYPE_PROVIDER = 'provider';
    public const TYPE_USER = 'user';

    protected static function boot()
    {
        parent::boot();
        static::deleted(function ($row) {
            switch ($row->user_type) {
                case 'provider':
                    if($row->forceDeleting === true){
                        $row->providerService()->forceDelete();
                        $row->providerBooking()->forceDelete();
                    }else{
                        $row->providerService()->delete();
                        $row->providerBooking()->delete();
                    }
                    break;

                case 'handyman':
                    if($row->forceDeleting === true){
                        $row->handyman()->forceDelete();
                    }else{
                        $row->handyman()->delete();
                    }
                    break;

                case 'customer':
                    if($row->forceDeleting === true){
                        $row->booking()->forceDelete();
                        $row->payment()->forceDelete();
                    }else{
                        $row->booking()->delete();
                        $row->payment()->delete();
                    }
                    break;
                
                default:
                    # code...
                    break;
            }
        });
        static::restoring(function($row) {
            switch ($row->user_type) {
                case 'provider':
                    $row->providerService()->withTrashed()->restore();
                    $row->providerBooking()->withTrashed()->restore();
                    break;

                case 'handyman':
                   $row->handyman()->withTrashed()->restore();
                    break;

                case 'customer':
                   $row->booking()->withTrashed()->restore();
                   $row->payment()->withTrashed()->restore();
                    break;
                
                default:
                    # code...
                    break;
            }
        });    
    }

    public function country(){
        return $this->belongsTo(Country::class, 'country_id','id');
    }

    public function city(){
        return $this->belongsTo(City::class, 'city_id','id');
    }

    public function providertype(){
        return $this->belongsTo(ProviderType::class, 'providertype_id','id');
    }

    public function providers(){
        return $this->belongsTo(User::class, 'provider_id','id');
    }

    public function handyman(){
        return $this->hasMany(BookingHandymanMapping::class, 'handyman_id','id');
    }

    public function booking(){
        return $this->hasMany(Booking::class, 'customer_id','id');
    }

    public function payment(){
        return $this->hasMany(Payment::class, 'customer_id','id');
    }

    public function routeNotificationForOneSignal(){
        return $this->player_id;
    }

    protected function getUserByKeyValue($key,$value){
        return $this->where($key, $value)->first();
    }
    public function providerTaxMapping(){
        return $this->hasMany(ProviderTaxMapping::class, 'provider_id','id');
    }
    public function providerTaxMappingData(){
        return $this->hasMany(ProviderTaxMapping::class, 'provider_id','id')->with('taxes');
    }

  
    public function providerService(){
        return $this->hasMany(Service::class, 'provider_id','id');
    }
    
    public function getServiceRating(){
        return $this->hasManyThrough(
            BookingRating::class,
            Service::class,
            'provider_id', // services
            'service_id', // booking rating
            'id', // users
            'id' // services
        );
    }

    public function providerBooking(){
        return $this->hasMany(Booking::class, 'provider_id','id');
    }

    public function handymanAddressMapping(){
        return $this->belongsTo(ProviderAddressMapping::class, 'service_address_id','id');
    }

    public function handymanRating(){
        return $this->hasMany(HandymanRating::class, 'handyman_id','id');
    }

    public function providerDocument(){
        return $this->hasMany(ProviderDocument::class, 'provider_id','id');
    }
    public function handymantype(){
        return $this->belongsTo(HandymanType::class, 'handymantype_id','id');
    }

    public function subscriptionPackage(){
        return $this->hasOne(ProviderSubscription::class, 'user_id','id')->where('status',config('constant.SUBSCRIPTION_STATUS.ACTIVE'));
    }

    public static function getUserFromMobileNumber($contact_number){
        return User::where([
            'contact_number' => $contact_number
        ])->first();
    }

    public function scopeMyUsers($query,$type='')
    {
        $user = auth()->user();
        
        if($user->hasRole('admin') || $user->hasRole('demo_admin')) {
            if($type === 'get_provider'){
                $query->where('user_type', 'provider')->where('status',1);
            }
            if($type === 'get_customer'){
                $query->where('user_type', 'user');
            }
            return $query;
        }
        if($user->hasRole('provider')) {
            return $query->where('user_type', 'handyman')->where('provider_id',$user->id);
        }
    }

    public static function registerUser($data)
    {
        $user_type = $data['user_type'];

        if( $user_type == 'provider' ) {

            $role =  DB::table('roles')->where('name', $user_type)->first();

            return DB::table('users')->insert([
                'username' => uniqid('provider_'),
                'full_name' => trim($data['full_name']),
                'email'     => $data['email'],
                'mobile'    => $data['mobile'],
                'user_type' => 'provider',
                'role_id'   => $role->id,
                'user_city' => $data['city'],
                'work_type' => $data['work_type'],
                'password'  => Hash::make($data['password'])
            ]);
        }

        if( $user_type == 'user' ) {

            $role =  DB::table('roles')->where('name', $user_type)->first();

            $stripe = new \Stripe\StripeClient( env('STRIPE_SECRET_KEY') );
            $stripe_customer = $stripe->customers->create([
                'name' => trim($data['full_name']),
                'email' => $data['email']
            ]);

            DB::table('users')->insert([
                'stripe_customer_id' =>  $stripe_customer->id,
                'username' => uniqid('user_'),
                'full_name' => trim($data['full_name']),
                'email'     => $data['email'],
                'mobile'    => $data['mobile'],
                'user_type' => 'user',
                'role_id'   => $role->id,
                'password'  => Hash::make($data['password']),
                'country_code' => $data['country_code']
            ]);

            // $email_otp = random_int(152368, 999999);

            $email_otp = 123456;

            $emailData = [
                'full_name' => trim($data['full_name']),
                'email_otp' => $email_otp
            ];
    
            Mail::to($data['email'])->send(new CustomerRegistered($emailData));

            DB::table('users')->where(['email' => $data['email']])->update([
                'email_otp' => $email_otp,
                'email_otp_sent_on' => date('Y-m-d H:i:s')
            ]);

            return true;
        }
    }

    /**
     * Login user
     * 
     * @param array $data
     * @return array
     */
    public static function initLogin($data)
    {
        $username = $data['username'];

        $sql = "SELECT * 
        FROM users 
        WHERE (email = :email OR mobile = :mobile) AND status = 1
        LIMIT 1";

        $user = DB::selectOne($sql, [
            'email' => $username,
            'mobile' => $username
        ]);

        $user_id   = $user->id;

        $key = env('APP_SECRET');

        $issuedAt   = new \DateTimeImmutable();
        $expire     = $issuedAt->modify('+5 day')->getTimestamp();
        $serverName = env('APP_URL');
      
        $payload = [
            'iat'  => $issuedAt->getTimestamp(),         // Issued at: time when the token was generated
            'iss'  => $serverName,                       // Issuer
            'nbf'  => $issuedAt->getTimestamp(),         // Not before
            'exp'  => $expire,                           // Expire
            'user_id' => $user_id
        ];

        $jwt = JWT::encode($payload, $key, 'HS256');

        $refresh_token = hash('sha1', uniqid($user_id));

        return [
            'access_token' => $jwt,
            'refresh_token' => $refresh_token,
            'expire_at' => $expire
        ];
    }

    /**
     * Delete a user account
     * 
     * @param string $email
     * @return mixed
     */
    public static function deleteUser($email)
    {
        $sql = "DELETE FROM users WHERE email = ?";
        DB::delete($sql, [$email]);
    }

    public static function changeStatus($status, $reson)
    {
        global $userData;

        $user_id = $userData->id;

        if( $status == 'online' ) {
            DB::table('users')->where(['id' => $user_id])->update(['provider_status' => $status]);
        } else {
            DB::table('users')->where(['id' => $user_id])->update(['provider_status' => $status, 'provider_offline_reason' => $reson]);
        }
    }


    public static function findUserByEmail($email)
    {
        $sql = "SELECT * FROM users WHERE email =:email AND deleted_at IS NULL";
        return DB::selectOne($sql, ['email' => $email]);
    }

    /**
     * Change user password
     * 
     * @param array $post_data
     */
    public static function changePassword($post_data)
    {
        return DB::table('users')->where(['email' => $post_data['email']])->update([
            'password' => Hash::make($post_data['password'])
        ]);
    }

    /**
     * Validate forgot password otp
     * 
     * @param string $email
     * @param string $otp
     * 
     * @return bool
     * @throws \Exception
     */
    public static function validateForgotPasswordOtp($email, $otp)
    {
        $user = self::findUserByEmail($email);

        if( $user->password_reset_otp != $otp ) {
            throw new \Exception("otp does not match");
        }

        DB::table('users')->where(['email' => $email])->update([
            'password_reset_otp' => NULL
        ]);

        return true;
    }

    /**
     * Validate email otp
     * 
     * @param string $email
     * @param string $otp
     * 
     * @return bool
     * @throws \Exception
     */
    public static function validateEmailOtp($email, $otp)
    {
        $user = self::findUserByEmail($email);

        if( $user->email_otp != $otp ) {
            throw new \Exception("otp does not match");
        }

        $otp_sent_on = new \DateTime($user->email_otp_sent_on);

        if( time() - $otp_sent_on->getTimestamp() > 5 * 60  ) {
            throw new \Exception("invalid otp");
        }

        DB::table('users')->where(['email' => $email])->update([
            'email_otp_sent_on' => NULL,
            'email_otp' => NULL,
            'is_email_verified' => 1
        ]);

        return true;
    }

    /**
     * Send forgot password otp
     * 
     * @param string $email
     */
    public static function sendForgotPasswordOtp($email)
    {
        $user = self::findUserByEmail($email);

        $otp = random_int(152368, 999999);

        $emailData = [
            'full_name' => $user->full_name,
            'email_otp' => $otp
        ];

        Mail::to($email)->send(new ForgotPasswordOtp($emailData));

        DB::table('users')->where(['email' => $email])->update([
            'password_reset_otp' => $otp
        ]);

        return true;
    }

    /**
     * Resend email otp
     * 
     * @param string $email
     * @return bool
     */
    public static function resendEmailOtp($email)
    {
        $user = self::findUserByEmail($email);

        // $email_otp = random_int(152368, 999999);
        $email_otp = 123456;

        $emailData = [
            'full_name' => $user->full_name,
            'email_otp' => $email_otp
        ];

        Mail::to($email)->send(new CustomerRegistered($emailData));

        DB::table('users')->where(['email' => $email])->update([
            'email_otp' => $email_otp,
            'email_otp_sent_on' => date('Y-m-d H:i:s')
        ]);

        return true;
    }

    /**
     * Update user profile
     * 
     * @param array $data
     * @return bool
     */
    public static function updateProfile($data)
    {
        global $userData;

        $user_id = $userData->id;

        DB::table('users')->where(['id' => $user_id])->update($data);
    }

    /**
     * Get account status
     * 
     * @param string $email
     * @return object|null
     */
    public static function getAccountStatus($email)
    {
        $sql = "SELECT 
            email,
            mobile,
            is_email_verified,
            is_mobile_verified
        FROM users
        WHERE email = :email";

        return DB::selectOne($sql, ['email'=> $email]);
    }

    /**
     * Mark mobile as verified
     * 
     * @param string $mobile
     * @return bool
     */
    public static function markMobileAsVerified($mobile)
    {
        return DB::table('users')->where(['mobile' => $mobile])->update(['is_mobile_verified' => 1]);
    }

    /**
     * Save user device token
     * 
     * @param int $user_id
     * @param string $device_token
     * @return bool
     */
    public static function saveDeviceToken($user_id, $device_token)
    {
        DB::table('users')->where(['id' => $user_id])->update(['user_device_token' => $device_token]);
    }
}
