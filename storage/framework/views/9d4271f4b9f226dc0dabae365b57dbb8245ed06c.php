<?php if (isset($component)) { $__componentOriginalc6e081c8432fe1dd6b4e43af4871c93447ee9b23 = $component; } ?>
<?php $component = $__env->getContainer()->make(App\View\Components\MasterLayout::class, []); ?>
<?php $component->withName('master-layout'); ?>
<?php if ($component->shouldRender()): ?>
<?php $__env->startComponent($component->resolveView(), $component->data()); ?>
<?php $component->withAttributes([]); ?>
    <div class="container-fluid">
        <div class="row">
            <div class="modal fade" id="adminModal" tabindex="-1" aria-labelledby="adminModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="adminModalLabel"><?php echo e(__('messages.dashboard_customizer')); ?></h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                    <?php echo e(Form::open(['method' => 'POST','route' => 'togglesetting'])); ?>

                    
                        <?php if(($data['dashboard_setting'] != [] && !empty($data['dashboard_setting']->Top_Cards)) || $show == "true"): ?>         
                            <?php echo e(Form::checkbox('Top Cards', "top_card",true)); ?> <?php echo e(__('messages.dashboard_card_title',['name' => __('messages.top')] )); ?><br>       
                        <?php else: ?>
                            <?php echo e(Form::checkbox('Top Cards', "top_card",false)); ?> <?php echo e(__('messages.dashboard_card_title',['name' => __('messages.top')] )); ?><br>       
                        <?php endif; ?>

                        <?php if(($data['dashboard_setting'] != [] && !empty($data['dashboard_setting']->Monthly_Revenue_card)) || $show == "true"): ?>    
                            <?php echo e(Form::checkbox('Monthly Revenue card', "monthly_revenue_card", true)); ?> <?php echo e(__('messages.dashboard_card_title',['name' => __('messages.monthly_revenue')] )); ?><br>       
                        <?php else: ?>
                            <?php echo e(Form::checkbox('Monthly Revenue card', "monthly_revenue_card", false)); ?> <?php echo e(__('messages.dashboard_card_title',['name' => __('messages.monthly_revenue')] )); ?><br>      
                        <?php endif; ?>

                        <?php if(($data['dashboard_setting'] != [] && !empty($data['dashboard_setting']->Top_Services_card)) || $show == "true"): ?>        
                            <?php echo e(Form::checkbox('Top Services card', "top_service_card", true)); ?> <?php echo e(__('messages.dashboard_card_title',['name' => __('messages.top_services')] )); ?><br>       
                        <?php else: ?>
                            <?php echo e(Form::checkbox('Top Services card', "top_service_card", false)); ?> <?php echo e(__('messages.dashboard_card_title',['name' => __('messages.top_services')] )); ?><br>      
                        <?php endif; ?>
                     
                        <?php if(($data['dashboard_setting'] != [] && !empty($data['dashboard_setting']->New_Provider_card)) || $show == "true"): ?>          
                            <?php echo e(Form::checkbox('New Provider card', "new_provider_card", true)); ?> <?php echo e(__('messages.dashboard_card_title',['name' => __('messages.top_services')] )); ?><br>       
                        <?php else: ?>
                            <?php echo e(Form::checkbox('New Provider card', "new_provider_card", false)); ?> <?php echo e(__('messages.dashboard_card_title',['name' => __('messages.top_services')] )); ?><br>      
                        <?php endif; ?>
                      
                        <?php if(($data['dashboard_setting'] != [] && !empty($data['dashboard_setting']->Upcoming_Booking_card)) || $show == "true"): ?>             
                            <?php echo e(Form::checkbox('Upcoming Booking card', "upcoming_booking_card", true)); ?> <?php echo e(__('messages.dashboard_card_title',['name' => __('messages.dashboard_upcomming_booking')] )); ?><br>    
                        <?php else: ?>
                            <?php echo e(Form::checkbox('Upcoming Booking card', "upcoming_booking_card", false)); ?> <?php echo e(__('messages.dashboard_card_title',['name' => __('messages.dashboard_upcomming_booking')] )); ?><br>      
                        <?php endif; ?>
                      
                        <?php if(($data['dashboard_setting'] != [] && !empty($data['dashboard_setting']->New_Customer_card)) || $show == "true"): ?>         
                            <?php echo e(Form::checkbox('New Customer card', "new_customer_card", true)); ?> <?php echo e(__('messages.dashboard_card_title',['name' => __('messages.new_customer')] )); ?><br>      
                        <?php else: ?>
                            <?php echo e(Form::checkbox('New Customer card', "new_customer_card", false)); ?> <?php echo e(__('messages.dashboard_card_title',['name' => __('messages.new_customer')] )); ?><br>      
                        <?php endif; ?>
                   
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                        <?php echo e(Form::submit('Save', ['class' => 'btn btn-primary'])); ?>

                    <?php echo e(Form::close()); ?>

                    </div>
                    </div>
                </div>
            </div>
            <?php if(($data['dashboard_setting'] != [] && !empty($data['dashboard_setting']->Top_Cards)) || $show == "true"): ?>
            <div class="col-md-12">
                <div class="row">
                    <div class="col-md-3">
                        <div class="card">
                            <div class="card-body">
                                <div class="row">
                                    <div class="col">
                                        <div class="d-flex flex-wrap justify-content-start align-items-center">
                                            <h5 class="mb-2 text-primary font-weight-bold"><?php echo e(!empty($data['dashboard']['count_total_booking']) ? $data['dashboard']['count_total_booking']: 0); ?> </h5>
                                        </div>
                                        <p class="mb-0 text-secondary"><?php echo e(__('messages.total_name', ['name' => __('messages.booking')])); ?></p>
                                    </div>
                                    <div class="col-auto d-flex flex-column">
                                        <div class="iq-card-icon icon-shape bg-soft-primary text-primary rounded-circle shadow">
                                            <i class="ri-calendar-check-line"></i>
                                        </div>
                                        <a class="pt-2" href="<?php echo e('#'); ?>"><?php echo e(__('messages.view_all')); ?></a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card">
                            <div class="card-body">
                                <div class="row">
                                    <div class="col">
                                        <div class="d-flex flex-wrap justify-content-start align-items-center">
                                            <h5 class="mb-2 text-primary font-weight-bold"><?php echo e(!empty($data['dashboard']['count_total_service']) ? $data['dashboard']['count_total_service'] : 0); ?></h5>
                                        </div>
                                        <p class="mb-0 text-secondary"><?php echo e(__('messages.total_name', ['name' => __('messages.service')])); ?></p>
                                    </div>
                                    <div class="col-auto d-flex flex-column">
                                        <div class="iq-card-icon icon-shape bg-soft-warning text-white rounded-circle shadow">
                                            <i class="ri-service-line"></i>
                                        </div>
                                        <a class="pt-2" href="<?php echo e('#'); ?>"><?php echo e(__('messages.view_all')); ?></a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card">
                            <div class="card-body">
                                <div class="row">
                                    <div class="col">
                                        <div class="d-flex flex-wrap justify-content-start align-items-center">
                                            <h5 class="mb-2 text-primary font-weight-bold"><?php echo e(!empty($data['dashboard']['count_total_provider']) ? $data['dashboard']['count_total_provider'] : 0); ?></h5>
                                            <p class="mb-0 ml-3 text-danger font-weight-bold"></p>
                                        </div>
                                        <p class="mb-0 text-secondary"><?php echo e(__('messages.total_name', ['name' => __('messages.provider')])); ?></p>
                                    </div>
                                    <div class="col-auto d-flex flex-column">
                                        <div class="iq-card-icon icon-shape bg-success text-white rounded-circle shadow">
                                            <i class="la la-users"></i>
                                        </div>
                                        <a class="pt-2" href="<?php echo e(route('provider.index')); ?>"><?php echo e(__('messages.view_all')); ?></a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card">
                            <div class="card-body">
                                <div class="row">
                                    <div class="col">
                                        <div class="d-flex flex-wrap justify-content-start align-items-center">
                                            <h5 class="mb-2 text-primary font-weight-bold"><?php echo e(getPriceFormat(round($data['total_revenue']))); ?></h5>
                                            <p class="mb-0 ml-3 text-danger font-weight-bold"></p>
                                        </div>
                                        <p class="mb-0 text-secondary"><?php echo e(__('messages.total_name', ['name' => __('messages.revenue')])); ?></p>
                                    </div>
                                    <div class="col-auto d-flex flex-column">
                                        <div class="iq-card-icon icon-shape bg-success text-white rounded-circle shadow">
                                            <i class="ri-secure-payment-line"></i>
                                        </div>
                                        <a class="pt-2" href="<?php echo e(route('payment.index')); ?>"><?php echo e(__('messages.view_all')); ?></a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <?php endif; ?>
            <?php if(($data['dashboard_setting'] != [] && !empty($data['dashboard_setting']->Monthly_Revenue_card)) || $show == "true"): ?> 
            <div class="col-md-12">
                <div class="card">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center flex-wrap">
                            <h4 class="font-weight-bold"><?php echo e(__('messages.monthly_revenue')); ?></h4>
                        </div>
                        <div id="monthly-revenue" class="custom-chart"></div>
                    </div>
                </div>
            </div>
            <?php endif; ?>
            <?php if(($data['dashboard_setting'] != [] && !empty($data['dashboard_setting']->Top_Services_card)) || $show == "true"): ?>        
            <div class="col-md-6">
                <div class="card card-block card-height">
                    <div class="d-flex justify-content-between align-items-center p-3"> 
                        <h5 class="font-weight-bold"><?php echo e(__('messages.top_services')); ?></h5>
                        <a href="<?php echo e('#'); ?>" class="float-right mr-1 btn btn-sm btn-primary"><?php echo e(__('messages.see_all')); ?></a>
                    </div>
                    <div class="card-body-list">
                        <table class="table table-spacing mb-0">
                            <tbody>
                                <?php if(count($data['dashboard']['top_services_list']) > 0): ?>
                                    <?php $__currentLoopData = $data['dashboard']['top_services_list']; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $services): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                                        
                                        <?php
                                            $image = getSingleMedia($services->service,'service_attachment', null);
                                            $file_extention = config('constant.IMAGE_EXTENTIONS');
                                            $extention = in_array(strtolower(imageExtention($image)),$file_extention);
                                        ?>
                                        <tr class="white-space-no-wrap">
                                            <td class="p-2">
                                                <div class="active-project-1 d-flex align-items-center mt-0 ">
                                                    <div class="h-avatar is-medium">
                                                        <?php if($extention): ?>
                                                            <img class="avatar rounded-circle" alt="user-icon" src="<?php echo e($image); ?>">
                                                        <?php else: ?>
                                                            <img class="avatar rounded-circle" alt="user-icon" src="<?php echo e(asset('images/file.png')); ?>">
                                                        <?php endif; ?>
                                                    </div>
                                                    <div class="data-content">
                                                        <div>
                                                            <span class="font-weight-bold"><?php echo e(optional($services->service)->name ?? '-'); ?></span>                           
                                                        </div>
                                                    </div>
                                                </div>
                                            </td>
                                            
                                            <td class="pl-0 py-3">
                                                <?php echo e(getPriceFormat(optional($services->service)->price ?? 0)); ?>

                                            </td>
                                        </tr>
                                    <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                                <?php else: ?>
                                <div class="data-not-found"><?php echo e(__('messages.not_found_entry',['name' => __('messages.service')] )); ?></div>
                                <?php endif; ?>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <?php endif; ?>
            <?php if(($data['dashboard_setting'] != [] && !empty($data['dashboard_setting']->New_Provider_card)) || $show == "true"): ?>          
            <div class="col-md-6">
                <div class="card">
                    <div class="d-flex justify-content-between align-items-center p-3">
                        <h5 class="font-weight-bold"><?php echo e(__('messages.new_provider')); ?></h4>
                        <a href="<?php echo e(route('provider.index')); ?>" class="float-right mr-1 btn btn-sm btn-primary"><?php echo e(__('messages.see_all')); ?></a>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive max-height-400">
                            <table class="table mb-0">
                                <thead class="table-color-heading">
                                <tr class="text-secondary">
                                    <th scope="col"><?php echo e(__('messages.date')); ?></th>
                                    <th scope="col"><?php echo e(__('messages.user')); ?></th>
                                    <th scope="col"><?php echo e(__('messages.email')); ?></th>
                                    <th scope="col" class="white-space-no-wrap"><?php echo e(__('messages.contact_number')); ?></th>
                                </tr>
                                </thead>
                                <tbody>
                                <?php $__currentLoopData = $data['dashboard']['new_provider']; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $provider): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                                    <tr class="white-space-no-wrap">
                                        <td> <?php echo e(date("d M Y", strtotime($provider->created_at))); ?></td>
                                        <td>
                                            <div class="active-project-1 d-flex align-items-center mt-0 ">
                                                <div class="h-avatar is-medium h-5">
                                                    <img class="avatar rounded-circle" alt="user-icon" src="<?php echo e(getSingleMedia($provider,'profile_image', null)); ?>">
                                                </div>
                                                <div class="data-content">
                                                    <div>
                                                        <span class="font-weight-bold"><?php echo e(!empty($provider->display_name) ? $provider->display_name : '-'); ?></span>                           
                                                    </div>
                                                </div>
                                            </div>                                        
                                        </td>
                                        <td>
                                            <p class="mb-0  d-flex justify-content-start align-items-center">
                                            <?php echo e(!empty($provider->email) ? $provider->email : '-'); ?>

                                            </p>
                                        </td>
                                        <td><?php echo e(!empty($provider->contact_number) ? $provider->contact_number : '-'); ?></td>
                                    </tr>
                                <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            <?php endif; ?>
            <?php if(($data['dashboard_setting'] != [] && !empty($data['dashboard_setting']->Upcoming_Booking_card)) || $show == "true"): ?> 
            <div class="col-md-6">
                <div class="card card-block card-height">
                    <div class="d-flex justify-content-between align-items-center p-3"> 
                        <h5 class="font-weight-bold"><?php echo e(__('messages.dashboard_upcomming_booking')); ?></h5>
                        <a href="<?php echo e('#'); ?>" class="float-right mr-1 btn btn-sm btn-primary"><?php echo e(__('messages.see_all')); ?></a>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive max-height-400">
                            <table class="table table-spacing mb-0">
                                <thead class="table-color-heading">
                                <tr class="text-secondary">
                                    <th scope="col"><?php echo e(__('messages.date')); ?></th>
                                    <th scope="col"><?php echo e(__('messages.service')); ?></th>
                                    <th scope="col"><?php echo e(__('messages.user')); ?></th>
                                </tr>
                                </thead>
                                <tbody>
                                    <?php if(count($data['dashboard']['upcomming_booking']) > 0): ?>
                                        <?php $__currentLoopData = $data['dashboard']['upcomming_booking']; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $booking): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                                            <tr class="white-space-no-wrap">
                                                <td>
                                                    <?php echo e(date("d M Y", strtotime($booking->date))); ?>

                                                </td>
                                                <td class="pl-0 py-3 ">
                                                    <?php echo e(optional($booking->service)->name ?? '-'); ?>

                                                </td>
                                                <td class="pl-0 py-3 font-weight-bold">
                                                    <?php echo e(optional($booking->customer)->display_name ?? '-'); ?>

                                                </td>
                                            </tr>
                                        <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                                    <?php else: ?>
                                    <div class="data-not-found"><?php echo e(__('messages.not_found_entry',['name' => __('messages.booking')] )); ?></div>
                                    <?php endif; ?>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            <?php endif; ?>
            <?php if(($data['dashboard_setting'] != [] && !empty($data['dashboard_setting']->New_Customer_card)) || $show == "true"): ?> 
            <div class="col-md-6">
                <div class="card">
                    <div class="d-flex justify-content-between align-items-center p-3">
                        <h5 class="font-weight-bold"><?php echo e(__('messages.new_customer')); ?></h4>
                        <a href="<?php echo e('#'); ?>" class="float-right mr-1 btn btn-sm btn-primary"><?php echo e(__('messages.see_all')); ?></a>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive max-height-400">
                            <table class="table mb-0">
                                <thead class="table-color-heading">
                                <tr class="text-secondary">
                                    <th scope="col"><?php echo e(__('messages.date')); ?></th>
                                    <th scope="col"><?php echo e(__('messages.user')); ?></th>
                                    <th scope="col"><?php echo e(__('messages.email')); ?></th>
                                    <th scope="col" class="white-space-no-wrap"><?php echo e(__('messages.contact_number')); ?></th>
                                </tr>
                                </thead>
                                <tbody>
                                <?php $__currentLoopData = $data['dashboard']['new_customer']; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $customer): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                                    <tr class="white-space-no-wrap">
                                        <td> <?php echo e(date("d M Y", strtotime($customer->created_at))); ?></td>
                                        <td>
                                            <div class="active-project-1 d-flex align-items-center mt-0 ">
                                                <div class="h-avatar is-medium h-5">
                                                    <img class="avatar rounded-circle" alt="user-icon" src="<?php echo e(getSingleMedia($customer,'profile_image', null)); ?>">
                                                </div>
                                                <div class="data-content">
                                                    <div>
                                                        <span class="font-weight-bold"><?php echo e(!empty($customer->display_name) ? $customer->display_name : '-'); ?></span>                           
                                                    </div>
                                                </div>
                                            </div>                                        
                                        </td>
                                        <td>
                                            <p class="mb-0  d-flex justify-content-start align-items-center">
                                               <?php echo e(!empty($customer->email) ? $customer->email : '-'); ?>

                                            </p>
                                        </td>
                                        <td><?php echo e(!empty($customer->contact_number) ? $customer->contact_number : '-'); ?></td>
                                    </tr>
                                <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            <?php endif; ?>
        </div>
    </div>
 <?php echo $__env->renderComponent(); ?>
