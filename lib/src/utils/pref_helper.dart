import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class PrefHelper {
  static PrefHelper? _instance;
  static late SharedPreferences _preferences;

  static Future<PrefHelper?> init({bool removePrefix = false}) async {
    if (_instance == null) {
      final prefHelperInitiated = PrefHelper._();
      if (removePrefix) {
        SharedPreferences.setPrefix('');
      }
      _preferences = await SharedPreferences.getInstance();
      _instance = prefHelperInitiated;
    }
    return _instance;
  }

  PrefHelper._();

  static Future<bool> setValue(String key, dynamic value) {
    if (value == null) {
      debugger(
        when: value == null,
        message: "$key is NULL - Don't pass/Handle it.",
      );
      return Future.value(false);
    }
    if (value is String) {
      return _preferences.setString(key, value);
    } else if (value is int) {
      return _preferences.setInt(key, value);
    } else if (value is double) {
      return _preferences.setDouble(key, value);
    } else if (value is bool) {
      return _preferences.setBool(key, value);
    } else if (value is List<String>) {
      return _preferences.setStringList(key, value);
    } else if (value is Map) {
      return _preferences.setString(key, jsonEncode(value));
    }
    throw "PrefHelper: setValue() - Not implemented yet for type ${value.runtimeType} ($key:$value)";
  }

  static List<String>? getStringList(String key) {
    return _preferences.getStringList(key);
  }

  static String? getString(String key) {
    return _preferences.getString(key);
  }

  static int? getInt(String key) {
    return _preferences.getInt(key);
  }

  static double? getDouble(String key) {
    return _preferences.getDouble(key);
  }

  static bool getBool(String key) {
    return _preferences.getBool(key) ?? false;
  }

  static Map? getMap(String key) {
    final String? decodedMap = _preferences.getString(key);
    if (decodedMap != null) {
      return jsonDecode(decodedMap);
    } else {
      return null;
    }
  }

  static bool containsKey(String key) {
    return _preferences.containsKey(key);
  }

  static Future reload() {
    return _preferences.reload();
  }

  static Future<bool> removeValue(String key) {
    return _preferences.remove(key);
  }

  static Future clearAll() {
    return _preferences.clear();
  }
}
