
<?php
    $auth_user= authSession();
?>
{{ Form::open(['route' => ['category.destroy', $category->id], 'method' => 'delete','data--submit'=>'category'.$category->id]) }}
<div class="d-flex justify-content-end align-items-center">
    <a class="mr-2" href="{{ route('category.create',['id' => $category->id]) }}" title="{{ __('messages.update_form_title',['form' => __('messages.category') ]) }}"><i class="fas fa-pen text-secondary"></i></a>
    <a href="{{ route('category.action',['id' => $category->id, 'type' => 'forcedelete']) }}"
        title="{{ __('messages.forcedelete_form_title',['form' => __('messages.category') ]) }}"
        data--submit="confirm_form"
        data--confirmation='true'
        data--ajax='true'
        data-title="{{ __('messages.forcedelete_form_title',['form'=>  __('messages.category') ]) }}"
        data-message='{{ __("messages.forcedelete_msg") }}'
        data-datatable="reload"
        class="mr-2">
        <i class="far fa-trash-alt text-danger"></i>
    </a>
</div>
{{ Form::close() }}