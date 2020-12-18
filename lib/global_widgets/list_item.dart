import 'package:e_commerce_app/providers/auth.dart';
import 'package:e_commerce_app/providers/cart_items.dart';
import 'package:e_commerce_app/providers/product_model.dart';
import 'package:e_commerce_app/screens/product_details/product_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ListItem extends StatefulWidget {
  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Product>(context, listen: false);
    final cartData = Provider.of<CartItems>(context);
    final authData = Provider.of<Auth>(context, listen: false);
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed(ProductDetails.ROUTE_NAME, arguments: productData.id);
      },
      child: Card(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 150,
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          height: constraints.maxHeight / 2,
                          width: 100,
                          child: CircleAvatar(
                            backgroundColor: Colors.grey,
                            radius: 50,
                            backgroundImage: AssetImage(productData.imageUrl),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          productData.title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          productData.description,
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          children: [
                            Text(
                              '\$${productData.price}',
                              style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '5.0 ⭐',
                              style: TextStyle(
                                color: Colors.yellow,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Positioned(
                      top: -10,
                      left: -10,
                      child: Consumer<Product>(
                        builder: (context, product, child) {
                          return IconButton(
                            icon: Icon(
                              product.isFavourite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: product.isFavourite
                                  ? Colors.red[700]
                                  : Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                try {
                                  product.toggleFavouriteStatus(
                                    authData.token,
                                    authData.userId,
                                  );
                                } catch (error) {
                                  Scaffold.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(error),
                                    ),
                                  );
                                }
                              });
                            },
                          );
                        },
                      ),
                    ),
                    Positioned(
                      top: -10,
                      right: -10,
                      child: Consumer<CartItems>(
                        builder: (_, cart, child) => IconButton(
                          icon: Icon(
                            Icons.shopping_cart_outlined,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            cart.addItem(
                              productData.id,
                              productData.price,
                              productData.title,
                              productData.imageUrl,
                            );
                            Scaffold.of(context).removeCurrentSnackBar();
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Added Successfully!'),
                                duration: Duration(seconds: 2),
                                action: SnackBarAction(
                                  label: 'UNDO',
                                  onPressed: () {
                                    cartData.undoProduct(productData.id);
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
