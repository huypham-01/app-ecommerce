<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\DB;
use App\Models\Cart;
use App\Models\Product;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
use PhpParser\Node\Expr\Print_;

class CartController extends Controller
{
     // Thêm sản phẩm vào giỏ hàng
    public function addToCart(Request $request) {
        $user = $request->input('user_id');
        $size = $request->input('size');
        $productId = $request->input('product_id');
        $price = $request->input('price');
        $quantity = $request->input('quantity', 1);
        $amount = $price * $quantity;

        // Kiểm tra sản phẩm đã có trong giỏ hàng chưa
        $cartItem = Cart::where('user_id', $user)
                    ->where('product_id', $productId)
                    ->where('status', 'new')
                    ->first();

        // Thêm hoặc cập nhật sản phẩm trong giỏ hàng
        if ($cartItem) {
        // Nếu sản phẩm đã có trong giỏ, cập nhật số lượng và tổng số tiền
        $cartItem->quantity += $quantity;
        $cartItem->amount = $cartItem->price * $cartItem->quantity;
        $cartItem->updated_at = now();
        $cartItem->save();
    } else {
        // Nếu sản phẩm chưa có trong giỏ, tạo một mục mới
        $cartItem = Cart::create([
            'product_id' => $productId,
            'user_id' => $user,
            'price' => $price,
            'quantity' => $quantity,
            'amount' => $amount,
            'size' => $size,
            'status' => 'new',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
    }

        return response()->json(['message' => 'Đã thêm vào giỏ hàng', 'cart' => $cartItem], 200);
    }
    public function getCartItems($id) {
    $cartItems = Cart::where('user_id', $id)->with('product')->get();

    return response()->json($cartItems);
}
    public function updateCartItem(Request $request)
{
    $validated = $request->validate([
        'cart_id' => 'required|integer',
        'quantity' => 'required|integer|min:1',
    ]);

    $cartItem = Cart::find($validated['cart_id']);

    if (!$cartItem) {
        return response()->json(['message' => 'Cart item not found'], 404);
    }

    // Cập nhật số lượng
    $cartItem->quantity = $validated['quantity'];
    $cartItem->save();

    return response()->json([
        'message' => 'Cart item updated successfully',
        'cart_item' => $cartItem,
    ], 200);
}

    // Xóa một sản phẩm khỏi giỏ hàng
    public function removeFromCart($id) {

        $cartItem = Cart::find($id);

    if (!$cartItem) {
        return response()->json(['message' => 'Item not found'], 404);
    }

    $cartItem->delete();

    return response()->json(['message' => 'Item removed successfully'], 200);
    }

    // Xóa toàn bộ giỏ hàng
    public function clearCart() {
        $user = Auth::user();
        Cart::where('user_id', $user->id)->delete();
        return response()->json(['message' => 'Đã xóa giỏ hàng']);
    }
    public function getCartItemCount($userId)
    {
        // Đếm tổng số lượng sản phẩm trong giỏ hàng
        $itemCount = Cart::where('user_id', $userId)->get();

        return response()->json([
            'status' => 'success',
            'item_count' => $itemCount,
        ]);
    }
}
