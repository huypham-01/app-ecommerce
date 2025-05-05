// import 'package:flutter/material.dart';
// import 'package:shop/models/cart_model.dart';

// class CartProvider with ChangeNotifier {
//   final Map<int, CartItem> _items = {}; // Key là `int`

//   Map<int, CartItem> get items => {..._items};

//   int get itemCount {
//     return _items.length;
//   }

//   double get totalAmount {
//     return _items.values
//         .fold(0, (total, item) => total + (item.price * item.quantity));
//   }

//   void addItem(int id, String title, String image, double price) {
//     if (_items.containsKey(id)) {
//       _items.update(
//         id,
//         (existingItem) => CartItem(
//           id: existingItem.id,
//           title: existingItem.title,
//           image: existingItem.image,
//           price: existingItem.price,
//           quantity: existingItem.quantity + 1,
//         ),
//       );
//     } else {
//       _items.putIfAbsent(
//         id,
//         () => CartItem(
//           id: id,
//           title: title,
//           image: image,
//           price: price,
//         ),
//       );
//     }
//     print("Items in Cart: $_items");
//     notifyListeners();
//   }

//   void removeItem(int id) {
//     _items.remove(id);
//     notifyListeners();
//   }

//   void clear() {
//     _items.clear();
//     notifyListeners();
//   }
// }
