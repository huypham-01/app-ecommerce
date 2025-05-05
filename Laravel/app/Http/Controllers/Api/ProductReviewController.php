<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use App\Models\Product;
use App\Models\ProductReview;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;

class ProductReviewController extends Controller
{
     // Phương thức để lưu đánh giá sản phẩm
    public function store(Request $request, $productId)
    {
        // Kiểm tra đánh giá hợp lệ
        // $request->validate([
        //     'rating' => 'required|integer|between:1,5',
        //     'review' => 'nullable|string|max:1000',
        // ]);

        // Lưu đánh giá vào bảng product_reviews
        $review = new ProductReview();
        $review->product_id = $productId;
        $review->user_id = $request->user_id; // Lấy id của người dùng đã đăng nhập
        $review->rate = $request->rating;
        $review->review = $request->review;
        $review->save();

        // Trả về phản hồi thành công
        return response()->json(['message' => 'Đánh giá của bạn đã được gửi thành công']);
    }
}
