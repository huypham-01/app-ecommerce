import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart'; // Để định dạng ngày

// Just for demo
const productDemoImg1 = "https://i.imgur.com/CGCyp1d.png";
const productDemoImg2 = "https://i.imgur.com/AkzWQuJ.png";
const productDemoImg3 = "https://i.imgur.com/J7mGZ12.png";
const productDemoImg4 = "https://i.imgur.com/q9oF9Yq.png";
const productDemoImg5 = "https://i.imgur.com/MsppAcx.png";
const productDemoImg6 = "https://i.imgur.com/JfyZlnO.png";

class ApiConstants {
  static const local = "127.0.0.1:8000";
  static const ifcon = "192.168.43.122:8000";
  static const String baseUrl = 'http://$ifcon/api';
  // http://192.168.43.122:8000/api/login

  static const String loginUrl = '$baseUrl/login';
  static const String registerUrl = '$baseUrl/register';
  static const String logoutUrl = '$baseUrl/logout';
  static const String productUrl = '$baseUrl/products';
  static const String categoryUrl = '$baseUrl/categorys';
  static const String cartUrl = '$baseUrl/cart';
  static const String addressesUrl = '$baseUrl/addresses';
  // Bạn có thể thêm các đường dẫn API khác tại đây nếu cần
}
// End For demo

const grandisExtendedFont = "Grandis Extended";

class Dateship {
  static calculateDeliveryDate(String delivery) {
    final now = DateTime.now();

    switch (delivery) {
      case 'express':
        final today = now;
        final tomorrow = now.add(Duration(days: 1));
        return "Đơn hàng của bạn sẽ được giao từ ngày ${DateFormat('dd/MM/yyyy').format(today)} hoặc ${DateFormat('dd/MM/yyyy').format(tomorrow)}";
      case 'fast':
        final day3 = now.add(Duration(days: 3));
        final day4 = now.add(Duration(days: 4));
        return "Đơn hàng của bạn sẽ được giao từ ngày ${DateFormat('dd/MM/yyyy').format(day3)} - ${DateFormat('dd/MM/yyyy').format(day4)}";
      case 'economy':
        return "Nhận hàng sau 5-7 ngày làm việc";
      default:
        return "Không rõ thời gian nhận hàng";
    }
  }
}

class SplitFullname {
  static Map<String, String> splitFullName(String fullName) {
    final parts = fullName.trim().split(' '); // Tách bằng khoảng trắng
    if (parts.length == 1) {
      return {'first_name': parts[0], 'last_name': ''}; // Nếu chỉ có một từ
    }
    final firstName = parts.first; // Lấy phần đầu
    final lastName = parts.sublist(1).join(' '); // Phần còn lại
    return {'first_name': firstName, 'last_name': lastName};
  }
}

String formatPrice(double price) {
  final format = NumberFormat("#,##0", "en_US");
  String formattedPrice = format.format(price);
  return formattedPrice.replaceAll(',', '.'); // Thay dấu , bằng dấu .
}

// On color 80, 60.... those means opacity

const Color primaryColor = Color(0xFF7B61FF);

const MaterialColor primaryMaterialColor =
    MaterialColor(0xFF9581FF, <int, Color>{
  50: Color(0xFFEFECFF),
  100: Color(0xFFD7D0FF),
  200: Color(0xFFBDB0FF),
  300: Color(0xFFA390FF),
  400: Color(0xFF8F79FF),
  500: Color(0xFF7B61FF),
  600: Color(0xFF7359FF),
  700: Color(0xFF684FFF),
  800: Color(0xFF5E45FF),
  900: Color(0xFF6C56DD),
});

class OverlayHelper {
  static OverlayEntry? _currentOverlay;

  /// Hiển thị thông báo Overlay ở trung tâm màn hình
  static void showCustomOverlayMessage(BuildContext context, String message) {
    // Nếu đã có Overlay đang hiển thị, loại bỏ nó trước
    _currentOverlay?.remove();

    _currentOverlay = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height *
            0.4, // Đặt vị trí trung tâm màn hình
        left: MediaQuery.of(context).size.width * 0.1, // Căn chỉnh từ bên trái
        width: MediaQuery.of(context).size.width * 0.8, // Độ rộng của thông báo
        child: Material(
          color: Colors.transparent,
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(18, 206, 197, 197)
                    .withOpacity(0.7), // Hiệu ứng trong suốt
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                message,
                style: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_currentOverlay!);

    // Tự động loại bỏ thông báo sau 3 giây
    Future.delayed(const Duration(seconds: 3), () {
      _currentOverlay?.remove();
      _currentOverlay = null; // Đặt lại Overlay khi kết thúc
    });
  }
}

const Color blackColor = Color(0xFF16161E);
const Color blackColor80 = Color(0xFF45454B);
const Color blackColor60 = Color(0xFF737378);
const Color blackColor40 = Color(0xFFA2A2A5);
const Color blackColor20 = Color(0xFFD0D0D2);
const Color blackColor10 = Color(0xFFE8E8E9);
const Color blackColor5 = Color(0xFFF3F3F4);

const Color whiteColor = Colors.white;
const Color whileColor80 = Color(0xFFCCCCCC);
const Color whileColor60 = Color(0xFF999999);
const Color whileColor40 = Color(0xFF666666);
const Color whileColor20 = Color(0xFF333333);
const Color whileColor10 = Color(0xFF191919);
const Color whileColor5 = Color(0xFF0D0D0D);

const Color greyColor = Color(0xFFB8B5C3);
const Color lightGreyColor = Color(0xFFF8F8F9);
const Color darkGreyColor = Color(0xFF1C1C25);
// const Color greyColor80 = Color(0xFFC6C4CF);
// const Color greyColor60 = Color(0xFFD4D3DB);
// const Color greyColor40 = Color(0xFFE3E1E7);
// const Color greyColor20 = Color(0xFFF1F0F3);
// const Color greyColor10 = Color(0xFFF8F8F9);
// const Color greyColor5 = Color(0xFFFBFBFC);

const Color purpleColor = Color(0xFF7B61FF);
const Color successColor = Color(0xFF2ED573);
const Color warningColor = Color(0xFFFFBE21);
const Color errorColor = Color(0xFFEA5B5B);

class AppColor {
  static const Color primary = Color(0xFF242476);
  static const Color primarySoft = Color(0xFFEAEAF2);
  static const Color secondary = Color(0xFF0A0E2F);
  static const Color accent = Color(0xFFFABA3E);
  static const Color border = Color(0xFFD3D3E4);
}

const double defaultPadding = 13.0;
const double defaultBorderRadious = 12.0;
const Duration defaultDuration = Duration(milliseconds: 300);

final passwordValidator = MultiValidator([
  RequiredValidator(errorText: 'Mật khẩu bắt buộc'),
  MinLengthValidator(8, errorText: 'Mật khẩu phải dài ít nhất 8 chữ số'),
  PatternValidator(r'(?=.*?[#?!@$%^&*-])',
      errorText: 'Mật khẩu phải có ít nhất một ký tự đặc biệt'),
]);

final emaildValidator = MultiValidator([
  RequiredValidator(errorText: 'Bạn chưa nhập Email'),
  EmailValidator(errorText: "Email không hợp lệ"),
]);
final namedValidator = MultiValidator([
  RequiredValidator(errorText: 'Bạn chưa họ và tên'),
]);

const pasNotMatchErrorText = "Mật khẩu không trùng khớp";
