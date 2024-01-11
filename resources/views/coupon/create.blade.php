<x-master-layout>
    <div class="container-fluid">
        <div class="row">
        <div class="col-lg-12">
                <div class="card card-block card-stretch">
                    <div class="card-body p-0">
                        <div class="d-flex justify-content-between align-items-center p-3">
                            <h5 class="font-weight-bold">Add Coupon</h5>
                            <a href="{{ route('coupon.index') }}" class="float-right btn btn-sm btn-primary"><i class="fa fa-angle-double-left"></i> {{ __('messages.back') }}</a>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-12">
                <div class="card">
                    <div class="card-body">
                        <form method="POST" action="{{ route('coupon.store') }}" enctype="multipart/form-data">
                            @csrf
                            <div class="card">
                                <div class="card-body">
                                    <div class="row">
                                        <div class="form-group col-md-4">
                                            <label class="form-control-label">Coupon Code <span class="text-danger">*</span></label>
                                            <input class="form-control" name="code" type="text" />
                                        </div>
                                        <div class="form-group col-md-4">
                                            <label class="form-control-label">Discount Type<span class="text-danger">*</span></label>
                                            <select class="form-control" name="discount_type">
                                                <option value="fixed">Fixed</option>
                                                <option value="percentage">Percentage</option>
                                            </select>
                                        </div>

                                        <div class="form-group col-md-4">
                                            <label class="form-control-label">Discount<span class="text-danger">*</span></label>
                                            <input type="number" name="discount" class="form-control"/>
                                        </div>

                                        <div class="form-group col-md-6">
                                            <label class="form-control-label">Expire Date<span class="text-danger">*</span></label>
                                            <input class="form-control" name="expire_date" type="date" />
                                        </div>
                                    
                                        <div class="form-group col-md-4">
                                            <label class="form-control-label">Image<span class="text-danger">*</span></label>
                                            <input class="form-control" type="file"  name="image" accecpt="image/*" />
                                        </div>

                                        <div class="form-group col-md-6">
                                            <label class="form-control-label">Description</span></label>
                                            <textarea class="form-control" name="desp" /></textarea>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <input class="btn btn-md btn-primary float-left mb-4" type="submit" value="Save" />
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</x-master-layout>