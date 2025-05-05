<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Shipping;

class ShippingController extends Controller
{
    //
    public function index()
    {
        $data = Shipping::where('status', 'active')->get();;

        return response()->json([
            'status' => 'success',
            'data' => $data,
        ]);
    }
}
