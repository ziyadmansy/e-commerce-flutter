import 'package:e_commerce_app/global_widgets/list_item.dart';
import 'package:e_commerce_app/providers/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListViewProducts extends StatelessWidget {
  final bool isFavourite;

  ListViewProducts(this.isFavourite);

  @override
  Widget build(BuildContext context) {
    final productsData =
        Provider.of<Products>(context); // Special Object of the Provider Class
    final favouriteProducts = productsData.products.where((element) {
      return element.isFavourite == true;
    }).toList();
    final products = isFavourite ? favouriteProducts : productsData.products;
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: products.length,
      itemBuilder: (BuildContext context, int i) {
        return ChangeNotifierProvider.value(
          // Use the value when we create a previously defined Class
          // Typically used in grid and list items
          value: products[i],
          child: Hero(
            tag: products[i].id,
            child: ListItem(),
          ),
        );
      },
    );
  }
}