<?php endif; ?>
<?php if (isset($__componentOriginalc6e081c8432fe1dd6b4e43af4871c93447ee9b23)): ?>
<?php $component = $__componentOriginalc6e081c8432fe1dd6b4e43af4871c93447ee9b23; ?>
<?php unset($__componentOriginalc6e081c8432fe1dd6b4e43af4871c93447ee9b23); ?>
<?php endif; ?>

<?php
/*
<script>
    var chartData = '<?php echo $data['category_chart']['chartdata']; ?>';
    var chartArray = JSON.parse(chartData);
    var chartlabel = '<?php echo $data['category_chart']['chartlabel']; ?>';
    var labelsArray = JSON.parse(chartlabel);

    if(jQuery('#monthly-revenue').length) {
        var options = {
        series: [{
            name: 'revenue',
            data: [ {{ implode ( ',' ,$data['revenueData'] ) }} ]
        }],
        chart: {
          height: 265,
          type: 'bar',
          toolbar:{
            show: true,
          },
          events: {
            click: function(chart, w, e) {
            }
          }
        },        
        plotOptions: {
            bar: {
                horizontal: false,
                s̶t̶a̶r̶t̶i̶n̶g̶S̶h̶a̶p̶e̶: 'flat',
                e̶n̶d̶i̶n̶g̶S̶h̶a̶p̶e̶: 'flat',
                borderRadius: 0,
                columnWidth: '70%',
                barHeight: '70%',
                distributed: false,
                rangeBarOverlap: true,
                rangeBarGroupRows: false,
                colors: {
                    ranges: [{
                        from: 0,
                        to: 0,
                        color: undefined
                    }],
                    backgroundBarColors: [],
                    backgroundBarOpacity: 1,
                    backgroundBarRadius: 0,
                },
                dataLabels: {
                    position: 'top',
                    maxItems: 100,
                    hideOverflowingLabels: true,
                }
            }
        },
        dataLabels: {
          enabled: false
        },
        grid: {
          xaxis: {
              lines: {
                  show: false
              }
          },
          yaxis: {
              lines: {
                  show: true
              }
          }
        },
        legend: {
          show: false
        },
        yaxis: {
          labels: {
          offsetY:0,
          minWidth: 20,
          maxWidth: 20
          },
        },
        xaxis: {
          categories: [
            'Jan',
            'Feb',
            'Mar',
            'Apr',
            'May',
            'June', 
            'Jul',
            'Aug',
            'Sep',
            'Oct',
            'Nov',
            'Dec'
          ],
          labels: {
            minHeight: 22,
            maxHeight: 22,
            style: {              
              fontSize: '12px'
            }
          }
        }
        };

        var chart = new ApexCharts(document.querySelector("#monthly-revenue"), options);
        chart.render();
    }

</script>
*/

?>
<?php /**PATH G:\Jvservices\resources\views/dashboard/dashboard.blade.php ENDPATH**/ ?>