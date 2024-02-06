<x-master-layout>
    <div class="container-fluid">
        <div class="row">
            <div class="col-lg-12">
                <div class="card card-block card-stretch">
                    <div class="card-body p-0">
                        <div class="d-flex justify-content-between align-items-center p-3">
                            <h5 class="font-weight-bold">Add New Store Category</h5>
                            <a href="{{ route('product.category.list') }}" class="float-right btn btn-sm btn-primary"><i class="fa fa-angle-double-left"></i> Back</a>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-12">
                <div class="card">
                    <div class="card-body">
                        <form method="POST" action="{{ route('product.gallery.store', ['product_id' => $product_id]) }}" accept-charset="UTF-8" enctype="multipart/form-data">
                            @csrf
                            <div class="row">
                                <div class="form-group col-md-4 has-error has-danger">
                                    <label for="name" class="form-control-label">Images <span class="text-danger">*</span></label>
                                    <input class="form-control" required name="images[]" type="file" accept="image/*" multiple />
                                </div>
                            </div>
                            <input class="btn btn-md btn-primary float-left" type="submit" value="Save"/>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</x-master-layout>