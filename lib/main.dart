import 'package:e_commerce_app/providers/auth.dart';
import 'package:e_commerce_app/providers/cart_items.dart';
import 'package:e_commerce_app/providers/order_items.dart';
import 'package:e_commerce_app/providers/products.dart';
import 'package:e_commerce_app/screens/add_product_screen.dart';
import 'package:e_commerce_app/screens/auth_screen.dart';
import 'package:e_commerce_app/screens/home/home.dart';
import 'package:e_commerce_app/screens/manage_products_screen.dart';
import 'package:e_commerce_app/screens/orders_screen.dart';
import 'package:e_commerce_app/screens/product_details/product_details.dart';
import 'package:e_commerce_app/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (context, authData, previousProductsData) => Products(
            authData.token,
            authData.userId,
            previousProductsData == null ? [] : previousProductsData.products,
          ),
          create: null,
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (context, authData, previousOrdersData) => Orders(
            authData.token,
            authData.userId,
            previousOrdersData == null ? [] : previousOrdersData.orders,
          ),
          create: null,
        ),
        ChangeNotifierProvider(
          create: (_) => CartItems(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, authData, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          // Removes Debug Banner
          title: 'E-Commerce App',
          theme: ThemeData.light().copyWith(
            accentColor: Colors.blue.shade400,
          ),
          home: authData.isAuth
              ? Home()
              : FutureBuilder(
                  future: authData.isUserLoggedIn(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SplashScreen();
                    } else {
                      return AuthScreen();
                    }
                  },
                ),
          routes: {
            AuthScreen.ROUTE_NAME: (context) => AuthScreen(),
            Home.ROUTE_NAME: (context) => Home(),
            ProductDetails.ROUTE_NAME: (context) => ProductDetails(),
            OrdersScreen.ROUTE_NAME: (context) => OrdersScreen(),
            ManageProductsScreen.ROUTE_NAME: (context) =>
                ManageProductsScreen(),
            AddProductScreen.ROUTE_NAME: (context) => AddProductScreen(),
          },
        ),
      ),
    );
  }
}
