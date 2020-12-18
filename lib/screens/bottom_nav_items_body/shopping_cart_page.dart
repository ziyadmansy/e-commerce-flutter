import 'package:e_commerce_app/components/side_drawer.dart';
import 'package:e_commerce_app/global_widgets/cart_item.dart';
import 'package:e_commerce_app/providers/cart_items.dart';
import 'package:e_commerce_app/providers/order_items.dart';
import 'package:e_commerce_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShoppingCartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartItems>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cart',
          style: TextStyle(color: Colors.grey),
        ),
        iconTheme: IconThemeData(color: kUnSelectedNavColor),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      drawer: SideDrawer(),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemsCount,
              itemBuilder: (BuildContext context, int index) {
                return CartItem(
                  cart.items.keys.toList()[index],
                  cart.items.values.toList()[index].title,
                  cart.items.values.toList()[index].price,
                  cart.items.values.toList()[index].quantity,
                  cart.items.values.toList()[index].imageUrl,
                );
              },
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
          ),
          ListTile(
            leading: Container(
              padding: EdgeInsets.only(top: 8),
              child: Icon(Icons.attach_money),
            ),
            trailing: FlatButton(
              child: const Text(
                'ORDER NOW',
              ),
              onPressed: cart.items.length == 0
                  ? null
                  : () {
                      final orders =
                          Provider.of<Orders>(context, listen: false);
                      orders.addOrder(
                          cart.items.values.toList(), cart.totalPrice);
                      cart.clearCart();
                    },
            ),
            title: const Text('Total Price'),
            subtitle: Text(
              '\$${cart.totalPrice.toStringAsFixed(2)}',
              maxLines: 1,
              style: TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
