<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Address extends Model
{
    use HasFactory;
    protected $fillable = [
        'user_id',
        'name',
        'phone',
        'province',
        'district',
        'ward',
        'street',
        'address_type',
        'is_default',
    ];
    // Mối quan hệ với User
    public function user()
    {
        return $this->belongsTo(User::class, 'id');
    }
}
