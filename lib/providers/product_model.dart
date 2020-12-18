import 'package:e_commerce_app/exceptions/http_exception.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'dart:convert';

class Product with ChangeNotifier {
  String id;
  String title;
  String description;
  double price;
  String imageUrl;
  bool isFavourite;

  Product({
    @required this.description,
    @required this.imageUrl,
    @required this.price,
    @required this.title,
    @required this.id,
    this.isFavourite = false,
  });

  void revertOldFavouriteStatus(bool oldStatus) {
    isFavourite = oldStatus;
    notifyListeners();
  }

  Future<void> toggleFavouriteStatus(String token, String userId) async {
    final String url =
        'https://test-projects-15fb9.firebaseio.com/usersFavourites/$userId/$id.json?auth=$token';
    final oldStatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    try {
      Response response = await put(url, body: json.encode(isFavourite));
      if (response.statusCode >= 400) {
        revertOldFavouriteStatus(oldStatus);
      }
    } catch (error) {
      revertOldFavouriteStatus(oldStatus);
    }
  }
}
