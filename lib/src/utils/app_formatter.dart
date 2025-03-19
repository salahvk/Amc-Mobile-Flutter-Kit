import 'dart:convert';

class AppFormatter {
  static final AppFormatter _instance = AppFormatter._();

  AppFormatter._();

  factory AppFormatter() {
    return _instance;
  }

  String prettyJson(dynamic json, {int indent = 2}) {
    final String spaces = ' ' * indent;
    final JsonEncoder encoder = JsonEncoder.withIndent(spaces);
    return encoder.convert(json);
  }
}
