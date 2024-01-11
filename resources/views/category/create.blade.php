<x-master-layout>
    <div class="container-fluid">
        <div class="row">
        <div class="col-lg-12">
                <div class="card card-block card-stretch">
                    <div class="card-body p-0">
                        <div class="d-flex justify-content-between align-items-center p-3">
                            <h5 class="font-weight-bold">{{ $pageTitle ?? trans('messages.list') }}</h5>
                            @if($auth_user->can('category list'))
                                <a href="{{ route('category.index') }}?type={{ $type }}" class="float-right btn btn-sm btn-primary"><i class="fa fa-angle-double-left"></i> {{ __('messages.back') }}</a>
                            @endif
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-12">
                <div class="card">
                    <div class="card-body">
                        {{ Form::model($categorydata,['method' => 'POST','route'=>'category.store', 'enctype'=>'multipart/form-data', 'data-toggle'=>"validator" ,'id'=>'category'] ) }}
                            {{ Form::hidden('id') }}
                            <div class="row">
                                <div class="form-group col-md-4">
                                    {{ Form::label('name',trans('messages.name').' <span class="text-danger">*</span>',['class'=>'form-control-label'], false ) }}
                                    {{ Form::text('name',old('name'),['placeholder' => trans('messages.name'),'class' =>'form-control','required']) }}
                                    <small class="help-block with-errors text-danger"></small>
                                </div>
                                
                                <div class="form-group col-md-4">
                                    {{ Form::label('color',trans('messages.color'), ['class' => 'form-control-label']) }}
                                    {{ Form::color('color',null, ['placeholder' => trans('messages.color'),'class' =>'form-control' ,'id' => 'color']) }}
                                </div>
                                
                                <div class="form-group col-md-4">
                                    {{ Form::label('status',trans('messages.status').' <span class="text-danger">*</span>',['class'=>'form-control-label'],false) }}
                                    {{ Form::select('status',['1' => __('messages.active') , '0' => __('messages.inactive') ],old('status'),[ 'id' => 'role' ,'class' =>'form-control select2js','required']) }}
                                </div>

                                @if(!empty($type))
                                    <input type="hidden" name="ser_type_id" value="{{ $type }}">
                                @endif
								<div class="form-group col-md-4">
                                    {{ Form::label('type_id','Services Type'.' <span class="text-danger">*</span>',['class'=>'form-control-label'],false) }}
									   @if(!empty($type))
    									   <select id="type_id" name="type_id" class="select2js form-group" disabled>
                                                @if(count($servicestypes) > 0)
                                                    @foreach($servicestypes as $service_type)
                                                        <option value="{{ $service_type->id }}" @if($type == $service_type->id) selected @endif>
                                                            {{ $service_type->name }}
                                                        </option>
                                                    @endforeach
                                                @endif                           
                                           </select>
                                       @else
                                        <select id="type_id" name="type_id" class="select2js form-group" disabled>
                                                @if(count($servicestypes) > 0)
                                                    @foreach($servicestypes as $service_type)
                                                        <option value="{{ $service_type->id }}" @if($service_type->id == $categorydata->ser_type_id) selected @endif>
                                                            {{ $service_type->name }}
                                                        </option>
                                                    @endforeach
                                                @endif                           
                                           </select>
                                       @endif
            
                                </div>
                                <div class="form-group col-md-4">
                                    <label class="form-control-label" for="category_image">{{ __('messages.image') }} </label>
                                    <div class="custom-file">
                                        <input type="file" name="category_image" class="custom-file-input" accept="image/*">
                                        <label class="custom-file-label">{{  __('messages.choose_file',['file' =>  __('messages.image') ]) }}</label>
                                    </div>
                                    <span class="selected_file"></span>
                                </div>

                                @if(getMediaFileExit($categorydata, 'category_image'))
                               
                                    <div class="col-md-2 mb-2">
                                        @php
                                            $extention = imageExtention(getSingleMedia($categorydata,'category_image'));
                                            $res=str_replace("http://54.89.88.9/public","http://54.89.88.9/jv_services/uploads/",getSingleMedia($categorydata,'category_image'));
                                       
                                             $temp= json_decode($categorydata,true);
                                             $img=$temp['media'][0];
                                           $rr= "../uploads/".$img['id']."/".$img['file_name'];
                                            @endphp

                                        <img id="category_image_preview" src="{{$rr}}" alt="#" class="attachment-image mt-1" style="background-color:{{ $extention == 'svg' ? $categorydata->color : '' }};width:100px;height:100px">
                                            <a class="text-danger remove-file" href="{{ route('remove.file', ['id' => $categorydata->id, 'type' => 'category_image']) }}"
                                                data--submit="confirm_form"
                                                data--confirmation='true'
                                                data--ajax="true"
                                                title='{{ __("messages.remove_file_title" , ["name" =>  __("messages.image") ]) }}'
                                                data-title='{{ __("messages.remove_file_title" , ["name" =>  __("messages.image") ]) }}'
                                                data-message='{{ __("messages.remove_file_msg") }}'>
                                                <i class="ri-close-circle-line"></i>
                                            </a>
                                    </div>
                                @endif

                                
                                <div class="form-group col-md-12">
                                    {{ Form::label('description',trans('messages.description'), ['class' => 'form-control-label']) }}
                                    {{ Form::textarea('description', null, ['class'=>"form-control textarea" , 'rows'=>3  , 'placeholder'=> __('messages.description') ]) }}
                                </div>
                            </div>
                            <div class="row">
                                <div class="form-group col-md-6">
                                    <div class="custom-control custom-checkbox custom-control-inline">
                                        <!-- <input type="checkbox" name="is_featured" value="1" class="custom-control-input" id="is_featured"> -->
                                        {{ Form::checkbox('is_featured', $categorydata->is_featured, null, ['class' => 'custom-control-input' , 'id' => 'is_featured' ]) }}
                                        <label class="custom-control-label" for="is_featured">{{ __('messages.set_as_featured')  }}
                                        </label>
                                    </div>
                                </div>
                            </div>
                            {{ Form::submit( trans('messages.save'), ['class'=>'btn btn-md btn-primary float-right']) }}
                        {{ Form::close() }}
                    </div>
                </div>
            </div>
        </div>
    </div>
</x-master-layout>