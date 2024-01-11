<!DOCTYPE html>
<html lang="<?php echo e(str_replace('_', '-', app()->getLocale())); ?>">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="csrf-token" content="<?php echo e(csrf_token()); ?>">

        <title><?php echo e(config('app.name', 'Laravel')); ?></title>

        <link rel="shortcut icon" class="site_favicon_preview" href="<?php echo e(getSingleMedia(settingSession('get'),'site_favicon',null)); ?>" />
        <link rel = "icon" href = "<?php echo e(asset('public/assetfront/images/logo.png')); ?>"    type = "image/x-icon">
        
        <!-- Fonts -->
        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700&display=swap">

        <!-- Styles -->
        <link rel="stylesheet" href="<?php echo e(asset('css/backend.css')); ?>">
        <link rel="stylesheet" href="<?php echo e(asset('css/fronted-custom.css')); ?>">



    </head>
    <body class=" " >

        <div class="wrapper">
            <?php echo e($slot); ?>

        </div>
         <?php echo $__env->make('partials._scripts', \Illuminate\Support\Arr::except(get_defined_vars(), ['__data', '__path']))->render(); ?>
    </body>
</html>
<?php /**PATH G:\Jvservices\resources\views/layouts/guest.blade.php ENDPATH**/ ?>