<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use App\Models\Order;
use App\Models\Product;
use App\Models\OrderItem;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Auth;

class OrderController extends Controller
{
    //
   public function store(Request $request)
    {
        DB::beginTransaction();
        try {
            // Lưu đơn hàng vào bảng orders
            $order = Order::create([
                'order_number' => $request->order_number,
                'user_id' => $request->user_id,
                'sub_total' => $request->sub_total,
                'shipping_id' => $request->shipping_id,
                'coupon' => $request->coupon,
                'total_amount' => $request->total_amount,
                'payment_method' => $request->payment_method,
                'first_name' => $request->first_name,
                'last_name' => $request->last_name,
                'email' => $request->email,
                'phone' => $request->phone,
                'country' => $request->country,
                'post_code' => $request->post_code,
                'address1' => $request->address1,
                'address2' => $request->address2,
            ]);

            // Lưu sản phẩm vào bảng orderItems
            foreach ($request->items as $item) {
                OrderItem::create([
                    'order_id' => $order->id,
                    'product_id' => $item['product_id'],
                    'user_id' =>$request->user_id,
                    'size' => $item['size'],
                    'quantity' => $item['quantity'],
                    'price' => $item['price'],
                ]);
                // Cập nhật số lượng tồn kho
                $product = Product::find($item['product_id']);
                if ($product) {
                    $newStock = $product->stock - $item['quantity']; // Trừ số lượng đã mua
                    if ($newStock < 0) {
                        throw new \Exception('Not enough stock for product: ' . $product->title);
                    }

                    // Cập nhật lại số lượng tồn kho trong bảng products
                    $product->stock = $newStock;
                    $product->save();
                }
            }

            DB::commit();
            return response()->json(['message' => 'Order created successfully'], 201);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['message' => 'Error: ' . $e->getMessage()], 500);
        }
    }
    public function getOrderStatus(Request $request, $userId) {
        $orderstatus = OrderItem::where('user_id', $userId)->with(['order', 'product'])->get();;

        return response()->json($orderstatus);
    
    }
    public function cancelOrder($id)
    {
        // Tìm đơn hàng theo ID
        $order = Order::find($id);

        // Kiểm tra xem đơn hàng có tồn tại và trạng thái có phải là "new" (chưa xác nhận)
        if ($order && $order->status === 'new') {
            // Cập nhật trạng thái đơn hàng thành "cancel"
            $order->status = 'cancel';
            $order->save();

            // Trả về thông báo thành công
            return response()->json(['message' => 'Đơn hàng đã được hủy thành công.']);
        }

        // Nếu không tìm thấy đơn hàng hoặc đơn hàng không thể hủy (đã quá trình khác), trả về lỗi
        return response()->json(['message' => 'Không thể hủy đơn hàng.'], 400);
    }
    public function markAsDelivered($id)
    {
        // Tìm đơn hàng theo ID
        $order = Order::find($id);

        // Kiểm tra xem đơn hàng có tồn tại và trạng thái có phải là "new" (chưa xác nhận)
        if ($order && $order->status === 'process') {
            // Cập nhật trạng thái đơn hàng thành "cancel"
            $order->status = 'delivered';
            $order->save();

            // Trả về thông báo thành công
            return response()->json(['message' => 'success']);
        }

        // Nếu không tìm thấy đơn hàng hoặc đơn hàng không thể hủy (đã quá trình khác), trả về lỗi
        return response()->json(['message' => 'Không thể nhận đơn hàng.'], 400);
    }
}
