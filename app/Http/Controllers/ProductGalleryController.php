<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\ProductGallery;

class ProductGalleryController extends Controller
{
    public function list($product_id)
    {
        // dd(ProductGallery::where(['product_id' => $product_id])->get());
        return view('product-gallery.index', [
            'images' => ProductGallery::where(['product_id' => $product_id])->get(),
            'product_id' => $product_id
        ]);
    }

    public function add($product_id)
    {
        return view('product-gallery.create', [
            'product_id' => $product_id
        ]);
    }

    public function store(Request $request, $product_id)
    {
        $request->validate([
            'images' => 'required',
        ]);

        $images = $request->file('images');

        ProductGallery::addProuctGallery($images, $product_id);
        return redirect(route('product.gallery.list', ['product_id' => $product_id]))->withSuccess('Gallery image added successfully');
    }

    public function delete($product_id, $image_id)
    {
        $image = ProductGallery::findOrFail($image_id);
        $image->delete();
        return redirect(route('product.gallery.list', ['product_id' => $product_id]))->withSuccess('Gallery image deleted successfully');
    }
}
