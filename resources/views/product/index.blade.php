<x-master-layout>
    <div class="container-fluid">
        <div class="row">
            <div class="col-lg-12">
                <div class="card card-block card-stretch">
                    <div class="card-body p-0">
                        <div class="d-flex justify-content-between align-items-center p-3">
                            <h5 class="font-weight-bold">Products</h5>
                            <a href="{{ route('product.add') }}" class="float-right mr-1 btn btn-sm btn-primary"><i class="fa fa-plus-circle"></i> Add New</a>
                        </div>
                        <div>
                            <div class="row">
                                <div class="col-md-12 table-responsive">
                                    <table class="table w-100 dataTable" id="dataTable">
                                        <thead>
                                            <tr>
                                                <th>Image</th>
                                                <th>Name</th>
                                                <th>SKU</th>
                                                <th>Price</th>
                                                <th>Sale Price</th>
                                                <th>Category</th>
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
            url: "<?= route("product.datatable") ?>",
        },
        lengthChange: true,
        columns: [
            { "data": "image"},
            { "data": "name" },
            { "data": "sku"},
            { "data": "price" },
            { "data": "sale_price" },
            { "data": "category_name" },
            { "data": "action_links" }
        ]
    });
});
</script>
</x-master-layout>