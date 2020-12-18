import 'package:flutter/foundation.dart';

class Cart {
  String id;
  double price;
  String imageUrl;
  String title;
  int quantity;

  Cart({
    @required this.id,
    @required this.price,
    @required this.imageUrl,
    @required this.title,
    @required this.quantity,
  });
}
