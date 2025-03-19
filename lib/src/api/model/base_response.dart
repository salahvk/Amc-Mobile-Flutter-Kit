class BaseResponse {
  late bool success;
  Map<String, dynamic>? data;
  late String errorMessage;
  int? errorCode;
  String? userId;

  BaseResponse({
    this.success = false,
    this.data,
    this.errorMessage = "",
    this.errorCode,
  });

  BaseResponse.fromBaseJson(
    Map<String, dynamic> json,
  ) {
    success = json['success'] ?? false;
    data = json['data'];
    errorMessage = json['errorMessage'] ?? "";
    errorCode = json['errorCode'];
    userId = json['userId'];
  }

  BaseResponse.fromJson(
    Map<String, dynamic> json,
    Function(Map<String, dynamic>) create,
  ) {
    success = json['success'] ?? false;
    data = create(json['data']);
    errorMessage = json['errorMessage'] ?? "";
    errorCode = json['errorCode'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': data,
        'errorMessage': errorMessage,
        'errorCode': errorCode,
        'userId': userId,
      };
}
