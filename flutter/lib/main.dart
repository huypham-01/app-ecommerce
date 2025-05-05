import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/providers/addresses_provider.dart';
import 'package:shop/providers/auth_provider.dart';
import 'package:shop/providers/cart_provider.dart';
import 'package:shop/providers/catagory_provider.dart';
import 'package:shop/providers/order_provider.dart';
import 'package:shop/providers/product_provider.dart';
import 'package:shop/providers/shipping_provider.dart';
import 'package:shop/providers/user_provider.dart';
import 'package:shop/route/route_constants.dart';
import 'package:shop/route/router.dart' as router;
import 'package:shop/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  runApp(
    MyApp(isLoggedIn: token != null),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ShippingProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()..fetchItemCount()),
        ChangeNotifierProvider(
            create: (_) => CategoryProvider()..fetchCategories()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => AddressProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(
            create: (context) => UserProvider()..fetchUserDetails()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Shop Template by The Flutter Way',
        theme: AppTheme.lightTheme(context),
        // Dark theme is inclided in the Full template
        themeMode: ThemeMode.light,
        onGenerateRoute: router.generateRoute,
        initialRoute: isLoggedIn ? entryPointScreenRoute : logInScreenRoute,
      ),
    );
  }
}
