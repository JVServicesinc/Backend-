<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\ProductCategory;
use ImageKit\ImageKit;

class ProductCategoryController extends Controller
{
    public function list()
    {
        return view('product-category.index', [
            'categories' => ProductCategory::getCategories()
        ]);
    }

    public function add()
    {
        return view('product-category.create', [
            'parent_categories' => ProductCategory::getParentCategoires()
        ]);
    }

    public function store(Request $request)
    {
        $data = [];
        $data['name'] = $request->input('name');
        $data['namefr'] = $request->input('namefr');
        $data['slug'] = strtolower(str_replace(' ', '-', $data['name']));
        if( $request->input('parent_id') != '' ) {
            $data['parent_id'] = $request->input('parent_id');
        }

        if($request->file('image')){
			$file= $request->file('image');

            $fileName = uniqid() . '.' . $file->getClientOriginalExtension();
            $file->move(public_path('uploads/'), $fileName);

            $imageKit = new ImageKit(
                env('IMAGEKIT_PUBLIC_KEY'),
                env('IMAGEKIT_PRIVATE_KEY'),
                env('IMAGEKIT_URL_ENDPOINT')
            );

            $uploadFile = $imageKit->uploadFile([
                'file' =>  fopen( public_path('uploads/'). $fileName, "r"),
                'fileName' => $fileName,
                'useUniqueFileName' => true
            ]);

            unlink( public_path('uploads/'). $fileName );
    
            $data['image_url']= $uploadFile->result->url;
		}

        ProductCategory::create($data);
        return redirect(route('product.category.list'))->withSuccess('Category added successfully');        
    }

    public function edit($id)
    {
        return view('product-category.edit', [
            'parent_categories' => ProductCategory::getParentCategoires(),
            'category' => ProductCategory::findOrFail($id)
        ]);
    }

    public function update($id, Request $request)
    {
        $category = ProductCategory::find($id);
    
        $data = [];
        $data['name'] = $request->input('name');
        $data['namefr'] = $request->input('namefr');
        $data['slug'] = strtolower(str_replace(' ', '-', $data['name']));

        $category->name = $data['name'];
        $category->namefr = $data['namefr'];
        $category->slug = $data['slug'];

        if( $request->input('parent_id') != '' ) {
            $category->parent_id = $request->input('parent_id');
        }

        if($request->file('image')){
			$file= $request->file('image');

            $fileName = uniqid() . '.' . $file->getClientOriginalExtension();
            $file->move(public_path('uploads/'), $fileName);

            $imageKit = new ImageKit(
                env('IMAGEKIT_PUBLIC_KEY'),
                env('IMAGEKIT_PRIVATE_KEY'),
                env('IMAGEKIT_URL_ENDPOINT')
            );

            $uploadFile = $imageKit->uploadFile([
                'file' =>  fopen( public_path('uploads/'). $fileName, "r"),
                'fileName' => $fileName,
                'useUniqueFileName' => true
            ]);

            unlink( public_path('uploads/'). $fileName );
    
            $category->image_url =  $uploadFile->result->url;
		}

        $category->save();

        return redirect(route('product.category.list'))->withSuccess('Category updated successfully');  
    }


    public function delete($id)
    {
        $category = ProductCategory::find($id);
        $category->delete();

        return redirect(route('product.category.list'))->withSuccess('Category deleted successfully'); 
    }
}