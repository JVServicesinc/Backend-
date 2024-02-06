<?php

namespace App\Http\Controllers;
use Validator;
use Illuminate\Http\Request;
use App\Models\Storesubcatgm as Subcatgm;
use Illuminate\Support\Facades\Http;
class StoreSubcatg extends Controller
{
    function Register(Request $req){
        $vl=Validator::make($req->all(),["image"=>"required","service"=>"required"]);
        if($vl->fails()){
            return ["error"=>$vl->errors()];
        }
        if($req->image =="undefined"){
            return ["status"=>500,"message"=>"image null"];
        }
        $img=$req->file("image");
        $filename=rand(1111,9999)."-".$img->getClientOriginalName();
        $img->move("uploads",$filename);
      $tbl=new Subcatgm();
      $tbl->name=$req->name;
      $tbl->services=$req->service;
      $tbl->featured=$req->featured=="undefined"?"false":$req->featured;
       $tbl->status=$req->status;
      $tbl->image="uploads/".$filename;
      $tbl->save();
      if($tbl->id>0){
          return ["status"=>200,"message"=>"New Record added successfully"];
      }else{
           return ["status"=>500,"message"=>"something went wrong"];
      }
      
   }
   
   function getbydata($name){
        //  $vl=Validator::make($name,["name"=>"required"]);
        // if($vl->fails()){
        //     return ["error"=>$vl->errors()];
        // }
       return Subcatgm::where("reff_id",$name)->where("status","1")->get();
   }
   
   function getworthy(){
       return Subcatgm::where("featured","true")->where("status","1")->get();
   }
   function getdata(){
       return Subcatgm::all();
   }
   function getdatabyid(){
       return Subcatgm::all();
   }
   
   function updt(Request $req){
       $vl=Validator::make($req->all(),["image"=>"required","service"=>"required","id"=>"required"]);
        if($vl->fails()){
            return ["error"=>$vl->errors()];
        }
       
      $tbl=Subcatgm::find($req->id);
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
      $tbl->name=$req->name;
      $tbl->services=$req->service;
      $tbl->featured=$req->featured=="undefined"?"false":$req->featured;
       $tbl->status=$req->status;
      $tbl->image=$uploadedImages;
      $tbl->save();
      if($tbl->id>0){
          return ["status"=>200,"message"=>"New Record added successfully"];
      }else{
           return ["status"=>500,"message"=>"something went wrong"];
      } 
   }
  function del($id){
       $tbl= Subcatgm::find($id);
        $filename =url($tbl->image);
          Http::delete($filename);
          $tbl->delete();
       return ["status"=>"deleted successfully"];
   }
}
