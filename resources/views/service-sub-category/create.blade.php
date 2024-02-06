<x-master-layout>
    <div class="container-fluid">
        <div class="row">
            <div class="col-lg-12">
                <div class="card card-block card-stretch">
                    <div class="card-body p-0">
                        <div class="d-flex justify-content-between align-items-center p-3">
                            <h5 class="font-weight-bold">Add New Sub Category</h5>
                            <a href="{{ route('service.subcategory.list') }}" class="float-right btn btn-sm btn-primary"><i class="fa fa-angle-double-left"></i> Back</a>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-12">

                <form method="POST" action="{{ route('service.subcategory.store') }}" enctype="multipart/form-data">
                    @csrf
                    <div class="card">
                        <div class="card-body">
                            <div class="row">
                                <div class="form-group col-md-4">
                                    <label class="form-control-label">Sub Category Name <span class="text-danger">*</span></label>
                                    <input class="form-control" name="name" type="text" />
                                </div>

                                <div class="form-group col-md-4">
                                    <label class="form-control-label">Sub Category Name <img src="../../images/flags/fr.png" style="width:30px"><span class="text-danger">*</span></label>
                                    <input class="form-control" name="namefr" type="text" />
                                </div>


                                <div class="form-group col-md-4">
                                    <label class="form-control-label">Category<span class="text-danger">*</span></label>
                                    <select class="form-control" name="category_id">
                                        <option value="">Select...</option>
                                        <?php foreach ($categoires as $category) : ?>
                                            <option value="<?= $category->id ?>"><?= $category->name ?></option>
                                        <?php endforeach ?>
                                    </select>
                                </div>

                                <div class="form-group col-md-4">
                                    <label class="form-control-label">Status<span class="text-danger">*</span></label>
                                    <select class="form-control" name="status">
                                        <option value="1">Active</option>
                                        <option value="0">Inactive</option>
                                    </select>
                                </div>

                                <div class="form-group col-md-4">
                                    <label class="form-control-label">Description<span class="text-danger">*</span></label>
                                    <textarea class="form-control" name="description"/></textarea>
                                </div>
                             
                                <div class="form-group col-md-4">
                                    <label class="form-control-label">Description <img src="../../images/flags/fr.png" style="width:30px"><span class="text-danger">*</span></label>
                                    <textarea class="form-control" name="descriptionfr"/></textarea>
                                </div>


                                <div class="form-group col-md-4">
                                    <label class="form-control-label">Image<span class="text-danger">*</span></label>
                                    <input type="file" class="form-file" name="image" accept="image/*"/>
                                </div>
                            </div>
                        </div>
                    </div>

                    <input class="btn btn-md btn-primary float-left mb-4" type="submit" value="Save" />
                </form>

            </div>
        </div>
    </div>
</x-master-layout>