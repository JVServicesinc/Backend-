<x-master-layout>
    <div class="container-fluid">
        <div class="row">
            <div class="col-lg-12">
                <div class="card card-block card-stretch">
                    <div class="card-body p-0">
                        <div class="d-flex justify-content-between align-items-center p-3">
                            <h5 class="font-weight-bold">Service Categoires</h5>
                            <a href="{{ route('service.category.add') }}" class="float-right mr-1 btn btn-sm btn-primary"><i class="fa fa-plus-circle"></i> Add New</a>
                        </div>
                        <div>
                            <div class="row">
                                <div class="col-md-12 table-responsive">
                                    <table class="table w-100 dataTable" id="dataTable">
                                        <thead>
                                            <tr>
                                                <th>Image</th>
                                                <th>Category Name</th>
                                                <th>Service Type</th>
                                                <th>Status</th>
                                                <th>Is Featured</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <?php foreach($service_categores as $cat) : ?>
                                            <tr>
                                                <td><img src="<?= env('IMAGEKIT_URL_ENDPOINT') . $cat->image . '?tr=w-80,h-80' ?>"/></td>
                                                <td><?= $cat->name ?></td>
                                                <td><?= $cat->service_type ?></td>
                                                <td><?= $cat->status == 1 ? '<span class="badge badge-success">Active</span>' : '<span class="badge badge-danger">Inactive</span>' ?></td>
                                                <td><?= $cat->is_featured == 1 ? 'Yes' : 'No' ?></td>
                                                <td>
                                                    <a class="mr-2" href="{{ route('service.category.edit', $cat->id) }}" title="Update Service Category">
                                                        <i class="fas fa-pen text-secondary"></i>
                                                    </a>
                                                    <a class="mr-2" href="{{ route('service.category.delete', $cat->id) }}" title="Delete Service Category">
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
</x-master-layout>