<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Spatie\MediaLibrary\HasMedia;
use Spatie\MediaLibrary\InteractsWithMedia;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Support\Facades\DB;

class Category extends Model implements HasMedia
{
    use HasFactory, InteractsWithMedia, SoftDeletes;

    protected $table = 'jv_service_categories';

    protected $fillable = [
        'name','namefr', 'image', 'description','descriptionfr','is_featured', 'status' , 'color','ser_type_id'
    ];

    const TYPE_CONSTRUCTION = 1;
    const TYPE_SELF_CARE = 2;
    const TYPE_HOME_CARE = 3;

    protected $casts = [
        'status'    => 'integer',
        'is_featured'  => 'integer',
    ];

    public function services() {
        return $this->hasMany(Service::class, 'category_id','id');
    }
	
	public function servicetype() {
        return $this->belongsTo('App\Models\Servicestype','ser_type_id','id')->withTrashed();
    }

    /**
     * Get service categories
     * 
     * @return array
     */
    public static function getServiceCategories()
    {
        $sql = "SELECT 
            c.*,
            t.name AS service_type
        FROM jv_service_categories c
        LEFT JOIN jv_service_types t ON t.id = c.ser_type_id
        WHERE c.deleted_at IS NULL
        ORDER BY c.id DESC";

        return DB::select($sql);
    }

    /**
     * Get subcategory id
     * 
     * @param int $category_id
     * @return array
     */
    public static function getSubcategoryByCategoryId($category_id)
    {
        $sql = "SELECT * FROM jv_service_subcategories WHERE category_id = :category_id";
        return DB::select($sql, ['category_id' => $category_id]);
    }
}
