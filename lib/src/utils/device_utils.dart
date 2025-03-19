import 'dart:math';

import 'package:amc_flutter_kit/amc_flutter_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class DeviceUtils {
  static late MediaQueryData _mediaQueryData;
  static get size => _mediaQueryData.size;
  static bool get isPhone => size.shortestSide < 600;
  static double get deviceHeight => size.height;
  static double get deviceWidth => isPhone ? size.width : min(500, size.width);

  static bool get hasIphoneBottomNotch =>
      AppClient.isIOS && _mediaQueryData.viewPadding.bottom > 0;
  static double get statusBarHeight => _mediaQueryData.padding.top;
  static double get navBarHeight => _mediaQueryData.padding.bottom;

  DeviceUtils(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
  }

  static Future hideKeyboard() {
    return SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  static void removeFocus() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  static void reFocus(FocusNode focusNode) {
    removeFocus();
    Future.delayed(const Duration(milliseconds: 50), () {
      focusNode.requestFocus();
    });
  }
}
