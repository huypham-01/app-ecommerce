@extends('backend.layouts.master')
@section('title','E-SHOP || DASHBOARD')
@section('main-content')
<div class="container-fluid">
    @include('backend.layouts.notification')
    <!-- Page Heading -->
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
      <h1 class="h3 mb-0 text-gray-800">Thống kê</h1>
    </div>

    <!-- Content Row -->
    <div class="row">

      <!-- Category -->
      <div class="col-xl-3 col-md-6 mb-4">
        <div class="card border-left-primary shadow h-100 py-2">
          <div class="card-body">
            <div class="row no-gutters align-items-center">
              <div class="col mr-2">
                <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">Danh mục</div>
                <div class="h5 mb-0 font-weight-bold text-gray-800">{{\App\Models\Category::countActiveCategory()}}</div>
              </div>
              <div class="col-auto">
                <i class="fas fa-sitemap fa-2x text-gray-300"></i>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Products -->
      <div class="col-xl-3 col-md-6 mb-4">
        <div class="card border-left-success shadow h-100 py-2">
          <div class="card-body">
            <div class="row no-gutters align-items-center">
              <div class="col mr-2">
                <div class="text-xs font-weight-bold text-success text-uppercase mb-1">Sản phẩm</div>
                <div class="h5 mb-0 font-weight-bold text-gray-800">{{\App\Models\Product::countActiveProduct()}}</div>
              </div>
              <div class="col-auto">
                <i class="fas fa-cubes fa-2x text-gray-300"></i>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Order -->
      <div class="col-xl-3 col-md-6 mb-4">
        <div class="card border-left-info shadow h-100 py-2">
          <div class="card-body">
            <div class="row no-gutters align-items-center">
              <div class="col mr-2">
                <div class="text-xs font-weight-bold text-info text-uppercase mb-1">Đơn hàng</div>
                <div class="row no-gutters align-items-center">
                  <div class="col-auto">
                    <div class="h5 mb-0 mr-3 font-weight-bold text-gray-800">{{\App\Models\Order::countActiveOrder()}}</div>
                  </div>
                  
                </div>
              </div>
              <div class="col-auto">
                <i class="fas fa-clipboard-list fa-2x text-gray-300"></i>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!--Posts-->
      <div class="col-xl-3 col-md-6 mb-4">
        <div class="card border-left-warning shadow h-100 py-2">
          <div class="card-body">
            <div class="row no-gutters align-items-center">
              <div class="col mr-2">
                <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">Đã bán</div>
                <div class="h5 mb-0 font-weight-bold text-gray-800">{{\App\Models\Order::countActiveProduct()}}</div>
              </div>
              <div class="col-auto">
                <i class="fas fa-cubes fa-2x text-gray-300"></i>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="row">

      <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-primary shadow h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">Tổng doanh thu</div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800" id="totalRevenue">₫0</div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-dollar-sign fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    
      <!-- Pie Chart -->
      <div class="col-xl-8 col-lg-7">
            <div class="card shadow mb-4">
                <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                    <h6 class="m-0 font-weight-bold text-primary">Doanh thu theo tháng</h6>
                </div>
                <div class="card-body">
                    <canvas id="myMonthlyChart"></canvas> <!-- Đổi ID ở đây -->
                </div>
            </div>
        </div>
        
        
    </div>
    <!-- Content Row -->
        <div class="row">
        <div class="col-xl-11 col-lg-7">
            <div class="card shadow mb-4">
                <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                    <h6 class="m-0 font-weight-bold text-primary">Doanh thu theo ngày</h6>
                </div>
                <div class="card-body">
                    <canvas id="myDailyChart"></canvas> <!-- Đổi ID ở đây -->
                </div>
            </div>
        </div>
    </div>
    
  </div>
@endsection

@push('scripts')

  
  <script src="https://unpkg.com/axios/dist/axios.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    // Fetch Total Revenue
    axios.get("{{ route('admin.revenue') }}")
        .then(function(response) {
            document.getElementById('totalRevenue').innerText = '₫' + response.data.total_revenue.toLocaleString();
        })
        .catch(function(error) {
            console.log(error);
        });

    // Fetch Revenue By Month and Draw Chart
    axios.get("{{ url('admin/revenue-by-month') }}")
        .then(function(response) {
            const data = response.data;
            const labels = data.map(item => item.month + '/' + item.year);
            const revenues = data.map(item => item.monthly_revenue);

            // Đảm bảo không bị trùng ID
            var ctxMonthly = document.getElementById("myMonthlyChart").getContext('2d');
            var myMonthlyChart = new Chart(ctxMonthly, {
                type: 'line',
                data: {
                    labels: labels,
                    datasets: [{
                        label: "Doanh thu theo tháng",
                        data: revenues,
                        backgroundColor: "rgba(78, 115, 223, 0.05)",
                        borderColor: "rgba(78, 115, 223, 1)",
                        pointRadius: 3,
                        pointBackgroundColor: "rgba(78, 115, 223, 1)",
                        pointBorderColor: "rgba(78, 115, 223, 1)",
                        pointHoverRadius: 3,
                        pointHoverBackgroundColor: "rgba(78, 115, 223, 1)",
                        pointHoverBorderColor: "rgba(78, 115, 223, 1)",
                        pointHitRadius: 10,
                        pointBorderWidth: 2
                    }]
                },
                options: {
                    maintainAspectRatio: false,
                    layout: { padding: { left: 10, right: 25, top: 25, bottom: 0 } },
                    scales: {
                        x: { time: { unit: 'month' }, gridLines: { display: false } },
                        y: {
                            ticks: {
                                callback: function(value) { return '₫' + value.toLocaleString(); }
                            }
                        }
                    },
                    legend: { display: false }
                }
            });
        })
        .catch(function(error) {
            console.log(error);
        });
    // Fetch Revenue By Day and Draw Bar Chart (Biểu đồ cột)
axios.get("{{ url('admin/revenue-by-day') }}")
    .then(function(response) {
        console.log(response.data);  // Kiểm tra dữ liệu trả về
        if (!response.data || response.data.length === 0) {
            console.log('Dữ liệu trống');
            return;
        }

        const data = response.data;
        const labels = data.map(item => item.date);
        const revenues = data.map(item => item.daily_revenue);

        // Biểu đồ cột (bar chart)
        var ctxDaily = document.getElementById("myDailyChart").getContext('2d');
        var myDailyChart = new Chart(ctxDaily, {
            type: 'bar', // Thay đổi type thành 'bar'
            data: {
                labels: labels,
                datasets: [{
                    label: "Doanh thu theo ngày",
                    data: revenues,
                    backgroundColor: "rgba(78, 115, 223, 0.75)", // Màu nền của các cột
                    borderColor: "rgba(78, 115, 223, 1)", // Màu viền của cột
                    borderWidth: 1
                }]
            },
            options: {
                maintainAspectRatio: false,
                layout: {
                    padding: { left: 10, right: 25, top: 25, bottom: 0 }
                },
                scales: {
                    x: {
                        gridLines: { display: false },
                    },
                    y: {
                        ticks: {
                            callback: function(value) {
                                return '₫' + value.toLocaleString(); // Định dạng tiền tệ
                            }
                        }
                    }
                },
                legend: { display: false }
            }
        });
    })
    .catch(function(error) {
        console.log('Lỗi khi lấy dữ liệu:', error);
    });
</script>
@endpush