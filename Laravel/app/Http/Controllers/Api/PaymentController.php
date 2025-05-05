<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use App\Models\User;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;

class PaymentController extends Controller
{
    public function getBankDetails()
    {
        // Cung cấp thông tin tài khoản ngân hàng hoặc ví điện tử
        $bankDetails = [
            'bank_name' => 'Agribank',
            'account_number' => '4501205208729',
            'account_holder' => 'PHAM QUANG HUY',
            'transaction_reference' => '',
        ];

        return response()->json($bankDetails);
    }
}
