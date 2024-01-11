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
                            <h5 class="font-weight-bold">Store Orders</h5>
                        </div>
                        <div>
                            <div class="row">
                                <div class="col-md-12 table-responsive">
                                    <table class="table w-100 dataTable" id="dataTable">
                                        <thead>
                                            <tr>
                                                <th>Order ID</th>
                                                <th>Customer</th>
                                                <th>Subtotal</th>
                                                <th>Total Tax</th>
                                                <th>Total</th>
                                                <th>Status</th>
                                                <th>Order Date</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
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
    $('#dataTable').DataTable({
        processing: true,
        serverSide: true,
        ajax: {
            url: "<?= route("orders.datatable") ?>",
        },
        lengthChange: true,
        columns: [
            { "data": "order_id"},
            { "data": "customer_name" },
            { "data": "subtotal"},
            { "data": "total_tax" },
            { "data": "total" },
            { "data": "status" },
            { "data": "created_at" },
            { "data": "action_links" }
        ]
    });
});
</script>
 <?php echo $__env->renderComponent(); ?>
<?php endif; ?>
<?php if (isset($__componentOriginalc6e081c8432fe1dd6b4e43af4871c93447ee9b23)): ?>
<?php $component = $__componentOriginalc6e081c8432fe1dd6b4e43af4871c93447ee9b23; ?>
<?php unset($__componentOriginalc6e081c8432fe1dd6b4e43af4871c93447ee9b23); ?>
<?php endif; ?><?php /**PATH G:\Jvservices\resources\views/order/index.blade.php ENDPATH**/ ?>