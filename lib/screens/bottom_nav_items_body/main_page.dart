import 'package:e_commerce_app/enums/pop_up_menu.dart';
import 'package:e_commerce_app/providers/products.dart';
import 'package:e_commerce_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'list_view_products_widget.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool onlyFavouriteSelected = false;
  PopUpMenuSelection selectedItem = PopUpMenuSelection.All;

  bool once = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (once) {
      setState(() {
        isLoading = true;
      });
      Provider.of<Products>(context).getProducts(false).then((_) {
        setState(() {
          isLoading = false;
        });
      });
    }
    once = false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: false,
            snap: false,
            actions: [
              PopupMenuButton(
                tooltip: 'Filters',
                initialValue: selectedItem,
                icon: Icon(Icons.more_vert),
                onSelected: (selected) {
                  if (selected == PopUpMenuSelection.OnlyFavourites) {
                    setState(() {
                      onlyFavouriteSelected = true;
                      selectedItem = PopUpMenuSelection.OnlyFavourites;
                    });
                  } else if (selected == PopUpMenuSelection.All) {
                    setState(() {
                      onlyFavouriteSelected = false;
                      selectedItem = PopUpMenuSelection.All;
                    });
                  }
                },
                itemBuilder: (_) => [
                  PopupMenuItem(
                    child: Text('All'),
                    value: PopUpMenuSelection.All,
                  ),
                  PopupMenuItem(
                    child: Text('Only Favourites'),
                    value: PopUpMenuSelection.OnlyFavourites,
                  ),
                ],
              ),
            ],
            title: TextField(
              onChanged: (newText) {
                print(newText);
              },
              decoration: const InputDecoration(
                hintText: 'Search',
              ),
            ),
            iconTheme: IconThemeData(color: kUnSelectedNavColor),
            backgroundColor: Colors.transparent,
            centerTitle: true,
          ),
          SliverFillRemaining(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text('T-Shirts'),
                  ),
                  isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: SizedBox(
                            height: 300,
                            child: ListViewProducts(onlyFavouriteSelected),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
