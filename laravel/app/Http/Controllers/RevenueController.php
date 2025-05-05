<?php

namespace App\Http\Controllers;

use App\Models\Order;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class RevenueController extends Controller
{
    public function getTotalRevenue()
    {
        // Tổng doanh thu từ các đơn hàng đã thanh toán
        $totalRevenue = Order::where('status', 'delivered')->sum('sub_total');
        return response()->json(['total_revenue' => $totalRevenue]);
    }

    public function getRevenueByMonth()
    {
        // Doanh thu theo tháng
        $revenueByMonth = Order::where('status', 'delivered')
            ->select(DB::raw('YEAR(created_at) as year, MONTH(created_at) as month'), DB::raw('SUM(sub_total) as monthly_revenue'))
            ->groupBy(DB::raw('YEAR(created_at), MONTH(created_at)'))
            ->orderBy(DB::raw('YEAR(created_at), MONTH(created_at)'))
            ->get();
        
        return response()->json($revenueByMonth);
    }

    // public function getRevenueByDay()
    // {
    //      // Lấy doanh thu theo ngày
    //     $revenues = DB::table('orders')
    //     ->select(DB::raw('DATE(created_at) as date'), DB::raw('SUM(total_amount) as daily_revenue'))
    //     ->where('status', 'completed') // Lọc chỉ các đơn hàng đã hoàn thành
    //     ->groupBy(DB::raw('DATE(created_at)'))
    //     ->orderBy('date', 'asc')
    //     ->get();
    // dd($revenues);
    // return response()->json($revenues);
    // }

    public function getRevenueByDay()
    {
        // Lấy doanh thu theo ngày
        $data = Order::selectRaw('DATE(orders.created_at) as date, SUM(orders.sub_total) as daily_revenue')
                ->where('orders.status', 'delivered') // Trạng thái "completed" của đơn hàng
                ->groupBy('date')
                ->orderBy('date', 'asc')  // Sắp xếp theo ngày
                ->get();

        return response()->json($data);
    }
}
