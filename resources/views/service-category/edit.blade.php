<x-master-layout>
    <div class="container-fluid">
        <div class="row">
            <div class="col-lg-12">
                <div class="card card-block card-stretch">
                    <div class="card-body p-0">
                        <div class="d-flex justify-content-between align-items-center p-3">
                            <h5 class="font-weight-bold">Update Category</h5>
                            <a href="{{ route('service.category.list') }}" class="float-right btn btn-sm btn-primary"><i class="fa fa-angle-double-left"></i> Back</a>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-12">

                <form method="POST" action="{{ route('service.category.update', $category->id) }}" enctype="multipart/form-data">
                    @csrf
                    <div class="card">
                        <div class="card-body">
                            <div class="row">
                                <div class="form-group col-md-4">
                                    <label class="form-control-label">Category Name <span class="text-danger">*</span></label>
                                    <input class="form-control" name="name" type="text" value="<?= $category->name ?>"/>
                                </div>
                                <div class="form-group col-md-4">
                                    <label class="form-control-label">Category Name <img src="../../../images/flags/fr.png" style="width:30px"><span class="text-danger">*</span></label>
                                    <input class="form-control" name="namefr" type="text" value="<?= $category->namefr ?>"/>
                                </div>
                                <div class="form-group col-md-4">
                                    <label class="form-control-label">Service Type<span class="text-danger">*</span></label>
                                    <select class="form-control" name="ser_type_id">
                                        <option value="">Select...</option>
                                        <?php foreach ($service_types as $service_type) : ?>
                                            <option value="<?= $service_type->id ?>" <?= $category->ser_type_id == $service_type->id ? 'selected' : '' ?> ><?= $service_type->name ?></option>
                                        <?php endforeach ?>
                                    </select>
                                </div>

                                <div class="form-group col-md-4">
                                    <label class="form-control-label">Status<span class="text-danger">*</span></label>
                                    <select class="form-control" name="status">
                                        <option value="1" <?= $category->status == 1 ? 'selected' : '' ?>>Active</option>
                                        <option value="0" <?= $category->status == 0 ? 'selected' : '' ?>>Inactive</option>
                                    </select>
                                </div>

                                <div class="form-group col-md-6">
                                    <label class="form-control-label">Description<span class="text-danger">*</span></label>
                                    <textarea class="form-control" name="description"/><?= $category->description ?></textarea>
                                </div>

                                <div class="form-group col-md-6">
                                    <label class="form-control-label">Description <img src="../../../images/flags/fr.png" style="width:30px"><span class="text-danger">*</span></label>
                                    <textarea class="form-control" name="descriptionfr"/><?= $category->descriptionfr ?></textarea>
                                </div>

                             
                                <div class="form-group col-md-4">
                                    <label class="form-control-label">Is Featured<span class="text-danger">*</span></label>
                                    <select class="form-control" name="is_featured">
                                        <option value="1" <?= $category->is_featured == 1 ? 'selected' : '' ?>>Yes</option>
                                        <option value="0" <?= $category->is_featured == 0 ? 'selected' : '' ?>>No</option>
                                    </select>
                                </div>

                                <div class="form-group col-md-4">
                                    <label class="form-control-label">Image</label>
                                    <input type="file" class="form-control" name="image" accept="image/*"/>
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