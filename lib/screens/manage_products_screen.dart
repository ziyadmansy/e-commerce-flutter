import 'package:e_commerce_app/global_widgets/manage_products_item.dart';
import 'package:e_commerce_app/providers/products.dart';
import 'package:e_commerce_app/screens/add_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManageProductsScreen extends StatelessWidget {
  static const ROUTE_NAME = '/manageProductsScreen';

  Future<void> getProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).getProducts(false);
  }

  @override
  Widget build(BuildContext context) {
    //final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddProductScreen.ROUTE_NAME);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return getProducts(context);
        },
        child: FutureBuilder(
            future: getProducts(context),
            builder: (_, snapshot) {
              if (snapshot.connectionState != ConnectionState.waiting) {
                return Consumer<Products>(
                  builder: (context, productsData, _) {
                    return ListView.separated(
                      itemCount: productsData.products.length,
                      itemBuilder: (context, i) {
                        return Column(
                          children: [
                            ProductItem(
                              productsData.products[i].id,
                              productsData.products[i].title,
                              productsData.products[i].imageUrl,
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (context, i) => Divider(),
                    );
                  },
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }
}
