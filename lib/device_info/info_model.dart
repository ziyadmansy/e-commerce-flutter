import 'package:e_commerce_app/enums/device_type_enum.dart';
import 'package:flutter/material.dart';

class DeviceInfo {
  final Orientation orientation;
  final DeviceType deviceType;
  final double screenHeight;
  final double screenWidth;
  final double parentHeight;
  final double parentWidth;

  DeviceInfo({
    @required this.orientation,
    @required this.deviceType,
    @required this.screenHeight,
    @required this.screenWidth,
    this.parentHeight,
    this.parentWidth,
  });
}
