<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;

class Product extends Model
{
    use HasFactory;

    protected $table = 'jv_product';

    protected $fillable = [
        'is_archived'
    ];

    /**
     * Add new product
     * 
     * @param array $post_data
     */
    public static function addProduct($post_data)
    {
        $imagekitFile = imageKitFileUpload(
            $post_data['product_image']
        );

        $product_image_url = NULL;
        if( $imagekitFile !== false ) {
            $product_image_url = $imagekitFile;
        }

        $product_id = DB::table('jv_product')->insertGetId([
            'name' => $post_data['name'],
            'slug' => strtolower(str_replace(' ', '-', $post_data['name'])),
            'desp' => $post_data['desp'],
            'sku'  => $post_data['sku'],
            'category_id'  => $post_data['category_id'],
            'units_in_stock'  => $post_data['units_in_stock'],
            'image_url' => $product_image_url,
            'listing_status' => $post_data['listing_status']
        ]);

        DB::table('jv_product_price')->insert([
            'product_id' => $product_id,
            'price' => $post_data['price'],
            'sale_price' => $post_data['sale_price'],
            'currency' => 'CAD'
        ]);
    }

    /**
     * Get products
     * 
     * @param int $limit
     * @param int $offset
     * @param string $search_key
     * @return array
     */
    public static function getProducts($limit = 10, $offset = 0, $search_key = '')
    {
        // find total record
        $sql = "SELECT IFNULL(COUNT(*), 0) AS total FROM jv_product WHERE is_archived = 0";
        $data = DB::selectOne($sql);
        $totalRecordData = $data->total;

        $where_clause = " WHERE 1 AND p.is_archived = 0 ";

        if( $search_key != '' ) {
            $where_clause .= " AND p.name LIKE '%".trim( htmlspecialchars($search_key) )."%' ";
        }

        // find total filtered records
        $sql = "SELECT COUNT(p.id) AS total FROM jv_product AS p $where_clause";
        $data = DB::selectOne($sql);
        $recordsFiltered = $data->total;

        $sql = "SELECT
            p.*,
            c.name AS category_name,
            product_price.price,
            product_price.sale_price
        FROM
            jv_product AS p
        LEFT JOIN jv_product_category AS c
        ON
            c.id = p.category_id
        INNER JOIN(
            SELECT product_id,
                price,
                sale_price,
                created_at
            FROM
                jv_product_price
            WHERE
                id = (
                SELECT
                    MAX(id)
                FROM
                    jv_product_price AS prod_price
                WHERE
                    prod_price.product_id = jv_product_price.product_id
            )
        ) AS product_price
        ON
            product_price.product_id = p.id
        $where_clause 
        ORDER BY
            p.id
        DESC
        LIMIT $limit
        OFFSET $offset";

        $products = DB::select($sql);
        
        foreach($products as $product) {
            $product_image_url = env('IMAGEKIT_URL_ENDPOINT') . $product->image_url;
            $product->image = '<img src="'.$product_image_url.'" width="80px" height="80px" />';
            $product->sale_price = !is_null($product->sale_price) ? '$'.$product->sale_price : '';
            $product->price = '$'.$product->price;

            $action_links = '';
            $gallery_image_url = route("product.gallery.list", $product->id);
            $action_links .= '<a class="mr-2" href="'.$gallery_image_url.'" title="Product Gallery"><i class="fas fa-images"></i></a>';

            $update_product_url = route("product.edit", $product->id);
            $action_links .= '<a class="mr-2" href="'.$update_product_url.'" title="Update Product"><i class="fas fa-pen text-secondary"></i></a>';

            $delete_product_url = route("product.delete", $product->id);
            $action_links .= '<a class="mr-2" href="'.$delete_product_url.'" title="Delete Product">
                            <i class="far fa-trash-alt text-danger"></i>
                        </a>';
            $product->action_links = $action_links;
        }

        return [
            'recordsTotal' => $totalRecordData,
            'recordsFiltered' => $recordsFiltered,
            'data' => $products
        ];
    }

    /**
     * Get products
     * 
     * @param int $limit
     * @param int $offset
     * @return array
     */
    public static function getProductsByCategoryId($category_id, $limit = 200, $offset = 0)
    {
        $sql = "SELECT
            p.*,
            get_image_url(p.image_url) AS image_url,
            c.name AS category_name,
            product_price.price,
            product_price.sale_price
        FROM
            jv_product AS p
        LEFT JOIN jv_product_category AS c
        ON
            c.id = p.category_id
        INNER JOIN(
            SELECT product_id,
                price,
                sale_price,
                created_at
            FROM
                jv_product_price
            WHERE
                id = (
                SELECT
                    MAX(id)
                FROM
                    jv_product_price AS prod_price
                WHERE
                    prod_price.product_id = jv_product_price.product_id
            )
        ) AS product_price
        ON
            product_price.product_id = p.id
        WHERE p.is_archived = 0 AND p.category_id = $category_id
        ORDER BY
            p.id
        DESC
        LIMIT $limit
        OFFSET $offset";

        return DB::select($sql);
    }

