<x-master-layout>
  <div class="container-fluid">
   <div class="row">
      <div class="col-lg-12">
         <div class="card card-block card-stretch">
            <div class="card-body p-0">
               <div class="d-flex justify-content-between align-items-center p-3">
                  <h5 class="font-weight-bold">Store Sub Category List</h5>
                  <a href="https://api.jvservices.ca/Jv/subcategory/create?type=2" class="float-right mr-1 btn btn-sm btn-primary"><i class="fa fa-plus-circle"></i> Add Store Sub Category</a>
               </div>
               <div id="dataTableBuilder_wrapper" class="dataTables_wrapper dt-bootstrap4 no-footer">
                  <div class="row align-items-center pt-3 px-4">
                     <div class="col-md-2">
                        <div class="dataTables_length" id="dataTableBuilder_length">
                           <label>
                              Show 
                              <select name="dataTableBuilder_length" aria-controls="dataTableBuilder" class="custom-select custom-select-sm form-control form-control-sm">
                                 <option value="10">10</option>
                                 <option value="50">50</option>
                                 <option value="100">100</option>
                                 <option value="500">500</option>
                                 <option value="-1">All</option>
                              </select>
                              entries
                           </label>
                        </div>
                     </div>
                     <div class="col-md-4"></div>
                     <div class="col-md-6">
                        <div id="dataTableBuilder_filter" class="dataTables_filter"><label><input type="search" class="form-control form-control-sm" placeholder="Search" aria-controls="dataTableBuilder"></label></div>
                        <div id="dataTableBuilder_processing" class="dataTables_processing card" style="display: none;">Processing...</div>
                     </div>
                  </div>
                  <div class="row">
                     <div class="col-md-12 table-responsive">
                        <table class="table w-100 dataTable no-footer" id="dataTableBuilder" aria-describedby="dataTableBuilder_info" style="width: 1102px;">
                           <thead>
                              <tr>
                                 <th title="No" class="sorting_disabled sorting_asc" rowspan="1" colspan="1" style="width: 45px;" aria-label="No">No</th>
                                 <th title="Name" class="sorting" tabindex="0" aria-controls="dataTableBuilder" rowspan="1" colspan="1" style="width: 250px;" aria-label="Name: activate to sort column ascending">Name</th>
                                 <th title="Category" class="sorting" tabindex="0" aria-controls="dataTableBuilder" rowspan="1" colspan="1" style="width: 261px;" aria-label="Category: activate to sort column ascending">Category</th>
                                 <th title="Featured" class="sorting" tabindex="0" aria-controls="dataTableBuilder" rowspan="1" colspan="1" style="width: 116px;" aria-label="Featured: activate to sort column ascending">Featured</th>
                                 <th title="Status" class="sorting" tabindex="0" aria-controls="dataTableBuilder" rowspan="1" colspan="1" style="width: 90px;" aria-label="Status: activate to sort column ascending">Status</th>
                                 <th title="Action" width="60" class="text-center sorting_disabled" rowspan="1" colspan="1" style="width: 60px;" aria-label="Action">Action</th>
                              </tr>
                           </thead>
                           <tbody>
                              <tr class="odd">
                                 <td class="sorting_1">1</td>
                                 <td>Mens Hair services</td>
                                 <td>Hair Salon</td>
                                 <td>
                                    <div class="custom-control custom-switch custom-switch-text custom-switch-color custom-control-inline">
                                       <div class="custom-switch-inner">
                                          <input type="checkbox" class="custom-control-input bg-success change_status" data-type="subcategory_featured" data-name="is_featured" value="56" id="f56" data-id="56">
                                          <label class="custom-control-label" for="f56" data-on-label="Yes" data-off-label="No"></label>
                                       </div>
                                    </div>
                                 </td>
                                 <td>
                                    <div class="custom-control custom-switch custom-switch-text custom-switch-color custom-control-inline">
                                       <div class="custom-switch-inner">
                                          <input type="checkbox" class="custom-control-input bg-success change_status" data-type="subcategory_status" checked="" value="56" id="56" data-id="56">
                                          <label class="custom-control-label" for="56" data-on-label="" data-off-label=""></label>
                                       </div>
                                    </div>
                                 </td>
                                 <td class=" text-center">
                                    <form method="POST" action="https://api.jvservices.ca/Jv/subcategory/56" accept-charset="UTF-8" data--submit="subcategory56">
                                       <input name="_method" type="hidden" value="DELETE"><input name="_token" type="hidden" value="XzSCqAA4CUyfCzxEkoXRytvw7UBo0pVTxVG2JXxd">
                                       <div class="d-flex justify-content-end align-items-center">
                                          <a class="mr-2" href="https://api.jvservices.ca/Jv/subcategory/create?id=56" title="Update Sub Category"><i class="fas fa-pen text-secondary"></i></a>
                                          <a class="mr-2" href="javascript:void(0)" data--submit="subcategory56" data--confirmation="true" data-title="Delete Sub Category" title="Delete Sub Category" data-message="Are you sure you want to delete? ">
                                          <i class="far fa-trash-alt text-danger"></i>
                                          </a>
                                       </div>
                                    </form>
                                 </td>
                              </tr>
                              <tr class="even">
                                 <td class="sorting_1">2</td>
                                 <td>Mens beauty services</td>
                                 <td>Hair Salon</td>
                                 <td>
                                    <div class="custom-control custom-switch custom-switch-text custom-switch-color custom-control-inline">
                                       <div class="custom-switch-inner">
                                          <input type="checkbox" class="custom-control-input bg-success change_status" data-type="subcategory_featured" data-name="is_featured" value="57" id="f57" data-id="57">
                                          <label class="custom-control-label" for="f57" data-on-label="Yes" data-off-label="No"></label>
                                       </div>
                                    </div>
                                 </td>
                                 <td>
                                    <div class="custom-control custom-switch custom-switch-text custom-switch-color custom-control-inline">
                                       <div class="custom-switch-inner">
                                          <input type="checkbox" class="custom-control-input bg-success change_status" data-type="subcategory_status" checked="" value="57" id="57" data-id="57">
                                          <label class="custom-control-label" for="57" data-on-label="" data-off-label=""></label>
                                       </div>
                                    </div>
                                 </td>
                                 <td class=" text-center">
                                    <form method="POST" action="https://api.jvservices.ca/Jv/subcategory/57" accept-charset="UTF-8" data--submit="subcategory57">
                                       <input name="_method" type="hidden" value="DELETE"><input name="_token" type="hidden" value="XzSCqAA4CUyfCzxEkoXRytvw7UBo0pVTxVG2JXxd">
                                       <div class="d-flex justify-content-end align-items-center">
                                          <a class="mr-2" href="https://api.jvservices.ca/Jv/subcategory/create?id=57" title="Update Sub Category"><i class="fas fa-pen text-secondary"></i></a>
                                          <a class="mr-2" href="javascript:void(0)" data--submit="subcategory57" data--confirmation="true" data-title="Delete Sub Category" title="Delete Sub Category" data-message="Are you sure you want to delete? ">
                                          <i class="far fa-trash-alt text-danger"></i>
                                          </a>
                                       </div>
                                    </form>
                                 </td>
                              </tr>
                              <tr class="odd">
                                 <td class="sorting_1">3</td>
                                 <td>Manicure</td>
                                 <td>Womens beauty services</td>
                                 <td>
                                    <div class="custom-control custom-switch custom-switch-text custom-switch-color custom-control-inline">
                                       <div class="custom-switch-inner">
                                          <input type="checkbox" class="custom-control-input bg-success change_status" data-type="subcategory_featured" data-name="is_featured" value="58" id="f58" data-id="58">
                                          <label class="custom-control-label" for="f58" data-on-label="Yes" data-off-label="No"></label>
                                       </div>
                                    </div>
                                 </td>
                                 <td>
                                    <div class="custom-control custom-switch custom-switch-text custom-switch-color custom-control-inline">
                                       <div class="custom-switch-inner">
                                          <input type="checkbox" class="custom-control-input bg-success change_status" data-type="subcategory_status" checked="" value="58" id="58" data-id="58">
                                          <label class="custom-control-label" for="58" data-on-label="" data-off-label=""></label>
                                       </div>
                                    </div>
                                 </td>
                                 <td class=" text-center">
                                    <form method="POST" action="https://api.jvservices.ca/Jv/subcategory/58" accept-charset="UTF-8" data--submit="subcategory58">
                                       <input name="_method" type="hidden" value="DELETE"><input name="_token" type="hidden" value="XzSCqAA4CUyfCzxEkoXRytvw7UBo0pVTxVG2JXxd">
                                       <div class="d-flex justify-content-end align-items-center">
                                          <a class="mr-2" href="https://api.jvservices.ca/Jv/subcategory/create?id=58" title="Update Sub Category"><i class="fas fa-pen text-secondary"></i></a>
                                          <a class="mr-2" href="javascript:void(0)" data--submit="subcategory58" data--confirmation="true" data-title="Delete Sub Category" title="Delete Sub Category" data-message="Are you sure you want to delete? ">
                                          <i class="far fa-trash-alt text-danger"></i>
                                          </a>
                                       </div>
                                    </form>
                                 </td>
                              </tr>
                              <tr class="even">
                                 <td class="sorting_1">4</td>
                                 <td>Women hair services</td>
                                 <td>Womens beauty services</td>
                                 <td>
                                    <div class="custom-control custom-switch custom-switch-text custom-switch-color custom-control-inline">
                                       <div class="custom-switch-inner">
                                          <input type="checkbox" class="custom-control-input bg-success change_status" data-type="subcategory_featured" data-name="is_featured" value="59" id="f59" data-id="59">
                                          <label class="custom-control-label" for="f59" data-on-label="Yes" data-off-label="No"></label>
                                       </div>
                                    </div>
                                 </td>
                                 <td>
                                    <div class="custom-control custom-switch custom-switch-text custom-switch-color custom-control-inline">
                                       <div class="custom-switch-inner">
                                          <input type="checkbox" class="custom-control-input bg-success change_status" data-type="subcategory_status" checked="" value="59" id="59" data-id="59">
                                          <label class="custom-control-label" for="59" data-on-label="" data-off-label=""></label>
                                       </div>
                                    </div>
                                 </td>
                                 <td class=" text-center">
                                    <form method="POST" action="https://api.jvservices.ca/Jv/subcategory/59" accept-charset="UTF-8" data--submit="subcategory59">
                                       <input name="_method" type="hidden" value="DELETE"><input name="_token" type="hidden" value="XzSCqAA4CUyfCzxEkoXRytvw7UBo0pVTxVG2JXxd">
                                       <div class="d-flex justify-content-end align-items-center">
                                          <a class="mr-2" href="https://api.jvservices.ca/Jv/subcategory/create?id=59" title="Update Sub Category"><i class="fas fa-pen text-secondary"></i></a>
                                          <a class="mr-2" href="javascript:void(0)" data--submit="subcategory59" data--confirmation="true" data-title="Delete Sub Category" title="Delete Sub Category" data-message="Are you sure you want to delete? ">
                                          <i class="far fa-trash-alt text-danger"></i>
                                          </a>
                                       </div>
                                    </form>
                                 </td>
                              </tr>
                              <tr class="odd">
                                 <td class="sorting_1">5</td>
                                 <td>Kids hair services</td>
                                 <td>Hair Salon</td>
                                 <td>
                                    <div class="custom-control custom-switch custom-switch-text custom-switch-color custom-control-inline">
                                       <div class="custom-switch-inner">
                                          <input type="checkbox" class="custom-control-input bg-success change_status" data-type="subcategory_featured" data-name="is_featured" value="60" id="f60" data-id="60">
                                          <label class="custom-control-label" for="f60" data-on-label="Yes" data-off-label="No"></label>
                                       </div>
                                    </div>
                                 </td>
                                 <td>
                                    <div class="custom-control custom-switch custom-switch-text custom-switch-color custom-control-inline">
                                       <div class="custom-switch-inner">
                                          <input type="checkbox" class="custom-control-input bg-success change_status" data-type="subcategory_status" checked="" value="60" id="60" data-id="60">
                                          <label class="custom-control-label" for="60" data-on-label="" data-off-label=""></label>
                                       </div>
                                    </div>
                                 </td>
                                 <td class=" text-center">
                                    <form method="POST" action="https://api.jvservices.ca/Jv/subcategory/60" accept-charset="UTF-8" data--submit="subcategory60">
                                       <input name="_method" type="hidden" value="DELETE"><input name="_token" type="hidden" value="XzSCqAA4CUyfCzxEkoXRytvw7UBo0pVTxVG2JXxd">
                                       <div class="d-flex justify-content-end align-items-center">
                                          <a class="mr-2" href="https://api.jvservices.ca/Jv/subcategory/create?id=60" title="Update Sub Category"><i class="fas fa-pen text-secondary"></i></a>
                                          <a class="mr-2" href="javascript:void(0)" data--submit="subcategory60" data--confirmation="true" data-title="Delete Sub Category" title="Delete Sub Category" data-message="Are you sure you want to delete? ">
                                          <i class="far fa-trash-alt text-danger"></i>
                                          </a>
                                       </div>
                                    </form>
                                 </td>
                              </tr>
                              <tr class="even">
                                 <td class="sorting_1">6</td>
                                 <td>Women Beauty services</td>
                                 <td>Womens beauty services</td>
                                 <td>
                                    <div class="custom-control custom-switch custom-switch-text custom-switch-color custom-control-inline">
                                       <div class="custom-switch-inner">
                                          <input type="checkbox" class="custom-control-input bg-success change_status" data-type="subcategory_featured" data-name="is_featured" value="61" id="f61" data-id="61">
                                          <label class="custom-control-label" for="f61" data-on-label="Yes" data-off-label="No"></label>
                                       </div>
                                    </div>
                                 </td>
                                 <td>
                                    <div class="custom-control custom-switch custom-switch-text custom-switch-color custom-control-inline">
                                       <div class="custom-switch-inner">
                                          <input type="checkbox" class="custom-control-input bg-success change_status" data-type="subcategory_status" checked="" value="61" id="61" data-id="61">
                                          <label class="custom-control-label" for="61" data-on-label="" data-off-label=""></label>
                                       </div>
                                    </div>
                                 </td>
                                 <td class=" text-center">
                                    <form method="POST" action="https://api.jvservices.ca/Jv/subcategory/61" accept-charset="UTF-8" data--submit="subcategory61">
                                       <input name="_method" type="hidden" value="DELETE"><input name="_token" type="hidden" value="XzSCqAA4CUyfCzxEkoXRytvw7UBo0pVTxVG2JXxd">
                                       <div class="d-flex justify-content-end align-items-center">
                                          <a class="mr-2" href="https://api.jvservices.ca/Jv/subcategory/create?id=61" title="Update Sub Category"><i class="fas fa-pen text-secondary"></i></a>
                                          <a class="mr-2" href="javascript:void(0)" data--submit="subcategory61" data--confirmation="true" data-title="Delete Sub Category" title="Delete Sub Category" data-message="Are you sure you want to delete? ">
                                          <i class="far fa-trash-alt text-danger"></i>
                                          </a>
                                       </div>
                                    </form>
                                 </td>
                              </tr>
                              <tr class="odd">
                                 <td class="sorting_1">7</td>
                                 <td>Mens massage</td>
                                 <td>Men Body care</td>
                                 <td>
                                    <div class="custom-control custom-switch custom-switch-text custom-switch-color custom-control-inline">
                                       <div class="custom-switch-inner">
                                          <input type="checkbox" class="custom-control-input bg-success change_status" data-type="subcategory_featured" data-name="is_featured" value="62" id="f62" data-id="62">
                                          <label class="custom-control-label" for="f62" data-on-label="Yes" data-off-label="No"></label>
                                       </div>
                                    </div>
                                 </td>
                                 <td>
                                    <div class="custom-control custom-switch custom-switch-text custom-switch-color custom-control-inline">
                                       <div class="custom-switch-inner">
                                          <input type="checkbox" class="custom-control-input bg-success change_status" data-type="subcategory_status" checked="" value="62" id="62" data-id="62">
                                          <label class="custom-control-label" for="62" data-on-label="" data-off-label=""></label>
                                       </div>
                                    </div>
                                 </td>
                                 <td class=" text-center">
                                    <form method="POST" action="https://api.jvservices.ca/Jv/subcategory/62" accept-charset="UTF-8" data--submit="subcategory62">
                                       <input name="_method" type="hidden" value="DELETE"><input name="_token" type="hidden" value="XzSCqAA4CUyfCzxEkoXRytvw7UBo0pVTxVG2JXxd">
                                       <div class="d-flex justify-content-end align-items-center">
                                          <a class="mr-2" href="https://api.jvservices.ca/Jv/subcategory/create?id=62" title="Update Sub Category"><i class="fas fa-pen text-secondary"></i></a>
                                          <a class="mr-2" href="javascript:void(0)" data--submit="subcategory62" data--confirmation="true" data-title="Delete Sub Category" title="Delete Sub Category" data-message="Are you sure you want to delete? ">
                                          <i class="far fa-trash-alt text-danger"></i>
                                          </a>
                                       </div>
                                    </form>
                                 </td>
                              </tr>
                           </tbody>
                        </table>
                     </div>
                  </div>
                  <div class="row p-4">
                     <div class="col-sm-6">
                        <div class="dataTables_info" id="dataTableBuilder_info" role="status" aria-live="polite">Showing 1 to 7 of 7 entries</div>
                     </div>
                     <div class="col-sm-6 text-sm-center">
                        <div class="dataTables_paginate paging_simple_numbers" id="dataTableBuilder_paginate">
                           <ul class="pagination justify-content-end mb-0">
                              <li class="paginate_button page-item previous disabled" id="dataTableBuilder_previous"><a href="#" aria-controls="dataTableBuilder" data-dt-idx="0" tabindex="0" class="page-link">Previous</a></li>
                              <li class="paginate_button page-item active"><a href="#" aria-controls="dataTableBuilder" data-dt-idx="1" tabindex="0" class="page-link">1</a></li>
                              <li class="paginate_button page-item next disabled" id="dataTableBuilder_next"><a href="#" aria-controls="dataTableBuilder" data-dt-idx="2" tabindex="0" class="page-link">Next</a></li>
                           </ul>
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