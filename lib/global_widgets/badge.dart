import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  final Widget child;
  final int quantity;

  Badge({this.child, this.quantity});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned(
          right: 0,
          child: Container(
            padding: EdgeInsets.all(1),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: quantity == 0 ? Colors.transparent : Colors.red[700],
            ),
            constraints: BoxConstraints(
              minWidth: 12,
              minHeight: 12,
            ),
            child: Text(
              quantity.toString(),
              style: TextStyle(
                color: quantity == 0 ? Colors.transparent : Colors.white,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
