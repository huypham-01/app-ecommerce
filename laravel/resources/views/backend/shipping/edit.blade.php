@extends('backend.layouts.master')

@section('main-content')

<div class="card">
    <h5 class="card-header">Chỉnh sửa phương thức vận chuyển</h5>
    <div class="card-body">
      <form method="post" action="{{route('shipping.update',$shipping->id)}}">
        @csrf 
        @method('PATCH')
        <div class="form-group">
          <label for="inputTitle" class="col-form-label">Phương thức vận chuyển <span class="text-danger">*</span></label>
        <input id="inputTitle" type="text" name="type" placeholder="Nhập phương thức vận chuyển"  value="{{$shipping->type}}" class="form-control">
        @error('title')
        <span class="text-danger">{{$message}}</span>
        @enderror
        </div>     
        <div class="form-group">
          <label for="price" class="col-form-label">Giá vận chuyển <span class="text-danger">*</span></label>
        <input id="price" type="number" name="price" placeholder="Nhập giá vận chuyển"  value="{{$shipping->price}}" class="form-control">
        @error('price')
        <span class="text-danger">{{$message}}</span>
        @enderror
        </div>        
        <div class="form-group">
          <label for="status" class="col-form-label">Trạng thái <span class="text-danger">*</span></label>
          <select name="status" class="form-control">
            <option value="active" {{(($shipping->status=='active') ? 'selected' : '')}}>Kích hoạt</option>
            <option value="inactive" {{(($shipping->status=='inactive') ? 'selected' : '')}}>Huỷ kích hoạt</option>
          </select>
          @error('status')
          <span class="text-danger">{{$message}}</span>
          @enderror
        </div>
        <div class="form-group mb-3">
           <button class="btn btn-success" type="submit">Cập nhật</button>
        </div>
      </form>
    </div>
</div>

@endsection

@push('styles')
<link rel="stylesheet" href="{{asset('backend/summernote/summernote.min.css')}}">
@endpush
@push('scripts')
<script src="/vendor/laravel-filemanager/js/stand-alone-button.js"></script>
<script src="{{asset('backend/summernote/summernote.min.js')}}"></script>
<script>
    $('#lfm').filemanager('image');

    $(document).ready(function() {
    $('#description').summernote({
      placeholder: "Write short description.....",
        tabsize: 2,
        height: 150
    });
    });
</script>
@endpush