    /**
     * Get product by id
     * 
     * @param int $product_id
     * @return object
     */
    public static function getProductById($product_id)
    {
        $sql = "SELECT *, get_image_url(image_url) AS image_url 
        FROM jv_product 
        WHERE id = :product_id";

        $product = DB::selectOne($sql, ['product_id' => $product_id]);

        $sql = "SELECT * FROM jv_product_category WHERE id = :category_id";
        $product->category =  DB::selectOne($sql, ['category_id' => $product->category_id]);

        // get latest price
        $sql = "SELECT 
            id, 
            price,
            sale_price,
            currency,
            updated_at
            FROM jv_product_price
            WHERE product_id = :product_id
            ORDER BY id DESC
            LIMIT 1";
        $product->price = DB::selectOne($sql, ['product_id' => $product_id]);

        // get gallery image
        $sql = "SELECT * FROM jv_product_gallery WHERE product_id = :product_id";
        $gallery_images = DB::select($sql, ['product_id' => $product_id]);

        foreach($gallery_images as $image) {
            $image->image_url = asset('public/uploads/product-gallery/'.$image->image_url);
        }

        $product->gallery_images = $gallery_images;

        return $product;
    }


    /**
     * Get product by sku
     * 
     * @param string $product_sku
     * @return object
     */
    public static function getProductBySku($product_sku)
    {
        $sql = "SELECT * FROM jv_product WHERE sku = :product_sku";
        $product = DB::selectOne($sql, ['product_sku' => $product_sku]);

        $sql = "SELECT * FROM jv_product_category WHERE id = :category_id";
        $product->category =  DB::selectOne($sql, ['category_id' => $product->category_id]);

        // get latest price
        $sql = "SELECT 
            id, 
            price,
            sale_price,
            currency,
            updated_at
            FROM jv_product_price
            WHERE product_id = :product_id
            ORDER BY id DESC
            LIMIT 1";
        $product->price = DB::selectOne($sql, ['product_id' => $product->id]);

        // get gallery image
        $sql = "SELECT * FROM jv_product_gallery WHERE product_id = :product_id";
        $gallery_images = DB::select($sql, ['product_id' => $product->id]);

        foreach($gallery_images as $image) {
            $image->image_url = asset('public/uploads/product-gallery/'.$image->image_url);
        }

        $product->gallery_images = $gallery_images;

        return $product;
    }

    /**
     * Edit a product
     * 
     * @param array $post_data
     * @param int $product_id
     */
    public static function editProduct($post_data, $product_id)
    {
        $update_data = [
            'name' => $post_data['name'],
            'slug' => strtolower(str_replace(' ', '-', $post_data['name'])),
            'desp' => $post_data['desp'],
            'sku'  => $post_data['sku'],
            'category_id'  => $post_data['category_id'],
            'units_in_stock'  => $post_data['units_in_stock'],
            'listing_status' => $post_data['listing_status']
        ];

        if( array_key_exists('product_image', $post_data) ) {
            $imagekitFile = imageKitFileUpload(
                $post_data['product_image']
            );
            if( $imagekitFile !== false ) {
                $update_data['image_url'] = $imagekitFile;
            }
        }

        DB::table('jv_product')->where(['id' => $product_id])->update($update_data);

        // find product previous price
        $product = self::getProductById($product_id);

        if( $product->price->price != $post_data['price'] || $product->price->sale_price != $post_data['sale_price']) {
            // update product price
            DB::table('jv_product_price')->insert([
                'product_id' => $product_id,
                'price' => $post_data['price'],
                'sale_price' => $post_data['sale_price'],
                'currency' => 'CAD'
            ]);
        }
    }

    /**
     * Get trending products
     * 
     * @return array
     */
    public static function getTrendingProducts()
    {
        $sql = "SELECT
            p.*,
            get_image_url(p.image_url) AS image_url,
            c.name AS category_name,
            product_price.price,
            product_price.sale_price
        FROM
            jv_product AS p
        LEFT JOIN jv_product_category AS c
        ON
            c.id = p.category_id
        INNER JOIN(
            SELECT product_id,
                price,
                sale_price,
                created_at
            FROM
                jv_product_price
            WHERE
                id = (
                SELECT
                    MAX(id)
                FROM
                    jv_product_price AS prod_price
                WHERE
                    prod_price.product_id = jv_product_price.product_id
            )
        ) AS product_price
        ON
            product_price.product_id = p.id
        WHERE p.is_archived = 0
        ORDER BY p.id DESC
        LIMIT 10";

        return DB::select($sql);
    }
    
