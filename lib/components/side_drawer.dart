import 'package:e_commerce_app/providers/auth.dart';
import 'package:e_commerce_app/screens/manage_products_screen.dart';
import 'package:e_commerce_app/screens/orders_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SideDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: SizedBox(),
          ),
          Divider(),
          ListTile(
            title: Text('Orders'),
            leading: Icon(Icons.monetization_on_outlined),
            onTap: () {
              Navigator.of(context).pushNamed(OrdersScreen.ROUTE_NAME);
            },
          ),
          ListTile(
            title: Text('Manage Products'),
            leading: Icon(Icons.account_balance),
            onTap: () {
              Navigator.of(context).pushNamed(ManageProductsScreen.ROUTE_NAME);
            },
          ),
          ListTile(
            title: Text('Log out'),
            leading: Icon(Icons.exit_to_app),
            onTap: () {
              Navigator.of(context).pop();
              Provider.of<Auth>(context, listen: false).logoutUser();
            },
          ),
        ],
      ),
    );
  }
}
