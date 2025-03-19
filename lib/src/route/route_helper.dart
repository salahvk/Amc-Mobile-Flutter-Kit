import 'package:flutter/material.dart';
import 'package:amc_flutter_kit/src/utils/device_utils.dart';

class RouteHelper {
  RouteHelper._();

  static late final GlobalKey<NavigatorState> _navigatorKey;

  static BuildContext get navigatorContext => _navigatorKey.currentContext!;

  static init(GlobalKey<NavigatorState> navigatorKey) {
    _navigatorKey = navigatorKey;
  }

  static Future push(String routeName, {Object? args}) {
    return Navigator.of(navigatorContext).pushNamed(
      routeName,
      arguments: args,
    );
  }

  static Future pushReplacement(String routeName, {Object? args}) {
    return Navigator.of(navigatorContext).pushReplacementNamed(
      routeName,
      arguments: args,
    );
  }

  static Future pushAndPopUntil(
    String routeName, {
    String? popUntilRouteName,
    Object? args,
  }) {
    return Navigator.of(navigatorContext).pushNamedAndRemoveUntil(
      routeName,
      popUntilRouteName != null
          ? ModalRoute.withName(popUntilRouteName)
          : (Route<dynamic> route) => false,
      arguments: args,
    );
  }

  static void pop({dynamic args}) {
    Navigator.of(navigatorContext).pop(args);
  }

  static bool canPop() {
    return Navigator.of(navigatorContext).canPop();
  }

  static Future<void> maybePop() {
    return Navigator.of(navigatorContext).maybePop();
  }

  static void popUntil(String routesName) {
    Navigator.of(navigatorContext).popUntil(ModalRoute.withName(routesName));
  }

  static Future<T?> openDialog<T>(
    Widget child, {
    bool isDismissible = true,
    Color barrierColor = Colors.black54,
  }) {
    return showDialog<T?>(
      context: navigatorContext,
      builder: (_) => child,
      barrierDismissible: isDismissible,
      barrierColor: barrierColor,
    );
  }

  static Future<T?> openModalSheet<T>(
    Widget child, {
    bool isDismissible = true,
    bool isScrollControlled = true,
    double? height,
    // Color barrierColor = Colors.white,
  }) {
    return showModalBottomSheet<T?>(
      context: navigatorContext,
      backgroundColor: const Color.fromRGBO(46, 46, 46, 0.2),
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: isDismissible,
      //barrierColor: barrierColor,
      elevation: 4,
      constraints:
          BoxConstraints(maxHeight: height ?? DeviceUtils.deviceHeight * 0.95),
      builder: (_) => isDismissible
          ? child
          : PopScope(
              canPop: false,
              child: child,
            ),
    );
  }

  static Future<T?> openBaseModalSheet<T>(
    Widget child,
  ) {
    return showModalBottomSheet<T?>(
      context: navigatorContext,
      isScrollControlled: true,
      //barrierColor: Colors.white,
      constraints: BoxConstraints(
        maxHeight:
            DeviceUtils.deviceHeight - (DeviceUtils.statusBarHeight + 10),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (_) => child,
    );
  }
}
