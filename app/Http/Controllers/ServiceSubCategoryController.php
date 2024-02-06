<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Category;
use App\Models\SubCategory;

class ServiceSubCategoryController extends Controller
{
    public function list()
    {
        return view('service-sub-category.index', [
            'service_sub_categores' =>  SubCategory::getServiceSubCategories()
        ]);
    }

    public function add()
    {
        return view('service-sub-category.create', [
            'categoires' => Category::all()
        ]);
    }

    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|max:255',
            'category_id' => 'required',
            'status' => 'required',
            'description' => 'required',
            'image'       => 'required'
        ], [
            'category_id.required' => 'Category is required'
        ]);

        $data = $request->all();

        if($request->file('image')){
			$imagekitFile = imageKitFileUpload(
                $request->file('image')
            );

            if( $imagekitFile !== false ) {
                $data['sub_image']= $imagekitFile;
            }
		}

        SubCategory::create($data);

        return redirect(route('service.subcategory.list'))->withSuccess('Service subcategory added successfully');
    }

    public function edit($sub_category_id)
    {
        $subcategory = SubCategory::findOrFail($sub_category_id);

        return view('service-sub-category.edit', [
            'subcategory'    => $subcategory,
            'categoires' => Category::all()
        ]);
    }

    public function update(Request $request, $sub_category_id)
    {
        $request->validate([
            'name' => 'required|max:255',
            'namefr' => 'required|max:255',
            'category_id' => 'required',
            'status' => 'required',
            'description' => 'required',
            'descriptionfr' => 'required',
        ], [
            'category_id.required' => 'Category is required'
        ]);

        $data = [
            'name' => $request->input('name'),
            'category_id' => $request->input('category_id'),
            'status' => $request->input('status'),
            'description' => $request->input('description')
        ];

        if($request->file('image')){
			$imagekitFile = imageKitFileUpload(
                $request->file('image')
            );

            if( $imagekitFile !== false ) {
                $data['sub_image']= $imagekitFile;
            }
		}

        SubCategory::where('id', $sub_category_id)->update($data);

        return redirect(route('service.subcategory.list'))->withSuccess('Service subcategory updated successfully');
    }

    public function delete($sub_category_id)
    {
        $category = SubCategory::findOrFail($sub_category_id);
        $category->deleted_at = date('Y-m-d H:i:s');
        $category->save();

        return redirect(route('service.subcategory.list'))->withSuccess('Service subcategory deleted successfully');
    }
}