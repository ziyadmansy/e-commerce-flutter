import 'package:e_commerce_app/global_widgets/order_item.dart';
import 'package:e_commerce_app/providers/order_items.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  static const ROUTE_NAME = '/Orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<Orders>(context, listen: false).fetchOrders();
    print('init success');
  }
  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<Orders>(context, listen: false).fetchOrders();
        },
        child: ListView.builder(
          itemCount: ordersData.orders.length,
          itemBuilder: (BuildContext context, int i) {
            return OrderItem(ordersData.orders[i]);
          },
        ),
      ),
    );
  }
}
