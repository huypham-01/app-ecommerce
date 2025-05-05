<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class OrderItem extends Model
{
    use HasFactory;
    protected $table = 'order_items';

    // Cột có thể được gán dữ liệu
    protected $fillable = [
        'order_id',
        'user_id',
        'product_id',
        'size',
        'quantity',
        'price',
    ];

    /**
     * Quan hệ với model Order
     * Một OrderItem thuộc về một Order
     */
    public function order()
    {
        return $this->belongsTo(Order::class, 'order_id');
    }

    /**
     * Quan hệ với model Product
     * Một OrderItem thuộc về một Product
     */
    public function product()
    {
        return $this->belongsTo(Product::class, 'product_id');
    }
    // public function user()
    // {
    //     return $this->belongsTo(User::class, 'user_id');
    // }

    /**
     * Tính tổng tiền cho một dòng sản phẩm (quantity * price)
     */
    public function getTotalPriceAttribute()
    {
        return $this->quantity * $this->price;
    }

}
