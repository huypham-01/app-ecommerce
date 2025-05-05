<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv="X-UA-Compatible" content="ie=edge">
  <title>Order @if($order)- {{$order->order_number}} @endif</title>
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
   <style>
    *{ font-family: DejaVu Sans !important;}
  </style>
</head>
<body>

@if($order)
<style type="text/css">
  .invoice-header {
    background: #f7f7f7;
    padding: 10px 20px 10px 20px;
    border-bottom: 1px solid gray;
  }
  .site-logo {
    margin-top: 20px;
  }
  .invoice-right-top h3 {
    padding-right: 20px;
    margin-top: 20px;
    color: green;
    font-size: 25px!important;
  }
  .invoice-left-top {
    border-left: 4px solid green;
    padding-left: 20px;
    padding-top: 20px;
    font-family: DejaVu Sans !important;
  }
  .invoice-left-top p {
    font-family: DejaVu Sans !important;
    margin: 0;
    line-height: 20px;
    font-size: 14px;
    margin-bottom: 3px;
  }
  thead {
    background: green;
    color: #FFF;
  }
  .authority h5 {
    margin-top: -10px;
    color: green;
  }
  .thanks h4 {
    text-align: center;
    color: green;
    font-size: 25px;
    font-weight: normal;
    /* margin-top: 20px; */
  }
  .site-address p {
    line-height: 6px;
    font-weight: 700;
  }
  .table tfoot .empty {
    border: none;
  }
  .table-bordered {
    border: none;
  }
  .table-header {
    padding: .75rem 1.25rem;
    margin-bottom: 0;
    background-color: rgba(0,0,0,.03);
    border-bottom: 1px solid rgba(0,0,0,.125);
  }
  .table td, .table th {
    padding: .30rem;
  }
</style>
  <div class="invoice-header">
    {{-- <div class="float-left site-logo">
      <img src="{{asset('backend/img/logo.png')}}" alt="">
    </div> --}}
    <div class="float-left site-address">
      <h4>{{env('APP_NAME')}}</h4>
      <p>{{env('APP_ADDRESS')}}</p>
      <p>Số điện thoại: 0913037878</a></p>
      <p>Email: shop@gmail.com.vn</a></p>
    </div>
    <div class="clearfix"></div>
  </div>
  <div class="invoice-description">
    <div class="invoice-left-top float-left">
      <div class="site-address"><p>Thông tin người nhận</p></div>
       <div class="address">
        <p>
          <strong>Tên khách hàng: </strong>
          {{$order->first_name}} {{$order->last_name}}
        </p>
        <p>
          <strong>Địa chỉ: </strong>
          {{ $order->address1 }}
        </p>
        <p>
          <strong>Địa điểm: </strong>
          {{ $order->post_code }}
        </p>
         <p><strong>Số điện thoại:</strong> {{ $order->phone }}</p>
         <p><strong>Email:</strong> {{ $order->email }}</p>
       </div>
    </div>
    <div class="clearfix"></div>
    <div class="invoice-right -topfloat-right" class="text-center">
      <p>Mã đơn hàng: #{{$order->order_number}}</p>
      <p>Ngày đặt hàng: {{ $order->created_at->format('D,d/m/Y') }}</p>
      {{-- <img class="img-responsive" src="data:image/png;base64, {{ base64_encode(QrCode::format('png')->size(150)->generate(route('admin.product.order.show', $order->id )))}}"> --}}
    </div>
    <div class="clearfix"></div>
  </div>
  <section class="order_details pt-3">
    <div class="table-header">
      <div class="site-address"><p>Chi tiết đơn hàng</p></div>
    </div>
    <table class="table table-bordered table-stripe">
      <thead>
        <tr>
          <th scope="col" class="col-6">Sản phẩm</th>
          <th scope="col" class="col-2">Kích cỡ</th>
          <th scope="col" class="col-2">Số lượng</th>
          <th scope="col" class="col-2">Tổng tiền</th>
        </tr>
      </thead>
      <tbody>
      @foreach($orderItem as $item)

        <tr>
          <td>{{ $item->product->title }}</td>
          <td>{{ $item->size }}</td>
          <td>{{ $item->quantity }}</td>
          <td>{{ $item->price * $item->quantity }}</td>
        </tr>
      @endforeach
      </tbody>
      <tfoot>
        <tr>
          <th scope="col" class="empty"></th>
          <th scope="col" class="empty"></th>
          <th scope="col" class="text-right">Tổng tiền:</th>
          <th scope="col"> <span>{{number_format($order->sub_total)}} vnđ</span></th>
        </tr>
      {{-- @if(!empty($order->coupon))
        <tr>
          <th scope="col" class="empty"></th>
          <th scope="col" class="text-right">Discount:</th>
          <th scope="col"><span>-{{$order->coupon->discount(Helper::orderPrice($order->id, $order->user->id))}}{{Helper::base_currency()}}</span></th>
        </tr>
      @endif --}}
        <tr>
          <th scope="col" class="empty"></th>
          <th scope="col" class="empty"></th>
          @php
            $shipping_charge=DB::table('shippings')->where('id',$order->shipping_id)->pluck('price');
          @endphp
          <th scope="col" class="text-right ">Phí vận chuyển:</th>
          <th><span>{{number_format($shipping_charge[0])}} vnđ</span></th>
        </tr>
        <tr>
          <th scope="col" class="empty"></th>
          <th scope="col" class="empty"></th>
          <th scope="col" class="text-right">Tổng cộng:</th>
          <th>
            <span>
                {{number_format($order->total_amount)}} vnđ
            </span>
          </th>
        </tr>
        <tr>
          <th scope="col" class="empty"></th>
          <th scope="col" class="empty"></th>
          <th scope="col" class="text-right">Tình trạng:</th>
          <th>
            <span>
                @if($order->payment_status == 'paid') Đã thanh toán @else Chưa thanh toán @endif
            </span>
          </th>
        </tr>
      </tfoot>
    </table>
  </section>
  <div class="thanks mt-3">
    <h4>------------Cảm ơn bạn đã đặt hàng-----------------</h4>
  </div>
  {{-- <div class="authority float-right mt-5">
    <p>-----------------------------------</p>
    <h5>Authority Signature:</h5>
  </div> --}}
  <div class="clearfix"></div>
@else
  <h5 class="text-danger">Invalid</h5>
@endif
</body>
</html>
