import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/cart_button.dart';
import 'package:shop/components/custom_modal_bottom_sheet.dart';
import 'package:shop/components/network_image_with_loader.dart';
import 'package:shop/providers/cart_provider.dart';
import 'package:shop/res/cart_provider.dart';
import 'package:shop/screens/product/views/added_to_cart_message_screen.dart';
import 'package:shop/screens/product/views/components/product_list_tile.dart';
import 'package:shop/screens/product/views/location_permission_store_availability_screen.dart';
import 'package:shop/screens/product/views/size_guide_screen.dart';
import 'package:shop/services/cart_service.dart';

import '../../../constants.dart';
import '../../../services/user_servece.dart';
import 'components/product_quantity.dart';
import 'components/selected_colors.dart';
import 'components/selected_size.dart';
import 'components/unit_price.dart';

class ProductBuyNowScreen extends StatefulWidget {
  const ProductBuyNowScreen(
      {super.key,
      required this.title,
      required this.image,
      required this.size,
      required this.price,
      this.priceAfetDiscount,
      this.dicountpercent,
      required this.stock,
      required this.id});
  final int id;
  final String title, image;
  final List<String> size;
  final double price;
  final double? priceAfetDiscount;
  final int? dicountpercent;
  final int stock;

  @override
  _ProductBuyNowScreenState createState() => _ProductBuyNowScreenState();
}

class _ProductBuyNowScreenState extends State<ProductBuyNowScreen> {
  int quantity = 1; // Initial quantity
  int selectedSizeIndex = -1; // Selected size

  late double totalPrice;
  @override
  void initState() {
    super.initState();
    // Initialize totalPrice based on initial quantity
    totalPrice = (widget.priceAfetDiscount ?? widget.price) * quantity;
  }

  // Method to update the total price
  void updateTotalPrice() {
    setState(() {
      totalPrice = (widget.priceAfetDiscount ?? widget.price) * quantity;
    });
  }

  Future<void> _addToCart() async {
    // Lấy size đã chọn
    String size = widget.size[selectedSizeIndex];
    int productId = widget.id;
    double price = widget.price;
    int? userId = await getUserId();
    // Lấy CartProvider từ context
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    // Gọi phương thức addToCart từ Provider
    await cartProvider.addToCart(productId, userId, quantity, price, size);

    OverlayHelper.showCustomOverlayMessage(
        // ignore: use_build_context_synchronously
        context,
        'Đã thêm sản phẩm vào giỏ hàng');
    Future.delayed(const Duration(seconds: 1), () {
      // Đặt lại Overlay khi kết thúc
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    String img = widget.image;
    return Scaffold(
      bottomNavigationBar: CartButton(
        price: totalPrice,
        title: "Thêm vào giỏ hàng",
        subTitle: "Tổng cộng",
        press: () {
          // ignore: prefer_is_empty
          if (selectedSizeIndex < 0) {
            OverlayHelper.showCustomOverlayMessage(
                context, 'Bạn chưa chọn kích thước sản phẩm');
          } else {
            _addToCart();
          }
        },
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding / 2, vertical: defaultPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const BackButton(),
                Expanded(
                  child: Text(
                    widget.title,
                    style: Theme.of(context).textTheme.titleSmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset("assets/icons/Bookmark.svg",
                      color: Theme.of(context).textTheme.bodyLarge!.color),
                ),
              ],
            ),
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: defaultPadding),
                    child: AspectRatio(
                      aspectRatio: 1.05,
                      child: Image.network(
                        img.replaceFirst(
                            ApiConstants.local, ApiConstants.ifcon),
                        fit: BoxFit.cover, // Cân chỉnh hình ảnh
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(defaultPadding),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: UnitPrice(
                            price: widget.price,
                            priceAfterDiscount: widget.priceAfetDiscount,
                          ),
                        ),
                        ProductQuantity(
                          numOfItem: quantity,
                          onIncrement: () {
                            if (quantity < widget.stock) {
                              setState(() {
                                quantity++;
                              });
                              updateTotalPrice();
                            } else {
                              // Show message if quantity exceeds stock
                              OverlayHelper.showCustomOverlayMessage(
                                  context, 'Vượt quá số lượng trong kho');
                              ;
                            }
                          },
                          onDecrement: () {
                            if (quantity > 1) {
                              setState(() {
                                quantity--;
                              });
                              updateTotalPrice();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                // const SliverToBoxAdapter(child: Divider()),
                // SliverToBoxAdapter(
                //   child: SelectedColors(
                //     colors: const [
                //       Color(0xFFEA6262),
                //       Color(0xFFB1CC63),
                //       Color(0xFFFFBF5F),
                //       Color(0xFF9FE1DD),
                //       Color(0xFFC482DB),
                //     ],
                //     selectedColorIndex: 2,
                //     press: (value) {},
                //   ),
                // ),
                SliverToBoxAdapter(
                  child: SelectedSize(
                    sizes: widget.size,
                    selectedIndex: selectedSizeIndex,
                    press: (index) {
                      setState(() {
                        selectedSizeIndex = index;
                      });
                    },
                  ),
                ),
                // SliverPadding(
                //   padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                //   sliver: ProductListTile(
                //     title: "Size guide",
                //     svgSrc: "assets/icons/Sizeguid.svg",
                //     isShowBottomBorder: true,
                //     press: () {
                //       customModalBottomSheet(
                //         context,
                //         height: MediaQuery.of(context).size.height * 0.9,
                //         child: const SizeGuideScreen(),
                //       );
                //     },
                //   ),
                // ),
                // SliverPadding(
                //   padding:
                //       const EdgeInsets.symmetric(horizontal: defaultPadding),
                //   sliver: SliverToBoxAdapter(
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         const SizedBox(height: defaultPadding / 2),
                //         Text(
                //           "Store pickup availability",
                //           style: Theme.of(context).textTheme.titleSmall,
                //         ),
                //         const SizedBox(height: defaultPadding / 2),
                //         const Text(
                //             "Select a size to check store availability and In-Store pickup options.")
                //       ],
                //     ),
                //   ),
                // ),
                // SliverPadding(
                //   padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                //   sliver: ProductListTile(
                //     title: "Check stores",
                //     svgSrc: "assets/icons/Stores.svg",
                //     isShowBottomBorder: true,
                //     press: () {
                //       customModalBottomSheet(
                //         context,
                //         height: MediaQuery.of(context).size.height * 0.92,
                //         child: const LocationPermissonStoreAvailabilityScreen(),
                //       );
                //     },
                //   ),
                // ),
                // const SliverToBoxAdapter(
                //     child: SizedBox(height: defaultPadding))
              ],
            ),
          )
        ],
      ),
    );
  }
}
