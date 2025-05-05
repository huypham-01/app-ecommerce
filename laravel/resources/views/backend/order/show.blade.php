@extends('backend.layouts.master')

@section('title','Order Detail')

@section('main-content')
<div class="card">
<h5 class="card-header">Đơn hàng       <a href="{{route('order.pdf',$order->id)}}" class=" btn btn-sm btn-primary shadow-sm float-right"><i class="fas fa-download fa-sm text-white-50"></i> In đơn hàng</a>
  </h5>
  <div class="card-body">
    @if($order)
    <table class="table table-striped table-hover">
      <thead>
        <tr>
            <th>S.N.</th>
            <th>Mã đơn hàng</th>
            <th>Tên sản phẩm</th>
            <th>Email</th>
            {{-- <th>Quantity</th> --}}
            <th>Phí vận chuyển</th>
            <th>Tổng cộng</th>
            <th>Trạng thái</th>
            <th>Thao tác</th>
        </tr>
      </thead>
      <tbody>
        <tr>
            <td>{{$order->id}}</td>
            <td>{{$order->order_number}}</td>
            <td>{{$order->first_name}} {{$order->last_name}}</td>
            <td>{{$order->email}}</td>
            {{-- <td>{{$order->quantity}}</td> --}}
            <td>${{$order->shipping->price}}</td>
            <td>${{number_format($order->total_amount,2)}}</td>
            <td>
                @if($order->status=='new')
                  <span class="badge badge-primary">Đơn hàng mới</span>
                @elseif($order->status=='process')
                  <span class="badge badge-warning">Đang chuẩn bị hàng</span>
                @elseif($order->status=='delivered')
                  <span class="badge badge-success">Đã giao</span>
                @else
                  <span class="badge badge-danger">Huỷ đơn</span>
                @endif
            </td>
            <td>
                <a href="{{route('order.edit',$order->id)}}" class="btn btn-primary btn-sm float-left mr-1" style="height:30px; width:30px;border-radius:50%" data-toggle="tooltip" title="edit" data-placement="bottom"><i class="fas fa-edit"></i></a>
                <form method="POST" action="{{route('order.destroy',[$order->id])}}">
                  @csrf
                  @method('delete')
                      <button class="btn btn-danger btn-sm dltBtn" data-id={{$order->id}} style="height:30px; width:30px;border-radius:50%" data-toggle="tooltip" data-placement="bottom" title="Delete"><i class="fas fa-trash-alt"></i></button>
                </form>
            </td>

        </tr>
      </tbody>
    </table>

    <section class="confirmation_part section_padding">
      <div class="order_boxes">
        <div class="row">
          <div class="col-lg-6 col-lx-4">
            <div class="order-info">
              <h4 class="text-center pb-4">THÔNG TIN ĐƠN HÀNG</h4>
              <table class="table">
                    <tr class="">
                        <td>Mã đơn hàng</td>
                        <td> : {{$order->order_number}}</td>
                    </tr>
                    <tr>
                        <td>Ngày đặt hàng</td>
                        <td> : {{$order->created_at->format('d/m/Y')}} vào lúc {{$order->created_at->format('g : i a')}} </td>
                    </tr>
                    @foreach ($orderItems as $item)
                        <tr>
                        <td>Sản phẩm</td>
                        <td> : {{ $item->product->title }} - {{ $item-> size}} - {{ $item->quantity }}</td>
                    </tr>
                    @endforeach
                  
                    
                    <tr>
                        <td>Phí vận chuyển</td>
                        <td> : $ {{$order->shipping->price}}</td>
                    </tr>
                    <tr>
                      <td>Giảm giá</td>
                      <td> : $ {{number_format($order->coupon,2)}}</td>
                    </tr>
                    <tr>
                        <td>Tổng cộng</td>
                        <td> : $ {{number_format($order->total_amount,2)}}</td>
                    </tr>
                    <tr>
                        <td>Hình thức thanh toán</td>
                        <td> : @if($order->payment_method=='cod') Thanh toán khi nhận hàng @else Paypal @endif</td>
                    </tr>
                    {{-- <tr>
                        <td>Payment Status</td>
                        <td> : {{$order->payment_status}}</td>
                    </tr> --}}
              </table>
            </div>
          </div>

          <div class="col-lg-6 col-lx-4">
            <div class="shipping-info">
              <h4 class="text-center pb-4">THÔNG TIN VẬN CHUYỂN</h4>
              <table class="table">
                    <tr class="">
                        <td >Tên khách hàng</td>
                        <td> : {{$order->first_name}} {{$order->last_name}}</td>
                    </tr>
                    <tr>
                        <td>Email</td>
                        <td> : {{$order->email}}</td>
                    </tr>
                    <tr>
                        <td>SĐT</td>
                        <td> : {{$order->phone}}</td>
                    </tr>
                    <tr>
                        <td>Địa chỉ</td>
                        <td> : {{$order->address1}}</td>
                    </tr>
                    <tr>
                        <td>Địa điểm</td>
                        <td> : {{$order->post_code}}</td>
                    </tr>
              </table>
            </div>
          </div>
        </div>
      </div>
    </section>
    @endif

  </div>
</div>
@endsection

@push('styles')
<style>
    .order-info,.shipping-info{
        background:#ECECEC;
        padding:20px;
    }
    .order-info h4,.shipping-info h4{
        text-decoration: underline;
    }

</style>
@endpush
