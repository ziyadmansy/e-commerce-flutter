import 'package:e_commerce_app/providers/cart_items.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String title;
  final double price;
  final int quantity;
  final String imageUrl;

  CartItem(
    this.id,
    this.title,
    this.price,
    this.quantity,
    this.imageUrl,
  );

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartItems>(context, listen: false);
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      background: Container(
        padding: EdgeInsets.only(right: 10),
        margin: EdgeInsets.all(4),
        color: Colors.red[700],
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
        alignment: Alignment.centerRight,
      ),
      confirmDismiss: (dismissDirection) {
        return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Warning'),
                content: Text(
                    'Are you sure to delete this item?\nThis will be permanently deleted'),
                actions: [
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Text('Yes'),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text('No'),
                  ),
                ],
              );
            });
        cart.removeItem(id);
      },
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(imageUrl),
          ),
          title: Text(title),
          subtitle: Text('Total: \$${(price * quantity).toStringAsFixed(2)}'),
          trailing: Text('$quantity x'),
        ),
      ),
    );
  }
}
