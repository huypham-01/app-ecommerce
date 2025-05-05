<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('addresses', function (Blueprint $table) {
            $table->id(); // ID tự tăng
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade'); // Khóa ngoại tới bảng users
            $table->string('name'); // Tên người nhận
            $table->string('phone'); // Số điện thoại
            $table->string('province'); // Tỉnh/Thành phố
            $table->string('district'); // Quận/Huyện
            $table->string('ward'); // Phường/Xã
            $table->string('street'); // Tên đường, Toà nhà, Số nhà
            $table->enum('address_type', ['Nhà Riêng', 'Văn Phòng'])->default('Nhà Riêng'); // Loại địa chỉ
            $table->boolean('is_default')->default(false); // Địa chỉ mặc định
            $table->timestamps(); // Thêm created_at và updated_at
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('addresses');
    }
};
