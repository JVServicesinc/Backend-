<?php

namespace App\DataTables;
use App\Traits\DataTableTrait;

use App\Models\Service;
use Yajra\DataTables\Html\Button;
use Yajra\DataTables\Html\Column;
use Yajra\DataTables\Html\Editor\Editor;
use Yajra\DataTables\Html\Editor\Fields;
use Yajra\DataTables\Services\DataTable;
use Illuminate\Http\Request;
use App\Models\Category;
use App\Models\SubCategory;

class ServiceDataTable extends DataTable
{
    use DataTableTrait;
    /**
     * Build DataTable class.
     *
     * @param mixed $query Results from query() method.
     * @return \Yajra\DataTables\DataTableAbstract
     */
    public function dataTable($query,Request $request)
    {
        $this->requestData = $request->all();

        if(!empty($this->requestData)){
            $query = $this->query($this->requestData);
        }

        return datatables()
            ->eloquent($query)
            ->editColumn('category_id' , function ($service){
                return ($service->category_id != null && isset($service->category)) ? $service->category->name : '-';
            })
            ->filterColumn('category_id',function($query,$keyword){
                $query->whereHas('category',function ($q) use($keyword){
                    $q->where('name','like','%'.$keyword.'%');
                });
            })
            // ->editColumn('provider_id' , function ($service){
            //     return ($service->provider_val == null &&  isset($service->providers)) ? $service->providers->display_name : '';
            // })
            ->filterColumn('provider_id',function($query,$keyword){
                $query->whereHas('providers',function ($q) use($keyword){
                    $q->where('display_name','like','%'.$keyword.'%');
                });
            })
            ->editColumn('price' , function ($service){
                return getPriceFormat($service->price).'-'.ucFirst($service->type);
            })
            
            ->editColumn('discount' , function ($service){
                return $service->discount ? $service->discount .'%' : '-';
            })
            ->editColumn('status' , function ($service){
                $disabled = $service->deleted_at ? 'disabled': '';
                return '<div class="custom-control custom-switch custom-switch-text custom-switch-color custom-control-inline">
                    <div class="custom-switch-inner">
                        <input type="checkbox" class="custom-control-input bg-success change_status" '.$disabled.' data-type="service_status" '.($service->status ? "checked" : "").' value="'.$service->id.'" id="'.$service->id.'" data-id="'.$service->id.'" >
                        <label class="custom-control-label" for="'.$service->id.'" data-on-label="" data-off-label=""></label>
                    </div>
                </div>';
            })
            ->addColumn('action', function($service){
                return view('service.action',compact('service'))->render();
            })
            ->addIndexColumn()
            ->rawColumns(['action','status','is_featured']);
    }

    /**
     * Get query source of dataTable.
     *
     * @param \App\Models\Service $model
     * @return \Illuminate\Database\Eloquent\Builder
     */
    public function query($requestData = [])
    {
        $model = Service::query();

        if(auth()->user()->hasAnyRole(['admin'])){
            $model = $model->withTrashed();
            if($this->provider_id !== null){
                $model =  $model->where('provider_id', $this->provider_id );
            }
        }

        if(!empty($requestData)){
            $category_ids = [];
            $type = $requestData['type'] ?? null;
            switch ($type) {
                case Category::TYPE_CONSTRUCTION:
                    $category_ids = Category::where('ser_type_id',Category::TYPE_CONSTRUCTION)->pluck('id');
                    break;
                case Category::TYPE_SELF_CARE:
                    $category_ids = Category::where('ser_type_id',Category::TYPE_SELF_CARE)->pluck('id');
                    break;
                case Category::TYPE_HOME_CARE:
                    $category_ids = Category::where('ser_type_id',Category::TYPE_HOME_CARE)->pluck('id');
                    break;
                default:
                    
                    break;
            }

            if(count($category_ids) > 0){
                $model = $model->whereIn('category_id',$category_ids);
            }
        }

        return $model->newQuery()->myService();
    }
    /**
     * Get columns.
     *
     * @return array
     */
    protected function getColumns()
    {
        return [
            Column::make('DT_RowIndex')
                ->searchable(false)
                ->title(__('messages.srno'))
                ->orderable(false),
            Column::make('name'),
            // Column::make('provider_id')
            //     ->title(__('messages.provider')),
            Column::make('category_id')
                ->title(__('messages.category')),
            Column::make('price'),
            Column::make('discount'),
            Column::make('status'),
            Column::computed('action')
                  ->exportable(false)
                  ->printable(false)
                  ->width(60)
                  ->addClass('text-center'),
        ];
    }

    /**
     * Get filename for export.
     *
     * @return string
     */
    protected function filename()
    {
        return 'Service_' . date('YmdHis');
    }
}
