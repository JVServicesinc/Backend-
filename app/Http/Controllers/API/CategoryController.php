<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Category;
use App\Models\SubCategory;
use App\Models\Servicestype;
use Illuminate\Support\Facades\DB;
use App\Http\Resources\API\CategoryResource;

class CategoryController extends Controller
{
    public function getCategoryList(Request $request)
    {
        $data = DB::select("SELECT t1.id,t2.`name` as type,t1.name, concat(t3.id,'/',t3.file_name) as file 
        FROM jv_service_categories AS t1 
        join jv_service_types AS t2 on t1.`ser_type_id`=t2.id 
        left join media t3 on t1.id = t3.model_id 
        where t1.status=1");

        foreach($data as $cat) {
            $cat->file = asset('public/uploads/'.$cat->file);
        }

        return response()->json(['status' => true, 'data' => $data]);
    }

    public function getCategoryListAll(){ 
		
		$category = Category::where('status',1)->get();
		
		 foreach ($category as $key => $value) {
                 $sub_category = SubCategory::where('category_id',$value->id)->where('status',1)->get();
                 $category[$key]['subcate'] = $sub_category; 
       }
		return response()->json(['status' => 1, 'data' => $category , 'message'=>'success']);
	}

    public function getServiceTypeCategoryList(Request $request){

        $getServiceType = Servicestype::select('id as service_type_id','name')->where('status',1)->get();
        
        foreach($getServiceType as $serviceType){

            $items = [];

            $category = Category::query()
                ->where([
                    'status' => 1,
                    'ser_type_id' => $serviceType->service_type_id
                ])
                ->orderBy('name','asc')
                ->take(10)
                ->get();

            if($category->count() > 0){
                $items = CategoryResource::collection($category);
            }

            $serviceType->jv_service_categories = $items;
        }
        
        return response()->json([
            'status' => true,
            'data' => $getServiceType,
            'message' => 'Service List Found Successfully'
        ]);
    }

	public function getCategoryListOld(Request $request){

        $category = Category::where('status',1);

        if($request->has('is_featured')){
            $category->where('is_featured',$request->is_featured);
        }

        $per_page = config('constant.PER_PAGE_LIMIT');
        if( $request->has('per_page') && !empty($request->per_page)){
            if(is_numeric($request->per_page)){
                $per_page = $request->per_page;
            }
            if($request->per_page === 'all' ){
                $per_page = $category->count();
            }
        }

        $category = $category->orderBy('name','asc')->paginate($per_page);
        $items = CategoryResource::collection($category);

        $response = [
            'pagination' => [
                'total_items' => $items->total(),
                'per_page' => $items->perPage(),
                'currentPage' => $items->currentPage(),
                'totalPages' => $items->lastPage(),
                'from' => $items->firstItem(),
                'to' => $items->lastItem(),
                'next_page' => $items->nextPageUrl(),
                'previous_page' => $items->previousPageUrl(),
            ],
            'data' => $items,
        ];
        
        return comman_custom_response($response);
    }

}