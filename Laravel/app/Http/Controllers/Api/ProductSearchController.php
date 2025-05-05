<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use App\Models\Product;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;

class ProductSearchController extends Controller
{
    public function search(Request $request)
    {
        // Lấy từ khóa tìm kiếm từ query string
        $keyword = $request->input('keyword');

        // Kiểm tra nếu từ khóa không trống
        if ($keyword) {
            // Tìm kiếm trong bảng products, có thể mở rộng để tìm kiếm ở các trường khác như mô tả, danh mục, v.v.
            $products = Product::with('brand')->where('title', 'LIKE', '%' . $keyword . '%')
                                ->get();
        } else {
            // Nếu không có từ khóa, trả về tất cả sản phẩm
            $products = Product::all();
        }

        // Trả về kết quả tìm kiếm dưới dạng JSON
        return response()->json($products);
    }
}
