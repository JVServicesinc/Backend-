<x-master-layout>
    <div class="container-fluid">
        <div class="row">
            <div class="col-lg-12">
                <div class="card card-block card-stretch">
                    <div class="card-body p-0">
                        <div class="d-flex justify-content-between align-items-center p-3">
                            <h5 class="font-weight-bold">Store Categories</h5>
                            <a href="{{ route('product.category.add') }}" class="float-right mr-1 btn btn-sm btn-primary"><i class="fa fa-plus-circle"></i> Add New</a>
                        </div>
                        <div>
                            <div class="row">
                                <div class="col-md-12 table-responsive">
                                    <table class="table w-100 dataTable" id="dataTable">
                                        <thead>
                                            <tr>
                                                <th>Image</th>
                                                <th>Name</th>
                                                <th>Parent Category</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <?php foreach($categories as $data) : ?>
                                            <tr>
                                                <td><img src="<?= $data->image_url . '?tr=w-60,h-60' ?>"/></td>
                                                <td><?= $data->name ?></td>
                                                <td><?= $data->parent_category ?></td>
                                                <td>
                                                    <a class="mr-2" href="{{ route('product.category.edit', $data->id) }}" title="Update Product Category"><i class="fas fa-pen text-secondary"></i></a>
                                                    <a class="mr-2" href="{{ route('product.category.delete', $data->id) }}" title="Delete Product Category">
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

    $('#dataTable').DataTable({

    });
});
</script>


</x-master-layout>