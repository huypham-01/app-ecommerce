<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use App\Models\User;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;

class ProfileController extends Controller
{
    //
    // public function getUserProfile(Request $request, $userId)
    // {
    //      $user = User::find($userId);
    //      if ($user) {
    //         return response()->json($'User không tồn tại'], 404);
    //     }
    // }
    public function getUserProfile($id)
    {
        $user = User::where('status', 'active')->find($id);
        if ($user) {
            return response()->json($user);
        } else {
            return response()->json(['message' => 'Sản phẩm không tồn tại'], 404);
        }
    }
}
