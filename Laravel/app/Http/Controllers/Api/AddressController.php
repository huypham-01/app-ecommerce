<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use App\Models\Address;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;

class AddressController extends Controller
{
    //
    public function index($userId)
    {
        
        $addresses = Address::where('user_id', $userId)->get(); // Lọc theo user_id
        return response()->json($addresses);
    }
    //theem address
    public function addAddress(Request $request)
{
    Log::info('Dữ liệu nhận:', $request->all());
            $validated = $request->validate([
            'user_id' => 'required|exists:users,id',
            'name' => 'required|string|max:255',
            'phone' => 'required|string|max:20',
            'province' => 'required|string|max:255',
            'district' => 'required|string|max:255',
            'ward' => 'required|string|max:255',
            'street' => 'required|string|max:255',
            'address_type' => 'nullable|string|max:50',
            'is_default' => 'nullable|boolean',
        ]);
        if ($request->is_default) {
        Address::where('user_id', $validated['user_id'])->update(['is_default' => 0]);
    }

        $data = [
            'user_id' => $validated['user_id'],
            'name' => $validated['name'],
            'phone' => $validated['phone'],
            'province' => $validated['province'],
            'district' => $validated['district'],
            'ward' => $validated['ward'],
            'street' => $validated['street'],
            'address_type' => $validated['address_type'],
            'is_default' => $validated['is_default']  ? 1 : 0, // Chuyển true/false thành 1/0
        ];

        // Lưu địa chỉ
        $address = Address::create($data);
    return response()->json(['success' => true, 'data' => $address], 201);
}
public function update(Request $request, $id)
{
    // Tìm địa chỉ cần cập nhật
    $address = Address::find($id);

    if (!$address) {
        return response()->json(['message' => 'Address not found'], 404);
    }

    // Xác thực dữ liệu
    $validated = $request->validate([
        'name' => 'required|string|max:255',
        'phone' => 'required|string|max:20',
        'province' => 'required|string|max:255',
        'district' => 'required|string|max:255',
        'ward' => 'required|string|max:255',
        'street' => 'required|string|max:255',
        'address_type' => 'nullable|string|max:50',
        'is_default' => 'nullable|boolean',
    ]);

    // Nếu is_default là true, đặt tất cả địa chỉ khác của user về không mặc định
    if ($validated['is_default'] ?? false) {
        Address::where('user_id', $address->user_id)->update(['is_default' => 0]);
    }

    // Cập nhật địa chỉ hiện tại
    $address->update($validated);

    return response()->json([
        'message' => 'Address updated successfully',
        'address' => $address,
    ]);
}
}
