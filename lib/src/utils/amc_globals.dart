
import 'package:amc_flutter_kit/amc_flutter_kit.dart';
import 'package:network_inspector/network_inspector.dart';

class RKGlobals {
  RKGlobals._();

  static late final bool isDevMode;
  static late final String appStoreID;

  static init(bool isDevMode) {
    RKGlobals.isDevMode = isDevMode;
    if (isDevMode && AppClient.isMobile) {
      NetworkInspector.initialize();
    }
  }
}
