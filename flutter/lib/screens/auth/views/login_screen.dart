import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/constants.dart';
import 'package:shop/providers/auth_provider.dart';
import 'package:shop/route/route_constants.dart';
import 'components/login_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Future<void> _login() async {
  //   final response = await http.post(
  //     Uri.parse(ApiConstants.loginUrl),
  //     body: {
  //       'email': _emailController.text,
  //       'password': _passwordController.text,
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     // print('okok');
  //     final data = jsonDecode(response.body);
  //     final String token = data['token'];
  //     final int userId = data['user']['id'];

  //     // Lưu token vào SharedPreferences
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     await prefs.setInt('user_id', userId);
  //     await prefs.setString('token', token);

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //           content: Text('Đăng nhập thành công'),
  //           backgroundColor: Colors.blue),
  //     );
  //     Navigator.pushNamed(context, logInScreenRoute);
  //     Navigator.pushNamedAndRemoveUntil(context, entryPointScreenRoute,
  //         ModalRoute.withName(logInScreenRoute));
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //           content: Text('Đăng nhập thất bại'), backgroundColor: Colors.blue),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              "assets/images/login_dark.png",
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Chào mừng bạn!",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  const Text(
                    "Đăng nhập bằng dữ liệu mà bạn đã tạo trong quá trình đăng ký.",
                  ),
                  const SizedBox(height: defaultPadding),
                  LogInForm(
                    formKey: _formKey,
                    emailController: _emailController,
                    passwordController: _passwordController,
                  ),
                  Align(
                    child: TextButton(
                      child: const Text("Quên mật khẩu?"),
                      onPressed: () {
                        Navigator.pushNamed(
                            context, passwordRecoveryScreenRoute);
                      },
                    ),
                  ),
                  SizedBox(
                    height:
                        size.height > 700 ? size.height * 0.1 : defaultPadding,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        bool success = await Provider.of<AuthProvider>(context,
                                listen: false)
                            .login(_emailController.text,
                                _passwordController.text);
                        if (success) {
                          // Lưu token vào SharedPreferences sau khi đăng nhập thành công
                          final prefs = await SharedPreferences.getInstance();
                          final token = await Provider.of<AuthProvider>(context,
                                  listen: false)
                              .getToken();
                          final userId = await Provider.of<AuthProvider>(
                                  context,
                                  listen: false)
                              .userId;
                          await prefs.setString('token', token);
                          await prefs.setInt('user_id', userId);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Đăng nhập thành công")),
                          );

                          // Điều hướng đến màn hình chính
                          Navigator.pushNamed(context, logInScreenRoute);
                          Navigator.pushNamedAndRemoveUntil(
                              context,
                              entryPointScreenRoute,
                              ModalRoute.withName(logInScreenRoute));
                        } else {
                          // Hiển thị thông báo lỗi
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Đăng nhập thất bại")),
                          );
                        }
                      }
                    },
                    child: const Text("Đăng nhập"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Chưa có tài khoản?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, signUpScreenRoute);
                        },
                        child: const Text("Đăng ký"),
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
