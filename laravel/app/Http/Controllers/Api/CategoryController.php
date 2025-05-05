<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use App\Models\Category;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;

class CategoryController extends Controller
{
    //
    public function index()
    {
        $catas = Category::where('status', 'active')->with('child_cat')->get();;

        return response()->json($catas);
    }
}
