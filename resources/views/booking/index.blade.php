<x-master-layout>
    <div class="container-fluid">
        <div class="row">
            <div class="col-lg-12">
                <div class="card card-block card-stretch">
                    <div class="card-body p-0">
                        <div class="d-flex justify-content-between align-items-center p-3">
                            <h5 class="font-weight-bold">Bookings</h5>
                        </div>
                        <div>
                            <div class="row">
                                <div class="col-md-12 table-responsive">
                                    <table class="table w-100 dataTable" id="dataTable">
                                        <thead>
                                            <tr>
                                                <th>Booking ID</th>
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
            url: "<?= route("bookings.datatable") ?>",
        },
        lengthChange: true,
        columns: [
            { "data": "booking_id"},
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
</x-master-layout>