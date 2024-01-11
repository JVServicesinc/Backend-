<?php

namespace App\Models;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;

class ProductCategory extends Model
{
    /**
     * The table associated with the model.
     *
     * @var string
     */
    protected $table = 'jv_product_category';

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = ['name','namefr', 'slug', 'parent_id', 'image_url'];

    public static function getCategories()
    {
        $sql = "SELECT 
            c1.id, 
            c1.name, 
            c1.namefr, 
            c1.slug,
            c1.image_url,
            (
                SELECT name FROM jv_product_category
                WHERE id = c1.parent_id
            ) AS parent_category
        FROM jv_product_category AS c1
        ORDER BY c1.id DESC";

        return DB::select($sql);
    }

    /**
     * Get parent categories
     * 
     * @retun array
     */
    public static function getParentCategoires()
    {
        $sql = "SELECT * FROM jv_product_category WHERE parent_id IS NULL";
        return DB::select($sql);
    }
}
