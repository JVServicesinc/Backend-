<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Service;
use App\Models\Category as ServiceCategory;

class ServiceController extends Controller
{
    public function list()
    {
        return view('service.index', [
            'services' => Service::getServices()
        ]);
    }

    public function add()
    {
        return view('service.create', [
            'categoires' => ServiceCategory::all()
        ]);
    }

    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|max:255',
            'namefr' => 'required|max:255',
            'category_id' => 'required',
            'subcategory_id' => 'required',
            'duration'  => 'required',
            'description' => 'required',
            'descriptionfr' => 'required',
            'image'       => 'required',
            'price'       => 'required'
        ], [
            'category_id.required' => 'Category is required',
            'subcategory_id.required' => 'Subcategory is required',
            'duration.required' => 'Service duration is required',
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

        Service::create($data);

        return redirect(route('services.list'))->withSuccess('Service added successfully');
    }

    public function edit($service_id)
    {
        $service = Service::findOrFail($service_id);

        return view('service.edit', [
            'service'    => $service,
            'categoires' => ServiceCategory::all(),
            'subcategoires' => ServiceCategory::getSubcategoryByCategoryId($service->category_id)
        ]);
    }

    public function update(Request $request, $service_id)
    {
        $request->validate([
            'name' => 'required|max:255',
            'category_id' => 'required',
            'subcategory_id' => 'required',
            'duration'  => 'required',
            'description' => 'required',
            'price'       => 'required'
        ], [
            'category_id.required' => 'Category is required',
            'subcategory_id.required' => 'Subcategory is required',
            'duration.required' => 'Service duration is required',
        ]);

        $data = [
            'name' => $request->input('name'),
            'namefr' => $request->input('namefr'),
            'category_id' => $request->input('category_id'),
            'subcategory_id' => $request->input('subcategory_id'),
            'duration' => $request->input('duration'),
            'price' => $request->input('price'),
            'status' => $request->input('status'),
            'is_featured' => $request->input('is_featured'),
            'description' => $request->input('description'),
            'descriptionfr' => $request->input('descriptionfr')
        ];
        
        if($request->file('image')){
			$imagekitFile = imageKitFileUpload(
                $request->file('image')
            );

            if( $imagekitFile !== false ) {
                $data['image']= $imagekitFile;
            }
		}

        Service::where('id', $service_id)->update($data);

        return redirect(route('services.list'))->withSuccess('Service updated successfully');
    }

    public function delete($service_id)
    {
        $category = Service::findOrFail($service_id);
        $category->deleted_at = date('Y-m-d H:i:s');
        $category->save();

        return redirect(route('services.list'))->withSuccess('Service deleted successfully');
    }
}
