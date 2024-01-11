<x-master-layout>
    <div class="container-fluid">
        <div class="row">
            <div class="col-lg-12">
                <div class="card card-block card-stretch">
                    <div class="card-body p-0">
                        <div class="d-flex justify-content-between align-items-center p-3">
                            <h5 class="font-weight-bold">Update Slot</h5>
                            <a href="{{ route('services.slots.list', $service_id) }}" class="float-right btn btn-sm btn-primary"><i class="fa fa-angle-double-left"></i> Back</a>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-12">

                <form method="POST" action="{{ route('services.slots.update', ['service_id' => $slot->service_id, 'id' => $slot->id]) }}">
                    @csrf
                    <div class="card">
                        <div class="card-body">
                            <div class="row">
                                <div class="form-group col-md-4">
                                    <label class="form-control-label">Weekday <span class="text-danger">*</span></label>
                                    <select class="form-control" name="weekday_number">
                                    <?php foreach($weekdays as $key => $weekday) : ?>
                                        <option value="<?= $key ?>" <?= $key == $slot->weekday_number ? 'selected' : '' ?>><?= $weekday ?></option>
                                    <?php endforeach ?>
                                    </select>
                                </div>

                                <div class="form-group col-md-4">
                                    <label class="form-control-label">Time<span class="text-danger">*</span></label>
                                    <input class="form-control" name="timing" value="<?= $slot->timing ?>" type="time" min="07:00" max="20:30" />
                                </div>
                          
                            </div>
                        </div>
                    </div>

                    <input class="btn btn-md btn-primary float-left mb-4" type="submit" value="Update" />
                </form>

            </div>
        </div>
    </div>
</x-master-layout>