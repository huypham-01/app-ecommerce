<?php
namespace App\Models;

use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, Notifiable;

    protected $fillable = [
        'name',
        'email',
        'password',
    ];

    // Quan hệ với bảng Address
    public function addresses()
    {
        return $this->hasMany(Address::class, 'user_id');
    }

    // Mã hóa mật khẩu trước khi lưu
    public static function boot()
    {
        parent::boot();
        static::creating(function ($user) {
            if ($user->password) {
                $user->password = bcrypt($user->password);
            }
        });
    }
}
