<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use App\Models\Product;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;

class ProductController extends Controller
{
    //
    public function index()
    {
        $products = Product::where('status', 'active')->with('brand')->get();

        return response()->json($products);
    }
    public function getProductById($id)
    {
        $product = Product::where('status', 'active')->with(['brand', 'getReview'])->find($id);
        if ($product) {
            return response()->json($product);
        } else {
            return response()->json(['message' => 'Sản phẩm không tồn tại'], 404);
        }
    }
}
