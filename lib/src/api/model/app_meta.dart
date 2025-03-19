class AppMeta {
  final AppInfo appInfo;
  final DeviceInfo deviceInfo;

  AppMeta({
    required this.appInfo,
    required this.deviceInfo,
  });
}

class AppInfo {
  /// The package name. `bundleIdentifier` on iOS, `getPackageName` on Android.
  final String packageName;

  /// The package version. `CFBundleShortVersionString` on iOS, `versionName` on Android.
  final String version;

  /// The build number. `CFBundleVersion` on iOS, `versionCode` on Android.
  final int buildNumber;

  AppInfo({
    required this.packageName,
    required this.version,
    required this.buildNumber,
  });
}

class DeviceInfo {
  /// Current OS version
  /// 9, 10, 13.1
  final double? osVersion;

  /// The user-visible SDK version of the framework for Android
  /// Possible values are defined in: https://developer.android.com/reference/android/os/Build.VERSION_CODES.html
  ///  Eg. 28, 31, 32
  final int sdkInt;

  /// OS Name
  /// android, iOS, web
  final String os;

  DeviceInfo({
    required this.osVersion,
    required this.sdkInt,
    required this.os,
  });
}
