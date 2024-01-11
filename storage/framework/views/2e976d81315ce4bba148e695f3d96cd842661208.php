<?php if (isset($component)) { $__componentOriginalc3251b308c33b100480ddc8862d4f9c79f6df015 = $component; } ?>
<?php $component = $__env->getContainer()->make(App\View\Components\GuestLayout::class, []); ?>
<?php $component->withName('guest-layout'); ?>
<?php if ($component->shouldRender()): ?>
<?php $__env->startComponent($component->resolveView(), $component->data()); ?>
<?php $component->withAttributes([]); ?>
    <div class="container">
        <div class="row no-gutters height-self-center">
            <div class="col-sm-12 text-center align-self-center">
                <div class="iq-error position-relative">
                        <img src="<?php echo e(asset('images/error/500.png')); ?>" class="img-fluid iq-error-img iq-error-img-dark mx-auto" alt="">
                        <img src="<?php echo e(asset('images/error/500-dark.png')); ?>" class="img-fluid iq-error-img" alt="">
                        <h2 class="mb-0">Oops! This Page is Not Working.</h2>
                        <p>The requested is Internal Server Error.</p>
                        <a class="btn btn-primary d-inline-flex align-items-center mt-3" href="<?php echo e(route('home')); ?>"><i class="ri-home-4-line"></i>Back to Home</a>
                </div>
            </div>
        </div>
    </div>
 <?php echo $__env->renderComponent(); ?>
<?php endif; ?>
<?php if (isset($__componentOriginalc3251b308c33b100480ddc8862d4f9c79f6df015)): ?>
<?php $component = $__componentOriginalc3251b308c33b100480ddc8862d4f9c79f6df015; ?>
<?php unset($__componentOriginalc3251b308c33b100480ddc8862d4f9c79f6df015); ?>
<?php endif; ?><?php /**PATH G:\Jvservices\resources\views/errors/500.blade.php ENDPATH**/ ?>