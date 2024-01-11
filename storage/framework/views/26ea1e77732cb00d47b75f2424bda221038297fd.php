<?php if (isset($component)) { $__componentOriginalc6e081c8432fe1dd6b4e43af4871c93447ee9b23 = $component; } ?>
<?php $component = $__env->getContainer()->make(App\View\Components\MasterLayout::class, []); ?>
<?php $component->withName('master-layout'); ?>
<?php if ($component->shouldRender()): ?>
<?php $__env->startComponent($component->resolveView(), $component->data()); ?>
<?php $component->withAttributes([]); ?>
    <div class="container-fluid">
        <div class="row">
            <div class="col-lg-12">
                <div class="card card-block card-stretch">
                    <div class="card-body p-0">
                        <div class="d-flex justify-content-between align-items-center p-3">
                            <h5 class="font-weight-bold">Update Sub Category</h5>
                            <a href="<?php echo e(route('service.subcategory.list')); ?>" class="float-right btn btn-sm btn-primary"><i class="fa fa-angle-double-left"></i> Back</a>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-12">

                <form method="POST" action="<?php echo e(route('service.subcategory.update', $subcategory->id)); ?>" enctype="multipart/form-data">
                    <?php echo csrf_field(); ?>
                    <div class="card">
                        <div class="card-body">
                            <div class="row">
                                <div class="form-group col-md-4">
                                    <label class="form-control-label">Sub Category Name <span class="text-danger">*</span></label>
                                    <input class="form-control" name="name" type="text" value="<?= $subcategory->name ?>" />
                                </div>


                                <div class="form-group col-md-4">
                                    <label class="form-control-label">Sub Category Name <img src="../../../images/flags/fr.png" style="width:30px"><span class="text-danger"><span class="text-danger">*</span></label>
                                    <input class="form-control" name="namefr" type="text" value="<?= $subcategory->namefr ?>" />
                                </div>


                                <div class="form-group col-md-4">
                                    <label class="form-control-label">Category<span class="text-danger">*</span></label>
                                    <select class="form-control" name="category_id">
                                        <option value="">Select...</option>
                                        <?php foreach ($categoires as $category) : ?>
                                            <option value="<?= $category->id ?>" <?= $category->id == $subcategory->category_id ? 'selected' : '' ?>><?= $category->name ?></option>
                                        <?php endforeach ?>
                                    </select>
                                </div>

                                <div class="form-group col-md-4">
                                    <label class="form-control-label">Status<span class="text-danger">*</span></label>
                                    <select class="form-control" name="status">
                                        <option value="1" <?= $subcategory->status == 1 ? 'selected' : '' ?>>Active</option>
                                        <option value="0" <?= $subcategory->status == 0 ? 'selected' : '' ?>>Inactive</option>
                                    </select>
                                </div>

                                <div class="form-group col-md-4">
                                    <label class="form-control-label">Description<span class="text-danger">*</span></label>
                                    <textarea class="form-control" name="description"><?= $subcategory->description ?></textarea>
                                </div>

                                <div class="form-group col-md-4">
                                    <label class="form-control-label">Description <img src="../../../images/flags/fr.png" style="width:30px"> <span class="text-danger">*</span></label>
                                    <textarea class="form-control" name="descriptionfr"><?= $subcategory->descriptionfr ?></textarea>
                                </div>

                             
                                <div class="form-group col-md-4">
                                    <label class="form-control-label">Image</label>
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
 <?php echo $__env->renderComponent(); ?>
<?php endif; ?>
<?php if (isset($__componentOriginalc6e081c8432fe1dd6b4e43af4871c93447ee9b23)): ?>
<?php $component = $__componentOriginalc6e081c8432fe1dd6b4e43af4871c93447ee9b23; ?>
<?php unset($__componentOriginalc6e081c8432fe1dd6b4e43af4871c93447ee9b23); ?>
<?php endif; ?><?php /**PATH G:\Jvservices\resources\views/service-sub-category/edit.blade.php ENDPATH**/ ?>