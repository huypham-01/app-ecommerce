<?php

namespace App\Models;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;

class Order extends Model
{
    protected $fillable=['user_id','order_number','sub_total','quantity','delivery_charge','status','total_amount','first_name','last_name','country','post_code','address1','address2','phone','email','payment_method','payment_status','shipping_id','coupon'];

    public function cart_info(){
        return $this->hasMany('App\Models\Cart','order_id','id');
    }
    public static function getAllOrder($id){
        return Order::with('cart_info')->find($id);
    }
    public static function countActiveOrder(){
        $data=Order::count();
        if($data){
            return $data;
        }
        return 0;
    }
    public function cart(){
        return $this->hasMany(Cart::class);
    }

    public function shipping(){
        return $this->belongsTo(Shipping::class,'shipping_id');
    }
    public function user()
    {
        return $this->belongsTo('App\User', 'user_id');
    }
    public function items()
    {
        return $this->hasMany(OrderItem::class, 'order_id');
    }
//     public function getSoldProductData() {
//     // Lấy số lượng sản phẩm đã bán
//     $soldProducts = OrderItem::select('product_id', DB::raw('SUM(quantity) as total_sold'))
//                               ->whereHas('order', function($query) {
//                                   $query->where('status', 'delivered'); // Chỉ lấy đơn hàng đã hoàn thành
//                               })
//                               ->groupBy('product_id')
//                               ->get();
    
//     // Trả về danh sách sản phẩm đã bán
//     return $soldProducts;
// }
public static function getSoldQuantity() {
    $soldQuantity = OrderItem::whereHas('order', function($query) {
        $query->where('status', 'delivered'); // Chỉ lấy đơn hàng đã hoàn thành
    })
    ->sum('quantity'); // Tính tổng số lượng sản phẩm bán được

    return $soldQuantity;
}
    public static function countActiveProduct(){
        $data=Order::where('status','delivered')->count();
        if($data){
            return $data;
        }
        return 0;
    }
}
