<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Spatie\MediaLibrary\HasMedia;
use Spatie\MediaLibrary\InteractsWithMedia;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Support\Facades\DB;

class SubCategory extends Model implements HasMedia
{
    use HasFactory, InteractsWithMedia,SoftDeletes;

    protected $table = 'jv_service_subcategories';

    protected $fillable = [
        'name','namefr', 'description','descriptionfr', 'is_featured', 'status' , 'category_id','sub_image'
    ];

    protected $casts = [
        'status'    => 'integer',
        'is_featured'  => 'integer',
        'category_id'  => 'integer',
    ];

    public function category() {
        return $this->belongsTo('App\Models\Category','category_id','id')->withTrashed();
    }

    public function services() {
        return $this->hasMany(Service::class, 'subcategory_id','id');
    }

    /**
     * Get service categories
     * 
     * @return array
     */
    public static function getServiceSubCategories()
    {
        $sql = "SELECT 
            sc.*,
            c.name AS category_name,
            t.name AS service_type
        FROM jv_service_subcategories sc
        LEFT JOIN jv_service_categories c ON c.id = sc.category_id
        LEFT JOIN jv_service_types t ON t.id = c.ser_type_id
        WHERE sc.deleted_at IS NULL
        ORDER BY c.id DESC";

        return DB::select($sql);
    }
}
