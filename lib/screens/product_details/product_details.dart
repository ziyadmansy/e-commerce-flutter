import 'package:e_commerce_app/providers/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetails extends StatelessWidget {
  static const ROUTE_NAME = 'productDetails';

  @override
  Widget build(BuildContext context) {
    final String productId = ModalRoute.of(context).settings.arguments;
    final providerObject = Provider.of<Products>(context, listen: false);
    final clickedProduct = providerObject.findItemById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(clickedProduct.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: Hero(
                tag: clickedProduct.id,
                child: Image.asset(clickedProduct.imageUrl),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              '\$${clickedProduct.price}',
              style: TextStyle(color: Colors.grey, fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              child: Text(
                clickedProduct.description,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
