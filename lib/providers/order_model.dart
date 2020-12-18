import 'package:e_commerce_app/providers/cart_model.dart';
import 'package:flutter/foundation.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<Cart> products;
  final DateTime dateTime;

  OrderItem({
    @required this.dateTime,
    @required this.id,
    @required this.products,
    @required this.amount,
  });
}
