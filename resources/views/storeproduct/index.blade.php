<x-master-layout>
   <div class="container-fluid">
      <div class="row">
         <div class="col-lg-12">
            <div class="card card-block card-stretch">
               <div class="card-body p-0">
                  <div class="d-flex justify-content-between align-items-center p-3">
                     <h5 class="font-weight-bold">Stores Category</h5>
                     <a href="https://api.jvservices.ca/Jv/storescategorycreate" class="float-right mr-1 btn btn-sm btn-primary">
                     <i class="fa fa-plus-circle"></i> 
                     Add Category</a>
                  </div>
                  <div id="dataTableBuilder_wrapper"
                     class="dataTables_wrapper dt-bootstrap4 no-footer">
                     <div class="row align-items-center pt-3 px-4">
                        <div class="col-md-2">
                           <div class="dataTables_length" id="dataTableBuilder_length">
                              <label>
                                 Show 
                                 <select name="dataTableBuilder_length" aria-controls="dataTableBuilder"
                                    class="custom-select custom-select-sm form-control form-control-sm">
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
                           <div id="dataTableBuilder_filter" class="dataTables_filter">
                              <label><input type="search" class="form-control form-control-sm" placeholder="Search" aria-controls="dataTableBuilder"></label>
                           </div>
                           <div id="dataTableBuilder_processing" class="dataTables_processing card" style="display: none;">Processing...</div>
                        </div>
                     </div>
                     <div class="row">
                        <div class="col-md-12 table-responsive">
                           <table class="table w-100 dataTable no-footer" id="dataTableBuilder" aria-describedby="dataTableBuilder_info" style="width: 1100px;">
                              <thead>
                                 <tr>
                                    <th title="No" class="sorting_disabled sorting_asc" rowspan="1" colspan="1" style="width: 58px;" aria-label="No">No</th>
                                    <th title="Name" class="sorting" tabindex="0" aria-controls="dataTableBuilder" rowspan="1" colspan="1" style="width: 310px;" aria-label="Name: activate to sort column ascending">Name</th>
                                    <th title="Color" class="sorting" tabindex="0" aria-controls="dataTableBuilder" rowspan="1" colspan="1" style="width: 138px;" aria-label="Color: activate to sort column ascending">Color</th>
                                    <th title="Featured" class="sorting" tabindex="0" aria-controls="dataTableBuilder" rowspan="1" colspan="1" style="width: 142px;" aria-label="Featured: activate to sort column ascending">Featured</th>
                                    <th title="Status" class="sorting" tabindex="0" aria-controls="dataTableBuilder" rowspan="1" colspan="1" style="width: 112px;" aria-label="Status: activate to sort column ascending">Status</th>
                                    <th title="Action" width="60" class="text-center sorting_disabled" rowspan="1" colspan="1" style="width: 60px;" aria-label="Action">Action</th>
                                 </tr>
                              </thead>
                              <tbody>
                                 <tr class="odd">
                                    <td class="sorting_1">1</td>
                                    <td>Hair Salon</td>
                                    <td>#000000</td>
                                    <td>
                                       <div
                                          class="custom-control custom-switch custom-switch-text custom-switch-color custom-control-inline">
                                          <div class="custom-switch-inner">
                                             <input type="checkbox" class="custom-control-input bg-success change_status" data-type="category_featured" data-name="is_featured" checked="" value="58" id="f58" data-id="58">
                                             <label class="custom-control-label" for="f58" data-on-label="Yes" data-off-label="No"></label>
                                          </div>
                                       </div>
                                    </td>
                                    <td>
                                       <div class="custom-control custom-switch custom-switch-text custom-switch-color custom-control-inline">
                                          <div class="custom-switch-inner">
                                             <input type="checkbox" class="custom-control-input bg-success change_status" data-type="category_status" checked="" value="58" id="58" data-id="58">
                                             <label class="custom-control-label" for="58" data-on-label="" data-off-label=""></label>
                                          </div>
                                       </div>
                                    </td>
                                    <td class=" text-center">
                                       <form method="POST" action="https://api.jvservices.ca/Jv/category/58" accept-charset="UTF-8" data--submit="category58">
                                          <input name="_method" type="hidden" value="DELETE">
                                          <input name="_token" type="hidden" value="XzSCqAA4CUyfCzxEkoXRytvw7UBo0pVTxVG2JXxd">
                                          <div class="d-flex justify-content-end align-items-center">
                                             <a class="mr-2" href="storescategoryedit" title="Update Category">
                                             <i class="fas fa-pen text-secondary"></i></a>
                                             <a class="mr-2" href="javascript:void(0)" data--submit="category58" data--confirmation="true" data-title="Delete Category" title="Delete Category" data-message="Are you sure you want to delete? ">
                                             <i class="far fa-trash-alt text-danger"></i>
                                             </a>
                                          </div>
                                       </form>
                                    </td>
                                 </tr>
                                 <tr class="even">
                                    <td class="sorting_1">2</td>
                                    <td>Womens beauty services</td>
                                    <td>#000000</td>
                                    <td>
                                       <div class="custom-control custom-switch custom-switch-text custom-switch-color custom-control-inline">
                                          <div class="custom-switch-inner">
                                             <input type="checkbox" class="custom-control-input bg-success change_status" data-type="category_featured" data-name="is_featured" value="59" id="f59" data-id="59">
                                             <label class="custom-control-label" for="f59" data-on-label="Yes" data-off-label="No"></label>
                                          </div>
                                       </div>
                                    </td>
                                    <td>
                                       <div class="custom-control custom-switch custom-switch-text custom-switch-color custom-control-inline">
                                          <div class="custom-switch-inner">
                                             <input type="checkbox" class="custom-control-input bg-success change_status" data-type="category_status" checked="" value="59" id="59" data-id="59">
                                             <label class="custom-control-label" for="59" data-on-label="" data-off-label=""></label>
                                          </div>
                                       </div>
                                    </td>
                                    <td class=" text-center">
                                       <form method="POST" action="https://api.jvservices.ca/Jv/category/59" accept-charset="UTF-8" data--submit="category59">
                                          <input name="_method" type="hidden" value="DELETE">
                                          <input name="_token" type="hidden" value="XzSCqAA4CUyfCzxEkoXRytvw7UBo0pVTxVG2JXxd">
                                          <div class="d-flex justify-content-end align-items-center">
                                             <a class="mr-2" href="storescategoryedit" title="Update Category">
                                             <i class="fas fa-pen text-secondary"></i></a>
                                             <a class="mr-2" href="javascript:void(0)" data--submit="category59" data--confirmation="true" data-title="Delete Category" title="Delete Category" data-message="Are you sure you want to delete? ">
                                             <i class="far fa-trash-alt text-danger"></i>
                                             </a>
                                          </div>
                                       </form>
                                    </td>
                                 </tr>
                                 <tr class="odd">
                                    <td class="sorting_1">3</td>
                                    <td>Men Body care</td>
                                    <td>#000000</td>
                                    <td>
                                       <div class="custom-control custom-switch custom-switch-text custom-switch-color custom-control-inline">
                                          <div class="custom-switch-inner">
                                             <input type="checkbox" class="custom-control-input bg-success change_status" data-type="category_featured" data-name="is_featured" checked="" value="60" id="f60" data-id="60">
                                             <label class="custom-control-label" for="f60" data-on-label="Yes" data-off-label="No"></label>
                                          </div>
                                       </div>
                                    </td>
                                    <td>
                                       <div class="custom-control custom-switch custom-switch-text custom-switch-color custom-control-inline">
                                          <div class="custom-switch-inner">
                                             <input type="checkbox" class="custom-control-input bg-success change_status" data-type="category_status" checked="" value="60" id="60" data-id="60">
                                             <label class="custom-control-label" for="60" data-on-label="" data-off-label=""></label>
                                          </div>
                                       </div>
                                    </td>
                                    <td class=" text-center">
                                       <form method="POST" action="https://api.jvservices.ca/Jv/category/60" accept-charset="UTF-8" data--submit="category60">
                                          <input name="_method" type="hidden" value="DELETE">
                                          <input name="_token" type="hidden" value="XzSCqAA4CUyfCzxEkoXRytvw7UBo0pVTxVG2JXxd">
                                          <div class="d-flex justify-content-end align-items-center">
                                             <a class="mr-2" href="storescategoryedit" title="Update Category">
                                             <i class="fas fa-pen text-secondary"></i></a>
                                             <a class="mr-2" href="javascript:void(0)" data--submit="category60" data--confirmation="true" data-title="Delete Category" title="Delete Category" data-message="Are you sure you want to delete? ">
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
                           <div class="dataTables_info" id="dataTableBuilder_info" role="status" aria-live="polite">Showing 1 to 3 of 3 entries</div>
                        </div>
                        <div class="col-sm-6 text-sm-center">
                           <div class="dataTables_paginate paging_simple_numbers" id="dataTableBuilder_paginate">
                              <ul class="pagination justify-content-end mb-0">
                                 <li class="paginate_button page-item previous disabled" id="dataTableBuilder_previous"><a href="#" aria-controls="dataTableBuilder" data-dt-idx="0" tabindex="0" class="page-link">Previous</a></li>
                                 <li class="paginate_button page-item active">
                                    <a href="#" aria-controls="dataTableBuilder" data-dt-idx="1" tabindex="0" class="page-link">1</a>
                                 </li>
                                 <li class="paginate_button page-item next disabled" id="dataTableBuilder_next"><a href="#"
                                    aria-controls="dataTableBuilder" data-dt-idx="2" tab index="0" class="page-link">Next</a></li>
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