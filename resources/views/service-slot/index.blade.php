<x-master-layout>
    <div class="container-fluid">
        <div class="row">
            <div class="col-lg-12">
                <div class="card card-block card-stretch">
                    <div class="card-body p-0">
                        <div class="d-flex justify-content-between align-items-center p-3">
                            <h5 class="font-weight-bold">Service Slots</h5>
                            <a href="{{ route('services.slots.add', $service_id) }}" class="float-right mr-1 btn btn-sm btn-primary"><i class="fa fa-plus-circle"></i> Add New</a>
                        </div>
                        <div>
                            <div class="row">
                                <div class="col-md-12 table-responsive">
                                    <table class="table w-100 dataTable" id="dataTable">
                                        <thead>
                                            <tr>
                                                <th>Serial No</th>
                                                <th>Weekday Name</th>
                                                <th>Timing</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <?php foreach($service_slots as $index => $slot) : ?>
                                            <tr>
                                                <td><?= ++$index ?></td>
                                                <td><?= $slot->weekday_name ?></td>
                                                <td><?= $slot->timing ?></td>
                                                <td>
                                                    <a class="mr-2" href="{{ route('services.slots.edit', ['service_id' => $slot->service_id, 'id' => $slot->id] ) }}" title="Update Slot">
                                                        <i class="fas fa-pen text-secondary"></i>
                                                    </a>
                                                    <a class="mr-2" href="{{ route('services.slots.delete', ['service_id' => $slot->service_id, 'id' => $slot->id]) }}" title="Delete Slot">
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