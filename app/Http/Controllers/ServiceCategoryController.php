<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Category;
use App\Models\Servicestype;

class ServiceCategoryController extends Controller
{
    public function list()
    {
        return view('service-category.index', [
            'service_categores' =>  Category::getServiceCategories()
        ]);
    }

    public function add()
    {
        return view('service-category.create', [
            'service_types' => Servicestype::all()
        ]);
    }

    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|max:255',
            'ser_type_id' => 'required',
            'status' => 'required',
            'description' => 'required',
            'is_featured' => 'required',
            'image'       => 'required'
        ], [
            'ser_type_id.required' => 'Service type required',
            'is_featured.required' => 'Description is required',
        ]);

        $data = $request->all();

        if($request->file('image')){
		 $imagekitFile = imageKitFileUpload(
                $request->file('image')
            );

            if( $imagekitFile !== false ) {
                $data['image']= $imagekitFile;
            }
		}

        Category::create($data);

        return redirect(route('service.category.list'))->withSuccess('Service category added successfully');
    }

    public function edit($service_category_id)
    {
        $category = Category::findOrFail($service_category_id);

        return view('service-category.edit', [
            'category'    => $category,
            'service_types' => Servicestype::all()
        ]);
    }

    public function update(Request $request, $service_category_id)
    {
        $request->validate([
            'name' => 'required|max:255',
            'ser_type_id' => 'required',
            'status' => 'required',
            'description' => 'required',
            'is_featured' => 'required'
        ], [
            'ser_type_id.required' => 'Service type required',
            'is_featured.required' => 'Description is required',
        ]);

        $data = [
            'name' => $request->input('name'),
            'namefr' => $request->input('namefr'),
            'ser_type_id' => $request->input('ser_type_id'),
            'status' => $request->input('status'),
            'description' => $request->input('description'),
            'descriptionfr' => $request->input('descriptionfr'),
            'is_featured' => $request->input('is_featured')
        ];

        if($request->file('image')){
			$imagekitFile = imageKitFileUpload(
                $request->file('image')
            );

            if( $imagekitFile !== false ) {
                $data['image']= $imagekitFile;
            }
		}

        Category::where('id', $service_category_id)->update($data);

        return redirect(route('service.category.list'))->withSuccess('Service category updated successfully');
    }

    public function delete($service_category_id)
    {
        $category = Category::findOrFail($service_category_id);
        $category->deleted_at = date('Y-m-d H:i:s');
        $category->save();

        return redirect(route('service.category.list'))->withSuccess('Service category deleted successfully');
    }

    public function get_subcategory_list(Request $request)
    {
        $category_id = $request->get('category_id');

        $subcategories = Category::getSubcategoryByCategoryId($category_id);

        $list = '<option value="">Select...</option>';
        foreach($subcategories as $cat) {
            $list .= sprintf('<option value="%s">%s</option>', $cat->id, $cat->name);
        }

        return response($list);
    }

}
