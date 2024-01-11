
<?php
    $auth_user= authSession();
?>
{{ Form::open(['route' => ['category.destroy', $category->id], 'method' => 'delete','data--submit'=>'category'.$category->id]) }}
<div class="d-flex justify-content-end align-items-center">
    <a class="mr-2" href="{{ route('category.create',['id' => $category->id]) }}" title="{{ __('messages.update_form_title',['form' => __('messages.category') ]) }}"><i class="fas fa-pen text-secondary"></i></a>
    <a class="mr-2" href="javascript:void(0)" data--submit="category{{$category->id}}" 
        data--confirmation='true' data-title="{{ __('messages.delete_form_title',['form'=>  __('messages.category') ]) }}"
        title="{{ __('messages.delete_form_title',['form'=>  __('messages.category') ]) }}"
        data-message='{{ __("messages.delete_msg") }}'>
        <i class="far fa-trash-alt text-danger"></i>
    </a>
</div>
{{ Form::close() }}