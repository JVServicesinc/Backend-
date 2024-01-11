<?php

namespace App\Http\Controllers;
use Validator;
use Illuminate\Http\Request;
use App\Models\ProductCategory;
use App\Models\Product;

class ProductController extends Controller
{ 
    public function list()
    {
        return view('product.index');
    }

    public function datatable(Request $request)
    {
        $limit = $request->get('length', 10);
        $offset = $request->get('start', 0);
        $search_key = $_GET['search']['value'];

        $product_data = Product::getProducts($limit, $offset, $search_key);

        return response()->json( array_merge($product_data, ['draw' => (int)$request->get('draw')  ]) );
    }

    public function add()
    {
        return view('product.create', [
            'categories' => ProductCategory::getCategories()
        ]);
    }

    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|max:255',
            'sku' => 'required|unique:jv_product',
            'category_id' => 'required',
            'units_in_stock' => 'required',
            'product_image' => 'required',
            'listing_status' => 'required',
            'desp'      => 'required',
            'price'     => 'required'
        ], [
            'category_id.required' => 'Category is required',
            'units_in_stock.required' => 'Unit in stock is required',
            'product_image.required' => 'Product image is required',
            'listing_status.required' => 'Listing status is required',
            'desp.required' => 'Description is required',
        ]);

        $data = $request->all();

        Product::addProduct($data);
        return redirect(route('product.list'))->withSuccess('Product added successfully');
    }

    public function edit($product_id)
    {
        $product = Product::getProductById($product_id);
        return view('product.edit', [
            'product'    => $product,
            'categories' => ProductCategory::getCategories()
        ]);
    }

    public function update(Request $request, $product_id)
    {
        $request->validate([
            'name' => 'required|max:255',
            'sku' => [
                'required',
                function ($attribute, $value, $fail)use($product_id)  {
                    $sql = "SELECT * FROM jv_product WHERE id <> :product_id AND sku = :sku";
                    $user = \Illuminate\Support\Facades\DB::selectOne($sql, ['product_id' => $product_id, 'sku' => $value]);
                    if( !is_null($user) ) {
                        $fail('SKU already exist');
                    }
                }
            ],
            'category_id' => 'required',
            'units_in_stock' => 'required',
            'listing_status' => 'required',
            'desp'      => 'required',
            'price'     => 'required'
        ], [
            'category_id.required' => 'Category is required',
            'units_in_stock.required' => 'Unit in stock is required',
            'listing_status.required' => 'Listing status is required',
            'desp.required' => 'Description is required',
        ]);

        $data = $request->all();

        Product::editProduct($data, $product_id);
        return redirect(route('product.list'))->withSuccess('Product updated successfully');
    }

    public function delete($product_id)
    {
        $product = Product::findOrFail($product_id);
        $product->is_archived = 1;
        $product->save();
        return redirect(route('product.list'))->withSuccess('Product deleted successfully');
    }
}
