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
                            <h5 class="font-weight-bold">Add New Store Category</h5>
                            <a href="<?php echo e(route('product.category.list')); ?>" class="float-right btn btn-sm btn-primary"><i class="fa fa-angle-double-left"></i> Back</a>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-12">
                <div class="card">
                    <div class="card-body">
                        <form method="POST" action="<?php echo e(route('product.category.store')); ?>" accept-charset="UTF-8" enctype="multipart/form-data">
                            <?php echo csrf_field(); ?>
                            <input name="id" type="hidden">
                            <div class="row">
                                <div class="form-group col-md-4 has-error has-danger">
                                    <label for="name" class="form-control-label">Category Name <span class="text-danger">*</span></label>
                                    <input placeholder="Name" class="form-control" required name="name" type="text"/>
                                </div>
                                <div class="form-group col-md-4 has-error has-danger">
                                    <label for="name" class="form-control-label">Category Name <img src="../../images/flags/fr.png" style="width:30px"><span class="text-danger">*</span></label>
                                    <input placeholder="Name" class="form-control" required name="namefr" type="text"/>
                                </div>
                                <div class="form-group col-md-4">
                                    <label for="color" class="form-control-label">Parent Category</label>
                                    <select class="form-control" name="parent_id">
                                        <option value="">Select...</option>
                                        <?php foreach($parent_categories as $data) : ?>
                                        <option value="<?= $data->id ?>"><?= $data->name ?></option>
                                        <?php endforeach?>
                                    </select>
                                </div>
                                <div class="form-group col-md-4 has-error has-danger">
                                    <label for="name" class="form-control-label">Category Image <span class="text-danger">*</span></label>
                                    <input class="form-file" required name="image" type="file" accept="image/*"/>
                                </div>
                            </div>
                            
                            <input class="btn btn-md btn-primary float-left" type="submit" value="Save"/>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
 <?php echo $__env->renderComponent(); ?>
<?php endif; ?>
<?php if (isset($__componentOriginalc6e081c8432fe1dd6b4e43af4871c93447ee9b23)): ?>
<?php $component = $__componentOriginalc6e081c8432fe1dd6b4e43af4871c93447ee9b23; ?>
<?php unset($__componentOriginalc6e081c8432fe1dd6b4e43af4871c93447ee9b23); ?>
<?php endif; ?><?php /**PATH G:\Jvservices\resources\views/product-category/create.blade.php ENDPATH**/ ?>