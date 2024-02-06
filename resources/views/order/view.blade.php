<x-master-layout>
<div class="container-fluid">
    <div class="row">
        <div class="col-lg-12">
            <div class="row">
                <div class="col-lg-8">
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="card card-block card-stretch">
                                <div class="card-body p-0">
                                    <div class="d-flex justify-content-between align-items-center p-3">
                                        <h5 class="font-weight-bold">Order Details</h5>
                                        <a href="{{ route('orders.list') }}   " class="float-right btn btn-sm btn-primary"><i class="fa fa-angle-double-left"></i> {{ __('messages.back') }}</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-12">
                            <div class="card card-block card-stretch">
                                <div class="card-body p-0">
                                    <div class="d-flex justify-content-between align-items-center p-3">
                                        <h5 class="font-weight-bold">Order ID - {{ '#' . $order->uniq_order_id }} </h5>
                                    </div>

                                    <ul class="list-group">
                                        <li class="list-group-item">Subtotal - $<?= $order->subtotal ?></li>
                                        <li class="list-group-item">GST - $<?= $order->tax_gst ?></li>
                                        <li class="list-group-item">QST - $<?= $order->tax_qst ?></li>
                                        <li class="list-group-item">Discount - $<?= $order->discount ?></li>
                                        <li class="list-group-item">Total - $<?= $order->total ?></li>
                                        <li class="list-group-item">Order Status - <?= ucfirst($order->order_status) ?></li>
                                    </ul>
                                </div>
                            </div>

                            <div class="card card-block card-stretch mt-5">
                                <div class="card-body">
                                    <div class="d-flex">
                                        <h5 class="font-weight-bold">Order Items</h5>
                                    </div>

                                    <div class="mt-4">

                                        <table class="table table-bordered">
                                            <thead>
                                                <tr>
                                                    <th scope="col">#</th>
                                                    <th scope="col">Service Name</th>
                                                    <th scope="col">Quantity</th>
                                                    <th scope="col">Price</th>
                                                    <th scope="col">Line Total</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <?php foreach($order->line_items as $key => $item) : ?>
                                                    <tr>
                                                        <th scope="row"><?= ++$key ?></th>
                                                        <td><?= $item->product_name ?></td>
                                                        <td><?= $item->qty ?></td>
                                                        <td>$<?= $item->unit_price ?></td>
                                                        <td>$<?= round( floatval($item->unit_price) * $item->qty, 2) ?></td>
                                                    </tr>
                                                <?php endforeach ?>
                                            </tbody>
                                        </table>
                                        
                                    </div>
                                </div>
                            </div>

                            <?php $payment_details = json_decode($order->stripe_payment_ref, true); ?>

                            <?php if( !is_null( $payment_details ))  : ?>

                            <div class="card card-block card-stretch mt-5">
                                <div class="card-body">
                                    <div class="d-flex">
                                        <h5 class="font-weight-bold">Payment Info</h5>
                                    </div>
                                    <div class="mt-4">
                                        <?php foreach($payment_details as $key => $p) : ?>
                                            <?php if( !is_array($p) ) : ?>
                                                <p><?= ucfirst(str_replace('_', ' ', $key)) ?> - <?= $p ?></p>
                                            <?php else: ?>
                                                <p><?= ucfirst(str_replace('_', ' ', $key)) ?> - <?= implode(',', $p) ?></p>
                                            <?php endif ?>
                                        <?php endforeach ?>
                                    </div>
                                </div>
                            </div>

                            <?php endif ?>
                            
                            <div class="card card-block card-stretch mt-5">
                                <div class="card-body">
                                    <div class="d-flex">
                                        <h5 class="font-weight-bold">Shipping Details</h5>
                                    </div>

                                    <div class="mt-4">
                                        <?php $shipping_address = json_decode($order->shipping_address); ?>

                                        <p><?= $shipping_address->first_name ?> <?= $shipping_address->last_name ?></p>
                                        <p><?= $shipping_address->street_address ?></p>
                                        <p><?= $shipping_address->province ?> <?= $shipping_address->zip_code ?></p>
                                        <p><?= $shipping_address->country_name ?></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-4">
                    <div class="row">   
                        <div class="col-sm-3 col-lg-12">
                            <h4>Customer Details</h4>
                            <div class="card card-block card-stretch card-height">
                                <div class="card-body">
                                    <div class="profile-card rounded mb-3">
                                        <h3 class="text-white text-center">{{ $order->customer->full_name ?? '-'}}</h3>
                                    </div>
                                    <div class="d-flex align-items-center mb-3">
                                            <div class="p-icon mr-3">
                                                <svg xmlns="http://www.w3.org/2000/svg" class="text-primary" width="20" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 19v-8.93a2 2 0 01.89-1.664l7-4.666a2 2 0 012.22 0l7 4.666A2 2 0 0121 10.07V19M3 19a2 2 0 002 2h14a2 2 0 002-2M3 19l6.75-4.5M21 19l-6.75-4.5M3 10l6.75 4.5M21 10l-6.75 4.5m0 0l-1.14.76a2 2 0 01-2.22 0l-1.14-.76"></path>
                                                </svg>
                                            </div>
                                            <p class="mb-0">{{ $order->customer->email ?? '-'}}</p>
                                        </div>
                                    <div class="d-flex align-items-center mb-3">
                                        <div class="p-icon mr-3">
                                            <svg xmlns="http://www.w3.org/2000/svg" class="text-primary" width="20" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 8l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2M5 3a2 2 0 00-2 2v1c0 8.284 6.716 15 15 15h1a2 2 0 002-2v-3.28a1 1 0 00-.684-.948l-4.493-1.498a1 1 0 00-1.21.502l-1.13 2.257a11.042 11.042 0 01-5.516-5.517l2.257-1.128a1 1 0 00.502-1.21L9.228 3.683A1 1 0 008.279 3H5z"></path>
                                            </svg>
                                        </div>
                                        <p class="mb-0">{{ $order->customer->mobile ?? '-' }}</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</x-master-layout>