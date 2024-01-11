<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Spatie\MediaLibrary\HasMedia;
use Spatie\MediaLibrary\InteractsWithMedia;
use Illuminate\Database\Eloquent\SoftDeletes;
use App\Models\Documents;
use Illuminate\Support\Facades\DB;

class ProviderDocument extends Model implements HasMedia
{
    use HasFactory, InteractsWithMedia, SoftDeletes;

    protected $table = 'provider_documents';

    protected $fillable = [
       'provider_id','document_id','is_verified', 'document_number',
       'document_back_photo', 'document_front_photo'
    ];

    protected $casts = [
        'provider_id'   => 'integer',
        'document_id'   => 'integer',
        'is_verified'   => 'integer',
    ];

    public function providers()
    {
        return $this->belongsTo('App\Models\User','provider_id','id')->withTrashed();
    }

    public function document()
    {
        return $this->belongsTo('App\Models\Documents','document_id','id')->withTrashed();
    }

    public function scopeMyDocument($query)
    {
        $user = auth()->user();

        if($user->hasRole('admin') || $user->hasRole('demo_admin')) {
            $query =  $query;
        }

        if($user->hasRole('provider')) {
            $query = $query->where('provider_id', $user->id);
        }

        return  $query->whereHas('document',function ($q) {
            $q->where('status',1);
        });
    }

    public static function saveAadharInfo($data)
    {
        $aadhar_document = Documents::firstWhere('name', 'Aadhar Card');

        self::updateOrCreate(
            [
                'provider_id' => $data['provider_id'],
                'document_id'           => $aadhar_document->id
            ],
            [
                'document_number'   => $data['document_number'],
                'document_back_photo'   => $data['document_back_photo'],
                'document_front_photo'  => $data['document_front_photo'],
                'created_at'            => date('Y-m-d H:i:s')
            ]
        );
    }

    public static function getAadharInfo($provider_id)
    {
        $sql = "SELECT 
            p.*
        FROM provider_documents p
        INNER JOIN documents d ON d.id = p.document_id
        WHERE p.provider_id = :provider_id AND d.name = :name";


        return DB::selectOne($sql, [
            'provider_id' => $provider_id,
            'name'  => 'Aadhar Card'
        ]);
    }

    public static function savePanInfo($data)
    {
        $pan_document = Documents::firstWhere('name', 'Pan Card');

        self::updateOrCreate(
            [
                'provider_id' => $data['provider_id'],
                'document_id'           => $pan_document->id
            ],
            
            [
                'document_number'   => $data['document_number'],
                'document_back_photo'   => $data['document_back_photo'],
                'document_front_photo'  => $data['document_front_photo'],
                'created_at'            => date('Y-m-d H:i:s')
            ]
        );
    }

    public static function saveSinInfo($data)
    {
        $sin_document = Documents::firstWhere('name', 'Sin');

        self::updateOrCreate(
            [
                'provider_id' => $data['provider_id'],
                'document_id'           => $sin_document->id
            ],
            
            [
                'document_number'   => $data['document_number'],
                'document_back_photo'   => $data['document_back_photo'],
                'document_front_photo'  => $data['document_front_photo'],
                'created_at'            => date('Y-m-d H:i:s')
            ]
        );
    }

    public static function getSinInfo($provider_id)
    {
        $sql = "SELECT 
            p.*
        FROM provider_documents p
        INNER JOIN documents d ON d.id = p.document_id
        WHERE p.provider_id = :provider_id AND d.name = :name";

        return DB::selectOne($sql, [
            'provider_id' => $provider_id,
            'name'  => 'Sin'
        ]);
    }

    public static function getPanInfo($provider_id)
    {
        $sql = "SELECT 
            p.*
        FROM provider_documents p
        INNER JOIN documents d ON d.id = p.document_id
        WHERE p.provider_id = :provider_id AND d.name = :name";

        return DB::selectOne($sql, [
            'provider_id' => $provider_id,
            'name'  => 'Pan Card'
        ]);
    }
}
