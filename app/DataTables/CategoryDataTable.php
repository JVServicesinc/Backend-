<?php

namespace App\DataTables;

use App\Traits\DataTableTrait;
use App\Models\Category;
use Yajra\DataTables\Html\Column;
use Yajra\DataTables\Services\DataTable;
use Illuminate\Http\Request;

class CategoryDataTable extends DataTable
{
    use DataTableTrait;

    protected $requestData;
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
            ->editColumn('status' , function ($category){
                $disabled = $category->trashed() ? 'disabled': '';
                return '<div class="custom-control custom-switch custom-switch-text custom-switch-color custom-control-inline">
                    <div class="custom-switch-inner">
                        <input type="checkbox" class="custom-control-input bg-success change_status" data-type="category_status" '.($category->status ? "checked" : "").'  '.$disabled.' value="'.$category->id.'" id="'.$category->id.'" data-id="'.$category->id.'">
                        <label class="custom-control-label" for="'.$category->id.'" data-on-label="" data-off-label=""></label>
                    </div>
                </div>';
            })
			->editColumn('ser_type_id' , function ($category){
                return ($category->ser_type_id != null && isset($category->servicetype)) ? $category->servicetype->name : '-';
            })
            ->editColumn('is_featured' , function ($category){
                $disabled = $category->trashed() ? 'disabled': '';

                return '<div class="custom-control custom-switch custom-switch-text custom-switch-color custom-control-inline">
                    <div class="custom-switch-inner">
                        <input type="checkbox" class="custom-control-input bg-success change_status" data-type="category_featured" data-name="is_featured" '.($category->is_featured ? "checked" : "").'  '.  $disabled.' value="'.$category->id.'" id="f'.$category->id.'" data-id="'.$category->id.'">
                        <label class="custom-control-label" for="f'.$category->id.'" data-on-label="'.__("messages.yes").'" data-off-label="'.__("messages.no").'"></label>
                    </div>
                </div>';
            })
            ->addColumn('action', function($category){
                return view('category.action',compact('category'))->render();
            })
            ->addIndexColumn()
            ->rawColumns(['action','status','is_featured']);
    }

    /**
     * Get query source of dataTable.
     *
     * @param \App\Models\Category $model
     * @return \Illuminate\Database\Eloquent\Builder
     */
    public function query($requestData = [])
    {
        $model = Category::query();

        if(auth()->user()->hasAnyRole(['admin'])){
            $model = $model->withTrashed();
        }

        if(!empty($requestData)){
            $type = $requestData['type'] ?? null;
            switch ($type) {
                case Category::TYPE_CONSTRUCTION:
                    $model->where('ser_type_id',Category::TYPE_CONSTRUCTION);
                    break;
                case Category::TYPE_SELF_CARE:
                    $model->where('ser_type_id',Category::TYPE_SELF_CARE);
                    break;
                case Category::TYPE_HOME_CARE:
                    $model->where('ser_type_id',Category::TYPE_HOME_CARE);
                    break;
                default:
                    
                    break;
            }

        }

        return $model->newQuery();
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
                ->title(__('messages.no'))
                ->orderable(false),
            Column::make('name'),      
			// Column::make('ser_type_id')
   //                  ->title('Type'),
            Column::make('color'),
            Column::make('is_featured')
                ->title(__('messages.featured')),
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
        return 'Category_' . date('YmdHis');
    }
}
