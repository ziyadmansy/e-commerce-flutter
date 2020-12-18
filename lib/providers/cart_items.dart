import 'package:e_commerce_app/providers/cart_model.dart';
import 'package:flutter/material.dart';

class CartItems with ChangeNotifier {
  Map<String, Cart> _items = {};

  Map<String, Cart> get items {
    return {..._items};
  }

  int get itemsCount {
    return _items.length;
  }

  double get totalPrice {
    double total = 0;
    _items.forEach((key, value) {
      return total += (value.price * value.quantity);
    });
    return total;
  }

  void addItem(
    String productId,
    double productPrice,
    String productTitle,
    String imageUrl,
  ) {
    if (_items.containsKey(productId)) {
      // Item already in cart so increase the quantity
      _items.update(
          productId,
          (existingCartItem) => Cart(
                id: existingCartItem.id,
                price: existingCartItem.price,
                title: existingCartItem.title,
                imageUrl: existingCartItem.imageUrl,
                quantity: existingCartItem.quantity + 1,
              ));
    } else {
      // Item is not in the cart so add it
      _items.putIfAbsent(
          productId,
          () => Cart(
                id: DateTime.now().toString(),
                price: productPrice,
                imageUrl: imageUrl,
                title: productTitle,
                quantity: 1,
              ));
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void undoProduct(String productId) {
    if (_items.containsKey(productId)) {
      if (_items[productId].quantity > 1) {
        _items.update(
          productId,
          (existingCartItem) => Cart(
              id: existingCartItem.id,
              price: existingCartItem.price,
              imageUrl: existingCartItem.imageUrl,
              title: existingCartItem.title,
              quantity: existingCartItem.quantity - 1),
        );
      } else {
        _items.remove(productId);
      }
    }
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
