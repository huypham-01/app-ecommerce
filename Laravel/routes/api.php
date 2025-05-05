<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\ProductController;
use App\Http\Controllers\Api\CartController;
use App\Http\Controllers\Api\CategoryController;
use App\Http\Controllers\Api\AddressController;
use App\Http\Controllers\Api\ShippingController;
use App\Http\Controllers\Api\OrderController;
use App\Http\Controllers\Api\ProfileController;
use App\Http\Controllers\Api\ProductReviewController;
use App\Http\Controllers\Api\ProductSearchController;
use App\Models\Product;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/


Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);
Route::post('/logout', [AuthController::class, 'logout'])->middleware('auth:sanctum');

Route::get('/profile/{id}', [ProfileController::class, 'getUserProfile']);
Route::get('/products', [ProductController::class, 'index']);

Route::get('/products/{id}', [ProductController::class, 'getProductById']);
Route::post('product/{id}/review', [ProductReviewController::class, 'store']);

Route::get('/categorys', [CategoryController::class, 'index']);

Route::post('/cart/add', [CartController::class, 'addToCart']);
Route::get('/cart/{id}', [CartController::class, 'getCartItems']);
Route::post('/cart/update-quantity', [CartController::class, 'updateCartItem']);
Route::delete('/cart/remove/{id}', [CartController::class, 'removeFromCart']);
Route::post('/cart/clear', [CartController::class, 'clearCart']);
Route::get('/cart/item/{id}', [CartController::class, 'getCartItemCount']);
/////
Route::get('/addresses/index/{id}', [AddressController::class, 'index']);
Route::post('/addresses/add', [AddressController::class, 'addAddress']);
Route::put('/addresses/update/{id}', [AddressController::class, 'update']);

Route::get('/shipping', [ShippingController::class, 'index']);
Route::post('/orders', [OrderController::class, 'store']);
Route::get('/order/status/{id}', [OrderController::class, 'getOrderStatus']);
Route::post('order/{id}/cancel', [OrderController::class, 'cancelOrder']);
Route::post('order/{id}/delivered', [OrderController::class, 'markAsDelivered']);

Route::get('/search', [ProductSearchController::class, 'search']);