<x-master-layout>
   <div class="container-fluid">
      <div class="row">
         <div class="col-lg-12">
            <div class="card card-block card-stretch">
               <div class="card-body p-0">
                  <div class="d-flex justify-content-between align-items-center p-3">
                     <h5 class="font-weight-bold">Add New Store Category</h5>
                     <a href="storescategory" class="float-right btn btn-sm btn-primary"><i class="fa fa-angle-double-left"></i> Back</a>
                  </div>
               </div>
            </div>
         </div>
         <div class="col-lg-12">
            <div class="card">
               <div class="card-body">
                  <form method="POST" action="https://api.jvservices.ca/Jv/category" accept-charset="UTF-8" enctype="multipart/form-data" data-toggle="validator" id="category" novalidate="true">
                     <input name="_token" type="hidden" value="XzSCqAA4CUyfCzxEkoXRytvw7UBo0pVTxVG2JXxd">
                     <input name="id" type="hidden">
                     <div class="row">
                        <div class="form-group col-md-4 has-error has-danger">
                           <label for="name" class="form-control-label">Name <span class="text-danger">*</span></label>
                           <input placeholder="Name" class="form-control" required="" name="name" type="text" id="name">
                           <small class="help-block with-errors text-danger">
                              <ul class="list-unstyled">
                                 <li>Please fill out this field.</li>
                              </ul>
                           </small>
                        </div>
                        <div class="form-group col-md-4">
                           <label for="color" class="form-control-label">Color</label>
                           <input placeholder="Color" class="form-control" id="color" name="color" type="color">
                        </div>
                        <div class="form-group col-md-4">
                           <label for="status" class="form-control-label">Status <span class="text-danger">*</span></label>
                           <select id="role" class="form-control select2js select2-hidden-accessible" required="" name="status" data-select2-id="role" tabindex="-1" aria-hidden="true">
                              <option value="1" data-select2-id="2">Active</option>
                              <option value="0">Inactive</option>
                           </select>
                        </div>
                        <input type="hidden" name="ser_type_id" value="2">
                        <div class="form-group col-md-4">
                           <label class="form-control-label" for="category_image">Image </label>
                           <div class="custom-file">
                              <input type="file" name="category_image" class="custom-file-input" accept="image/*">
                              <label class="custom-file-label">Choose Image</label>
                           </div>
                           <span class="selected_file"></span>
                        </div>
                        <div class="form-group col-md-12">
                           <label for="description" class="form-control-label">Description</label>
                           <textarea class="form-control textarea" rows="3" placeholder="Description" name="description" cols="50" id="description"></textarea>
                        </div>
                     </div>
                     <div class="row">
                        <div class="form-group col-md-6">
                           <div class="custom-control custom-checkbox custom-control-inline">
                              <!-- <input type="checkbox" name="is_featured" value="1" class="custom-control-input" id="is_featured"> -->
                              <input class="custom-control-input" id="is_featured" name="is_featured" type="checkbox">
                              <label class="custom-control-label" for="is_featured">Set as featured
                              </label>
                           </div>
                        </div>
                     </div>
                     <input class="btn btn-md btn-primary float-right disabled" type="submit" value="Save">
                  </form>
               </div>
            </div>
         </div>
      </div>
   </div>
</x-master-layout>