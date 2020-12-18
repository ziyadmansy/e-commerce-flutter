import 'package:e_commerce_app/providers/products.dart';
import 'package:e_commerce_app/screens/add_product_screen.dart';
import 'package:e_commerce_app/screens/manage_products_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  final String productId;
  final String title;
  final String imageUrl;

  ProductItem(this.productId, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final scaffoldContext = Scaffold.of(context);
    final productsData = Provider.of<Products>(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: AssetImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Colors.grey,
              ),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(AddProductScreen.ROUTE_NAME,
                        arguments: productId)
                    .then((value) {
                  if (value) {
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Saved Successfully'),
                      ),
                    );
                  }
                });
              },
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () async {
                try {
                  await productsData.deleteProduct(productId);
                  scaffoldContext.showSnackBar(
                    SnackBar(
                      content: Text('Deleted Successfully'),
                    ),
                  );
                } catch (error) {
                  scaffoldContext.showSnackBar(
                    SnackBar(
                      content: Text(error),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
