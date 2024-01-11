<x-master-layout>
    <div class="container-fluid">
        <div class="row">
            <div class="col-lg-12">
                <div class="card card-block card-stretch">
                    <div class="card-body p-0">
                        <div class="d-flex justify-content-between align-items-center p-3">
                            <h5 class="font-weight-bold">Edit Product - <?= $product->name ?></h5>
                            <a href="{{ route('product.list') }}" class="float-right btn btn-sm btn-primary"><i class="fa fa-angle-double-left"></i> Back</a>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-lg-12">
                <form method="POST" action="{{ route('product.update', $product->id) }}" accept-charset="UTF-8" enctype="multipart/form-data">
                    @csrf
                    <div class="card">
                        <div class="card-body">
                            <div class="row">
                                <div class="form-group col-md-4">
                                    <label class="form-control-label">Product Name <span class="text-danger">*</span></label>
                                    <input class="form-control" name="name" type="text" value="<?= $product->name ?>"/>
                                </div>
                                <div class="form-group col-md-4">
                                    <label class="form-control-label">Product SKU <span class="text-danger">*</span></label>
                                    <input class="form-control" name="sku" type="text" value="<?= $product->sku ?>" />
                                </div>
                                <div class="form-group col-md-4">
                                    <label class="form-control-label">Category<span class="text-danger">*</span></label>
                                    <select class="form-control" name="category_id">
                                        <option value="">Select...</option>
                                        <?php foreach ($categories as $cat) : ?>
                                            <option value="<?= $cat->id ?>" <?= $cat->id == $product->category_id ? 'selected' : '' ?>><?= $cat->name ?></option>
                                        <?php endforeach ?>
                                    </select>
                                </div>
                                <div class="form-group col-md-4">
                                    <label class="form-control-label">Units in Stock<span class="text-danger">*</span></label>
                                    <input class="form-control" name="units_in_stock" type="text" value="<?= $product->units_in_stock ?>"/>
                                </div>
                                <div class="form-group col-md-4">
                                    <label class="form-control-label">Product Image</label>
                                    <input class="form-control" name="product_image" type="file" />
                                </div>
                                <div class="form-group col-md-4">
                                    <label class="form-control-label">Listing status <span class="text-danger">*</span></label>
                                    <select class="form-control" name="listing_status">
                                        <option value="active" <?= $product->listing_status == 'active' ? 'selected' : '' ?>>Active</option>
                                        <option value="inactive" <?= $product->listing_status == 'inactive' ? 'selected' : '' ?>>Inactive</option>
                                    </select>
                                </div>

                                <div class="form-group col-md-6">
                                    <label class="form-control-label">Product Description <span class="text-danger">*</span></label>
                                    <textarea class="form-control" name="desp"><?= $product->desp ?></textarea>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="card">
                        <div class="card-body">
                            <p>Pricing</p>
                            <div class="row">
                                <div class="form-group col-md-4">
                                    <label class="form-control-label">Price <span class="text-danger">*</span></label>
                                    <input class="form-control" name="price" type="text" value="<?= $product->price->price ?>" />
                                </div>
                                <div class="form-group col-md-4">
                                    <label class="form-control-label">Sale Price <span class="text-danger">*</span></label>
                                    <input class="form-control" name="sale_price" type="text" value="<?= $product->price->sale_price ?>"/>
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