import 'package:e_commerce_app/device_info/info_model.dart';
import 'package:e_commerce_app/enums/device_type_enum.dart';
import 'package:flutter/material.dart';

class Info extends StatelessWidget {
  final Widget Function(BuildContext context, DeviceInfo deviceInfo) builder;

  const Info({@required this.builder});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, constraints) {
      var mediaQueryData = MediaQuery.of(context);
      var deviceInfo = DeviceInfo(
        orientation: mediaQueryData.orientation,
        deviceType: getDeviceType(mediaQueryData),
        screenHeight: mediaQueryData.size.height,
        screenWidth: mediaQueryData.size.width,
        parentHeight: constraints.maxHeight,
        parentWidth: constraints.maxWidth,
      );
      return builder(context, deviceInfo);
    });
  }
}

DeviceType getDeviceType(MediaQueryData mediaQueryData) {
  double width = mediaQueryData.size.width;
  if (mediaQueryData.orientation == Orientation.landscape) {
    width = mediaQueryData.size.height;
  } else {
    width = mediaQueryData.size.width;
  }
  if (width > 0 && width <= 479) {
    return DeviceType.Mobile;
  } else if (width > 479 && width <= 767) {
    return DeviceType.MediumTablet;
  } else if (width > 767 && width <= 991) {
    return DeviceType.LargeTablet;
  } else {
    return DeviceType.Desktop;
  }
}
