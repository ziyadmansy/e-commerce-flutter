import 'package:e_commerce_app/components/side_drawer.dart';
import 'package:e_commerce_app/global_widgets/badge.dart';
import 'package:e_commerce_app/providers/cart_items.dart';
import 'package:e_commerce_app/screens/bottom_nav_items_body/categories_page.dart';
import 'package:e_commerce_app/screens/bottom_nav_items_body/favourites_page.dart';
import 'package:e_commerce_app/screens/bottom_nav_items_body/main_page.dart';
import 'package:e_commerce_app/screens/bottom_nav_items_body/profile_page.dart';
import 'package:e_commerce_app/screens/bottom_nav_items_body/shopping_cart_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  static const ROUTE_NAME = 'homeRoute';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, Object>> bottomNavItems = [
    {
      'body': MainPage(),
      'title': 'Home',
    },
    {
      'body': CategoriesPage(),
      'title': 'Categories',
    },
    {
      'body': ShoppingCartPage(),
      'title': 'Cart',
    },
    {
      'body': FavouritesPage(),
      'title': 'Favourites',
    },
    {
      'body': ProfilePage(),
      'title': 'Profile',
    },
  ];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        unselectedIconTheme: IconThemeData(opacity: 0.7, size: 23),
        selectedIconTheme: IconThemeData(opacity: 1, size: 27),
        items: [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: bottomNavItems[0]['title'],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: bottomNavItems[1]['title'],
          ),
          BottomNavigationBarItem(
            icon: Consumer<CartItems>(
              builder: (_, cart, child) {
                return Badge(
                  child: child,
                  quantity: cart.itemsCount,
                );
              },
              child: Icon(Icons.shopping_cart),
            ),
            label: bottomNavItems[2]['title'],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: bottomNavItems[3]['title'],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: bottomNavItems[4]['title'],
          ),
        ],
        onTap: (newIndex) {
          setState(() {
            currentIndex = newIndex;
          });
        },
      ),
      /*BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  Icons.home_outlined,
                  size: selectedItem == 0
                      ? kSelectedNavIconSize
                      : kUnSelectedNavIconSize,
                  color: selectedItem == 0
                      ? kSelectedNavColor
                      : kUnSelectedNavColor,
                ),
                onPressed: () {
                  setState(() {
                    currentIndex = 0;
                    selectedItem = 0;
                  });
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.favorite_border_outlined,
                  size: selectedItem == 1
                      ? kSelectedNavIconSize
                      : kUnSelectedNavIconSize,
                  color: selectedItem == 1
                      ? kSelectedNavColor
                      : kUnSelectedNavColor,
                ),
                onPressed: () {
                  setState(() {
                    currentIndex = 1;
                    selectedItem = 1;
                  });
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.search_outlined,
                  size: selectedItem == 2
                      ? kSelectedNavIconSize
                      : kUnSelectedNavIconSize,
                  color: selectedItem == 2
                      ? kSelectedNavColor
                      : kUnSelectedNavColor,
                ),
                onPressed: () {
                  setState(() {
                    currentIndex = 2;
                    selectedItem = 2;
                  });
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.person_outline,
                  size: selectedItem == 3
                      ? kSelectedNavIconSize
                      : kUnSelectedNavIconSize,
                  color: selectedItem == 3
                      ? kSelectedNavColor
                      : kUnSelectedNavColor,
                ),
                onPressed: () {
                  setState(() {
                    currentIndex = 3;
                    selectedItem = 3;
                  });
                },
              ),
            ],
          ),
        ),
        shape: CircularNotchedRectangle(),
      ),*/
      /*floatingActionButton: Padding(
        padding: const EdgeInsets.all(2.0),
        child: FloatingActionButton(
          tooltip: 'Shopping Cart',
          child: Icon(Icons.shopping_cart),
          onPressed: () {},
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,*/
      body: bottomNavItems[currentIndex]['body'],
    );
  }
}
