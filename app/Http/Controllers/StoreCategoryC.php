<?php

namespace App\Http\Controllers;
use Validator,DB;
use Illuminate\Http\Request;
use App\Models\Storecategory as Category;
use Illuminate\Support\Facades\Http;
class StoreCategoryC extends Controller
{
    function Register(Request $req){
        $vl=Validator::make($req->all(),["image"=>"required","sname"=>"required"]);
        if($vl->fails()){
            return ["error"=>$vl->errors()];
        }
        if($req->image =="undefined"){
            return ["status"=>500,"message"=>"image null"];
        }
        $img=$req->file("image");
        $filename=rand(1111,9999)."-".$img->getClientOriginalName();
        $img->move("uploads",$filename);
      $tbl=new Category();
      $tbl->sub_name=$req->sname;
       $tbl->status=$req->status;
      $tbl->image="uploads/".$filename;
      $tbl->save();
      if($tbl->id>0){
          return ["status"=>200,"message"=>"New Record added successfully"];
      }else{
           return ["status"=>500,"message"=>"something went wrong"];
      }
      
   }
   
   function getdata(){
       return Category::orderBy("sub_name","Desc")->where("status","1")->get();
   }
   
   function getdatabyid(){
       return Category::all();
   }
   
   function updt(Request $req){
       $vl=Validator::make($req->all(),["image"=>"required","sname"=>"required","id"=>"required"]);
        if($vl->fails()){
            return ["error"=>$vl->errors()];
        }
       
      $tbl=Category::find($req->id);
      if ($req->hasFile('image')) {
          if($tbl->image !=null && $tbl->image !=''){
          $filename =url($tbl->image);
          Http::delete($filename);
           }
        $img=$req->file("image");
        $filename=rand(1111,9999)."-".$img->getClientOriginalName();
        $img->move("uploads",$filename);
        $uploadedImages="uploads/".$filename;
        }else {
             $uploadedImages=$tbl->image;
         }
      $tbl->sub_name=$req->sname;
       $tbl->status=$req->status;
      $tbl->image=$uploadedImages;
      $tbl->save();
      if($tbl->id>0){
          return ["status"=>200,"message"=>"Record updated successfully"];
      }else{
           return ["status"=>500,"message"=>"something went wrong"];
      }
   }
//   function del($id){
//         $tbl=Category::find($id);
//          $filename =url($tbl->image);
//           Http::delete($filename);
//           $tbl->delete();
//       return ["status"=>"deleted successfully"];
//   }
   function del($id){
        $tbl=Category::find($id);
        $cname=$tbl->sub_name;
   $tbl1=DB::table('storesubcatgms')->where("services",$cname);
      
  foreach($tbl1->get() as $row){
        if(file_exists($row->image)){
           unlink($row->image);
        }
      
  }
  $tbl1->delete();
   $tbl2=DB::table('storeproducts')->where("catg_sub",$cname);
   foreach($tbl2->get() as $row1){
         if(file_exists($row1->image)){
           unlink($row1->image);
        }
        
  }
  $tbl2->delete();
        if(file_exists($tbl->image)){
           unlink($tbl->image);
        }
        $tbl->delete();
       return ["status"=>"deleted successfully"];
   }
}
