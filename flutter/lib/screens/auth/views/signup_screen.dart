import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shop/screens/auth/views/components/sign_up_form.dart';
import 'package:shop/route/route_constants.dart';
import 'package:http/http.dart' as http;

import '../../../constants.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Future<void> _register() async {
  //   final response = await http.post(
  //     Uri.parse('http://192.168.1.4:8000/api/register'),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(<String, String>{
  //       'name': _emailController.text,
  //       'email': _emailController.text,
  //       'password': _passwordController.text,
  //     }),
  //   );

  //   if (response.statusCode == 201) {
  //     final responseData = json.decode(response.body);
  //     final token = responseData['token'];

  //     // Lưu token cho các yêu cầu tiếp theo (có thể sử dụng shared_preferences)
  //     print('Login successful. Token: $token');
  //     Navigator.pushNamed(context, logInScreenRoute);
  //     Navigator.pushNamedAndRemoveUntil(context, entryPointScreenRoute,
  //         ModalRoute.withName(logInScreenRoute));
  //   } else {
  //     print('Login failed. Error: ${response.body}');
  //     // Hiển thị thông báo lỗi nếu đăng nhập thất bại
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //           content:
  //               Text('Đăng nhập thất bại, vui lòng kiểm tra lại thông tin')),
  //     );
  //   }
  // }
  Future<void> _register() async {
    final response = await http.post(
      Uri.parse(ApiConstants.registerUrl),
      body: {
        'name': _nameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
      },
    );

    if (response.statusCode == 201) {
      // final data = jsonDecode(response.body);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Đăng ký thành công'), backgroundColor: Colors.blue),
      );
      Navigator.pushNamed(context, logInScreenRoute);
    } else {
      print('Registration failed');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Email đã được sử dụng hãy chọn Email khác'),
            backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              "assets/images/signUp_dark.png",
              height: MediaQuery.of(context).size.height * 0.35,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Đăng ký để bắt đầu",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  const Text(
                    "Vui lòng nhập dữ liệu hợp lệ của bạn để tạo tài khoản.",
                  ),
                  const SizedBox(height: defaultPadding),
                  SignUpForm(
                    formKey: _formKey,
                    nameController: _nameController,
                    emailController: _emailController,
                    passwordController: _passwordController,
                  ),
                  const SizedBox(height: defaultPadding),
                  Row(
                    children: [
                      Checkbox(
                        onChanged: (value) {},
                        value: false,
                      ),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            text: "Tôi đồng ý với",
                            children: [
                              TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushNamed(
                                        context, termsOfServicesScreenRoute);
                                  },
                                text: " Điều khoản dich vụ ",
                                style: const TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const TextSpan(
                                text: "và chính sách bảo mật.",
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: defaultPadding * 2),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!
                            .save(); // Lưu giá trị từ form và truyền lên LoginScreen
                        _register(); // Gọi hàm đăng nhập
                      }
                    },
                    child: const Text("Đăng ký"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Nếu bạn đã có tài khoản?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, logInScreenRoute);
                        },
                        child: const Text("Đăng nhập"),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
