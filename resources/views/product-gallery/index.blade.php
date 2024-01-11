<x-master-layout>
    <div class="container-fluid">
        <div class="row">
            <div class="col-lg-12">
                <div class="card card-block card-stretch">
                    <div class="card-body p-0">
                        <div class="d-flex justify-content-between align-items-center p-3">
                            <h5 class="font-weight-bold">Product Gallery</h5>
                            <a href="{{ route('product.gallery.add', ['product_id' => $product_id]) }}" class="float-right mr-1 btn btn-sm btn-primary"><i class="fa fa-plus-circle"></i> Add New</a>
                        </div>
                        <div>
                            <div class="row">
                                <div class="col-md-12 table-responsive">
                                    <table class="table w-100 dataTable" id="dataTable">
                                        <thead>
                                            <tr>
                                                <th>Serial No.</th>
                                                <th>Image</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <?php foreach($images as $id => $image) : ?>
                                            <tr>
                                                <td><?= ++$id ?></td>
                                                <td><img src="<?= asset('uploads/product-gallery/'.$image->image_url) ?>" width="80px" height="80px"/></td>
                                                <td>
                                                    <a class="mr-2" href="{{ route('product.gallery.delete', ['product_id' => $image->product_id, 'id' => $image->id]) }}" title="Delete Image">
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