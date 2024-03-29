
<?php
    $auth_user= authSession();
?>
{{ Form::open(['route' => ['providertype.destroy', $providertype->id], 'method' => 'delete','data--submit'=>'providertype'.$providertype->id]) }}
<div class="d-flex justify-content-end align-items-center">
    @if(!$providertype->trashed())
    <a class="mr-2" href="{{ route('providertype.create',['id' => $providertype->id]) }}" title="{{ __('messages.update_form_title',['form' => __('messages.providertype') ]) }}"><i class="fas fa-pen text-secondary"></i></a>
    <a class="mr-2 text-danger" href="javascript:void(0)" data--submit="providertype{{$providertype->id}}" 
        data--confirmation='true' data-title="{{ __('messages.delete_form_title',['form'=>  __('messages.providertype') ]) }}"
        title="{{ __('messages.delete_form_title',['form'=>  __('messages.providertype') ]) }}"
        data-message='{{ __("messages.delete_msg") }}'>
        <i class="far fa-trash-alt"></i>
    </a>
    @endif
    @if(auth()->user()->hasAnyRole(['admin']) && $providertype->trashed())
        <a class="mr-2" href="{{ route('providertype.action',['id' => $providertype->id, 'type' => 'restore']) }}"
            title="{{ __('messages.restore_form_title',['form' => __('messages.providertype') ]) }}"
            data--submit="confirm_form"
            data--confirmation='true'
            data--ajax='true'
            data-title="{{ __('messages.restore_form_title',['form'=>  __('messages.providertype') ]) }}"
            data-message='{{ __("messages.restore_msg") }}'
            data-datatable="reload">
            <i class="fas fa-redo text-secondary"></i>
        </a>
        <a href="{{ route('providertype.action',['id' => $providertype->id, 'type' => 'forcedelete']) }}"
            title="{{ __('messages.forcedelete_form_title',['form' => __('messages.providertype') ]) }}"
            data--submit="confirm_form"
            data--confirmation='true'
            data--ajax='true'
            data-title="{{ __('messages.forcedelete_form_title',['form'=>  __('messages.providertype') ]) }}"
            data-message='{{ __("messages.forcedelete_msg") }}'
            data-datatable="reload"
            class="mr-2">
            <i class="far fa-trash-alt text-danger"></i>
        </a>
    @endif
</div>
{{ Form::close() }}