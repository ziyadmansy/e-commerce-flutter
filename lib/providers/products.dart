import 'dart:convert';

import 'package:e_commerce_app/exceptions/http_exception.dart';
import 'package:e_commerce_app/providers/product_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class Products with ChangeNotifier {
  String token;
  String userId;

  Products(this.token, this.userId, this._products);

  List<Product> _products = [
    /*Product(
      id: 'shirt 1',
      title: 'Blue Shirt',
      description: 'Cool Blue Shirt!',
      price: 99.9,
      imageUrl: 'assets/images/blue_shirt.png',
    ),
    Product(
      id: 'shirt 2',
      title: 'Orange Shirt',
      description: 'Cool Shirt!',
      price: 43.93,
      imageUrl: 'assets/images/orange_shirt.png',
    ),
    Product(
      id: 'shirt 3',
      title: 'Green Style',
      description: 'Cool Shirt!',
      price: 132.32,
      imageUrl: 'assets/images/polo-shirt.png',
    ),
    Product(
      id: 'shirt 4',
      title: 'White Style',
      description: 'Cool Shirt!',
      price: 324.9,
      imageUrl: 'assets/images/shirt.png',
    ),
    Product(
      id: 'shirt 5',
      title: 'Red Shirt',
      description: 'Cool Shirt!',
      price: 123.9,
      imageUrl: 'assets/images/suite.png',
    ),
    Product(
      id: 'shirt 6',
      title: 'Real Madrid',
      description: 'Cool Shirt!',
      price: 104.9,
      imageUrl: 'assets/images/tshirt.png',
    ),
    Product(
      id: 'shirt 7',
      title: 'Football',
      description: 'Cool Shirt!',
      price: 732.9,
      imageUrl: 'assets/images/blue_shirt.png',
    ),*/
  ];

  List<Product> get products {
    return _products;
  }

  Product findItemById(String id) {
    return products.firstWhere((item) => item.id == id);
  }

  Future<void> editProduct(String productId, Product newProduct) async {
    final String url =
        'https://test-projects-15fb9.firebaseio.com/products/$productId.json?auth=$token';
    await patch(url,
        body: json.encode({
          'description': newProduct.description,
          'imageUrl': newProduct.imageUrl,
          'price': newProduct.price,
          'title': newProduct.title,
        }));
    int productIndex =
        _products.indexWhere((element) => element.id == productId);
    _products[productIndex] = newProduct;
    notifyListeners();
  }

  Future<void> getProducts([bool filterProductsByUser = true]) async {
    String filteredUrl =
        filterProductsByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    String url =
        'https://test-projects-15fb9.firebaseio.com/products.json?auth=$token&$filteredUrl';

    Response response = await get(url);
    final Map<String, dynamic> decodedResponseBody = json.decode(response.body);

    url =
        'https://test-projects-15fb9.firebaseio.com/usersFavourites/$userId.json?auth=$token';

    Response favouriteProductsResponse = await get(url);
    final decodedFavouriteResponseBody =
        json.decode(favouriteProductsResponse.body);
    final List<Product> loadedList = [];
    decodedResponseBody.forEach((productId, productData) {
      loadedList.add(Product(
        description: productData['description'],
        imageUrl: productData['imageUrl'],
        price: productData['price'],
        title: productData['title'],
        id: productId,
        isFavourite: decodedFavouriteResponseBody == null
            ? false
            : decodedFavouriteResponseBody[productId] ?? false,
      ));
    });
    _products = loadedList;
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    final String url =
        'https://test-projects-15fb9.firebaseio.com/products.json?auth=$token';

    try {
      Response response = await post(url,
          body: json.encode({
            'title': product.title.trim(),
            'description': product.description.trim(),
            'imageUrl': product.imageUrl.trim(),
            'price': product.price,
            'creatorId': userId,
          }));

      final responseBody = json.decode(response.body);
      final newProduct = Product(
        description: product.description.trim(),
        imageUrl: product.imageUrl.trim(),
        price: product.price,
        title: product.title.trim(),
        id: responseBody['name'],
      );

      _products.add(newProduct);
      notifyListeners();
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<void> deleteProduct(String productId) async {
    final String url =
        'https://test-projects-15fb9.firebaseio.com/products/$productId.json?auth=$token';
    final productIndex =
        _products.indexWhere((element) => element.id == productId);
    final product = _products[productIndex];
    _products.removeWhere((element) => element.id == productId);
    notifyListeners();
    Response response = await delete(url);
    if (response.statusCode >= 400) {
      _products.insert(productIndex, product);
      throw HttpException('Status Code >= 400');
    }

    notifyListeners();
  }
}
