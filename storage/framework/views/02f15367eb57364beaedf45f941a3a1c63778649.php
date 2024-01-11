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
                            <h5 class="font-weight-bold">Services</h5>
                            <a href="<?php echo e(route('services.add')); ?>" class="float-right mr-1 btn btn-sm btn-primary"><i class="fa fa-plus-circle"></i> Add New</a>
                        </div>
                        <div>
                            <div class="row">
                                <div class="col-md-12 table-responsive">
                                    <table class="table w-100 dataTable" id="dataTable">
                                        <thead>
                                            <tr>
                                                <th>Image</th>
                                                <th>Service Name</th>
                                                <th>Category</th>
                                                <th>Subcategory</th>
                                                <th>Price</th>
                                                <th>Status</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <?php foreach($services as $service) : ?>
                                            <tr>
                                                <td><img src="<?= env('IMAGEKIT_URL_ENDPOINT') . $service->image . '?tr=w-80,h-80' ?>"/></td>
                                                <td><?= $service->name ?></td>
                                                <td><?= $service->category_name ?></td>
                                                <td><?= $service->sub_category_name ?></td>
                                                <td>$<?= $service->price ?></td>
                                                <td><?= $service->status == 1 ? '<span class="badge badge-success">Active</span>' : '<span class="badge badge-danger">Inactive</span>' ?></td>
                                                <td>
                                                    <a class="mr-2" href="<?php echo e(route('services.slots.list', $service->id)); ?>" title="Slots">
                                                        <i class="fas fa-clock"></i>
                                                    </a>
                                                    <a class="mr-2" href="<?php echo e(route('services.edit', $service->id)); ?>" title="Update Service">
                                                        <i class="fas fa-pen text-secondary"></i>
                                                    </a>
                                                    <a class="mr-2" href="<?php echo e(route('services.delete', $service->id)); ?>" title="Delete Service">
                                                        <i class="far fa-trash-alt text-danger"></i>
                                                    </a>
                                                </td>
                                            </tr>
                                            <?php endforeach ?>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
<script>
window.addEventListener("load", () => {
    $('#dataTable').DataTable({});
});
</script>
 <?php echo $__env->renderComponent(); ?>
<?php endif; ?>
<?php if (isset($__componentOriginalc6e081c8432fe1dd6b4e43af4871c93447ee9b23)): ?>
<?php $component = $__componentOriginalc6e081c8432fe1dd6b4e43af4871c93447ee9b23; ?>
<?php unset($__componentOriginalc6e081c8432fe1dd6b4e43af4871c93447ee9b23); ?>
<?php endif; ?><?php /**PATH G:\Jvservices\resources\views/service/index.blade.php ENDPATH**/ ?>