    /**
     * Find product ratings
     * 
     * @param int $product_id
     * @return array
     */
    public static function getProductRatings($product_id)
    {
        $sql = "SELECT 
        (SELECT IFNULL(COUNT(*), 0) FROM jv_product_ratings WHERE rating = 1 AND product_id = $product_id) AS 'one',
        (SELECT IFNULL(COUNT(*), 0) FROM jv_product_ratings WHERE rating = 2 AND product_id = $product_id) AS 'two',
        (SELECT IFNULL(COUNT(*), 0) FROM jv_product_ratings WHERE rating = 3 AND product_id = $product_id) AS 'three',
        (SELECT IFNULL(COUNT(*), 0) FROM jv_product_ratings WHERE rating = 4 AND product_id = $product_id) AS 'four',
        (SELECT IFNULL(COUNT(*), 0) FROM jv_product_ratings WHERE rating = 5 AND product_id = $product_id) AS 'five',
        (SELECT IFNULL(COUNT(*), 0) FROM jv_product_ratings WHERE rating IS NOT NULL AND product_id = $product_id) AS 'total_ratings',
        (SELECT IFNULL(COUNT(*), 0) FROM jv_product_ratings WHERE review IS NOT NULL AND product_id = $product_id) AS 'total_reviews'";

        $weighted_avarage_data = DB::selectOne($sql);

        // now find avarage
        try {
            $avarage = ( 1 * $weighted_avarage_data->one + 2 * $weighted_avarage_data->two + 3 * $weighted_avarage_data->three + 4 * $weighted_avarage_data->four + 5 * $weighted_avarage_data->five ) / (
                $weighted_avarage_data->one + $weighted_avarage_data->two + $weighted_avarage_data->three + $weighted_avarage_data->four + $weighted_avarage_data->five
            );
        } catch( \DivisionByZeroError $e ) {
            $avarage = 0;
        }

        $data = [
            'avarage_rating' => round($avarage, 1),
            'rating_map'     => [
                1   => $weighted_avarage_data->one,
                2   => $weighted_avarage_data->two,
                3   => $weighted_avarage_data->three,
                4   => $weighted_avarage_data->four,
                5   => $weighted_avarage_data->five,
            ],
            'total_ratings' => $weighted_avarage_data->total_ratings,
            'total_reviews' => $weighted_avarage_data->total_reviews
        ];

        return $data;
    }

    public static function isProductWishlisted($product_id, $customer_id, $type='product')
    {
        $sql = "SELECT * FROM jv_wishlist WHERE customer_id =  $customer_id AND ref_id = $product_id AND type='$type'";
        $data = DB::selectOne($sql);

        if( is_null($data) ) {
            return false;
        }

        return true;
    }

    public static function compareProducts($product_ids)
    {
        // find products
        $sql = "SELECT
            p.*,
            c.name AS category_name,
            product_price.price,
            product_price.sale_price
        FROM
            jv_product AS p
        LEFT JOIN jv_product_category AS c
        ON
            c.id = p.category_id
        INNER JOIN(
            SELECT product_id,
                price,
                sale_price,
                created_at
            FROM
                jv_product_price
            WHERE
                id = (
                SELECT
                    MAX(id)
                FROM
                    jv_product_price AS prod_price
                WHERE
                    prod_price.product_id = jv_product_price.product_id
            )
        ) AS product_price
        ON
            product_price.product_id = p.id
        WHERE p.is_archived = 0 AND p.id IN($product_ids)";

        $products = DB::select($sql);

        foreach($products as $product) {
            $product->image_url = env('IMAGEKIT_URL_ENDPOINT') . $product->image_url;
            $product->rating = self::getProductRatings($product->id);
        }

        $compare_data = [];

        foreach ($products as $key => $data) {
            foreach ($data as $field => $value) {
                $compare_data[$field][$key] = $value;
            }
        }

        return  $compare_data;
    }

    public static function getProductReviews($product_id, $offset=0, $limit=10)
    {
        $sql = "SELECT 
            r.id,
            r.rating,
            r.review,
            u.full_name AS customer_name,
            r.created_at
        FROM jv_product_ratings r
        INNER JOIN users u ON u.id = r.customer_id
        WHERE r.review IS NOT NULL AND r.product_id = $product_id
        LIMIT $limit
        OFFSET $offset";

        return DB::select($sql);
    }
}
