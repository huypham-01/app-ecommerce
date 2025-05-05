import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/list_tile/divider_list_tile.dart';
import 'package:shop/constants.dart';
import 'package:shop/providers/auth_provider.dart';
import 'package:shop/providers/user_provider.dart';
import 'package:shop/route/screen_export.dart';

import 'components/profile_card.dart';
import 'components/profile_menu_item_list_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          buildProfileCartDetails(context),
          // Order Section
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: buiOrderDetails(context),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: Text(
              "Tài khoản",
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          const SizedBox(height: defaultPadding / 2),
          // ProfileMenuListTile(
          //   text: "Returns",
          //   svgSrc: "assets/icons/Return.svg",
          //   press: () {},
          // ),

          ProfileMenuListTile(
            text: "Địa chỉ",
            svgSrc: "assets/icons/Address.svg",
            press: () {
              Navigator.pushNamed(context, addressesScreenRoute);
            },
          ),
          ProfileMenuListTile(
            text: "Phương thức thanh toán",
            svgSrc: "assets/icons/card.svg",
            press: () {
              Navigator.pushNamed(context, emptyPaymentScreenRoute);
            },
          ),
          ProfileMenuListTile(
            text: "Phương thức vận chuyển",
            svgSrc: "assets/icons/Wishlist.svg",
            press: () {
              Navigator.pushNamed(context, shippingMethodScreenRoute);
            },
          ),
          ProfileMenuListTile(
            text: "Wallet",
            svgSrc: "assets/icons/Wallet.svg",
            press: () {
              Navigator.pushNamed(context, walletScreenRoute);
            },
          ),
          const SizedBox(height: defaultPadding),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding, vertical: defaultPadding / 2),
            child: Text(
              "Cài đặt",
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          DividerListTileWithTrilingText(
            svgSrc: "assets/icons/Notification.svg",
            title: "Thông báo",
            trilingText: "Off",
            press: () {
              Navigator.pushNamed(context, enableNotificationScreenRoute);
            },
          ),
          ProfileMenuListTile(
            text: "Tuỳ chọn",
            svgSrc: "assets/icons/Preferences.svg",
            press: () {
              Navigator.pushNamed(context, preferencesScreenRoute);
            },
          ),
          const SizedBox(height: defaultPadding),
          // Padding(
          //   padding: const EdgeInsets.symmetric(
          //       horizontal: defaultPadding, vertical: defaultPadding / 2),
          //   child: Text(
          //     "Settings",
          //     style: Theme.of(context).textTheme.titleSmall,
          //   ),
          // ),
          // ProfileMenuListTile(
          //   text: "Language",
          //   svgSrc: "assets/icons/Language.svg",
          //   press: () {
          //     Navigator.pushNamed(context, selectLanguageScreenRoute);
          //   },
          // ),
          // ProfileMenuListTile(
          //   text: "Location",
          //   svgSrc: "assets/icons/Location.svg",
          //   press: () {},
          // ),
          // const SizedBox(height: defaultPadding),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding, vertical: defaultPadding / 2),
            child: Text(
              "Trợ giúp & Hỗ trợ",
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          ProfileMenuListTile(
            text: "Hỗ trợ",
            svgSrc: "assets/icons/Help.svg",
            press: () {
              Navigator.pushNamed(context, getHelpScreenRoute);
            },
          ),
          ProfileMenuListTile(
            text: "FAQ",
            svgSrc: "assets/icons/FAQ.svg",
            press: () {},
            isShowDivider: false,
          ),
          // const SizedBox(height: defaultPadding),

          // Log Out
          ListTile(
            onTap: () async {
              // Gọi hàm đăng xuất từ AuthProvider
              bool success =
                  await Provider.of<AuthProvider>(context, listen: false)
                      .logout();
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Đăng xuất thành công')),
                );

                // Điều hướng về màn hình đăng nhập
                Navigator.pushNamed(context, logInScreenRoute);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Đăng xuất thất bại')),
                );
              }
            },
            minLeadingWidth: 24,
            leading: SvgPicture.asset(
              "assets/icons/Logout.svg",
              height: 24,
              width: 24,
              colorFilter: const ColorFilter.mode(
                errorColor,
                BlendMode.srcIn,
              ),
            ),
            title: const Text(
              "Đăng xuất",
              style: TextStyle(color: errorColor, fontSize: 14, height: 1),
            ),
          )
        ],
      ),
    );
  }

  Widget buildProfileCartDetails(BuildContext context) {
    // Sử dụng Consumer để lấy dữ liệu người dùng từ UserProvider
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        // Kiểm tra xem dữ liệu đang được tải hay chưa
        if (userProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // Kiểm tra xem có dữ liệu người dùng hay không
        if (userProvider.user == null) {
          return const Center(child: Text('No user data available.'));
        }

        // Lấy dữ liệu người dùng
        final user = userProvider.user!;

        return ProfileCard(
          name: user.name, // Tên người dùng từ provider
          email: user.email, // Email người dùng từ provider
          imageSrc: user.photo, // Ảnh người dùng từ provider
          press: () {
            // Navigator.pushNamed(context, userInfoScreenRoute);
          },
        );
      },
    );
  }

  Widget buiOrderDetails(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Color.fromARGB(42, 185, 197, 202),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Đơn mua",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                GestureDetector(
                  onTap: () {
                    // Hành động khi nhấn vào "Xem thêm"
                    Navigator.pushNamed(context, orderStatusScreenRoute);
                  },
                  child: Text(
                    "Xem lịch sử mua hàng",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: const Color.fromARGB(255, 121, 123, 124),
                        fontWeight: FontWeight.normal,
                        fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildOrderIcon(
                  "assets/icons/wai.svg",
                  'Chờ xác nhận',
                ),
                _buildOrderIcon(
                  "assets/icons/shipping.svg",
                  'Chờ giao hàng',
                ),
                _buildOrderIcon("assets/icons/danhgia.svg", 'Đánh giá'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderIcon(String icon, String label) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: SvgPicture.asset(
                icon,
                height: 24,
              ),
              onPressed: () {
                // Điều hướng đến màn hình giỏ hàng
              },
            ),
            Positioned(
              right: 4,
              top: 4,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '3', // Hiển thị số lượng item
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
