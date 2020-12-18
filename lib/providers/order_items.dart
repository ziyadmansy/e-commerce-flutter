import 'dart:convert';

import 'package:e_commerce_app/providers/cart_model.dart';
import 'package:e_commerce_app/providers/order_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class Orders with ChangeNotifier {
  String token;
  String userId;

  Orders(this.token, this.userId, this._orders);

  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return _orders;
  }

  Future<void> fetchOrders() async {
    final String url =
        'https://test-projects-15fb9.firebaseio.com/orders/$userId.json?auth=$token';
    Response response = await get(url);
    final Map<String, dynamic> decodedResponseBody = json.decode(response.body);
    print(decodedResponseBody);
    if (decodedResponseBody == null) {
      return;
    }
    List<OrderItem> tempOrders = [];
    decodedResponseBody.forEach((orderId, orderData) {
      tempOrders.add(
        OrderItem(
          dateTime: DateTime.parse(orderData['dateTime']),
          id: orderId,
          amount: orderData['amount'],
          products: (orderData['orderItems'] as List<dynamic>)
              .map((cartItem) => Cart(
                    id: cartItem['id'],
                    price: cartItem['price'],
                    imageUrl: cartItem['imageUrl'],
                    title: cartItem['title'],
                    quantity: cartItem['quantity'],
                  ))
              .toList(),
        ),
      );
    });
    _orders = tempOrders.reversed.toList();
    print('success');
    notifyListeners();
  }

  Future<void> addOrder(List<Cart> cartItems, double total) async {
    final String url =
        'https://test-projects-15fb9.firebaseio.com/orders/$userId.json?auth=$token';
    Response response = await post(url,
        body: json.encode({
          'amount': total,
          'dateTime': DateTime.now().toIso8601String(),
          'orderItems': cartItems
              .map((cartItem) => {
                    'id': cartItem.id,
                    'price': cartItem.price,
                    'imageUrl': cartItem.imageUrl,
                    'title': cartItem.title,
                    'quantity': cartItem.quantity,
                  })
              .toList(),
        }));
    if (response.statusCode < 400) {
      _orders.add(OrderItem(
        dateTime: DateTime.now(),
        id: json.decode(response.body)['name'],
        products: cartItems,
        amount: total,
      ));
      notifyListeners();
    }
  }
}
