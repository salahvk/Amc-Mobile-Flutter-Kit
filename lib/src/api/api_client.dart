import 'dart:io';
import 'package:amc_flutter_kit/amc_flutter_kit.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:network_inspector/common/utils/dio_interceptor.dart';
import 'package:network_inspector/network_inspector.dart';

import 'api_logging_interceptor.dart';

class ApiClient {
  ApiClient._() {
    _addInterceptors(_dio);
  }
  factory ApiClient() {
    return _instance;
  }

  static final _instance = ApiClient._();

  static late final String _baseUrl;
  static late final String _tokenKey;
  static late final AppMeta _appMeta;
  static late final Function(String url, {int statusCode}) _onUnauthorized;
  static late final Map<String, dynamic> Function()? _additionalHeaders;
  static late final Interceptors? _interceptorsList;
  final List<CancelToken> _cancelTokenList = [];

  static void init({
    required String baseURL,
    required String tokenKey,
    required AppMeta appMeta,
    required Function(String url, {int statusCode}) onUnauthorized,
    Map<String, dynamic> Function()? additionalHeaders,
    Interceptors? interceptorsList,
  }) {
    _baseUrl = baseURL;
    _tokenKey = tokenKey;
    _appMeta = appMeta;
    _additionalHeaders = additionalHeaders;
    _onUnauthorized = onUnauthorized;
    _interceptorsList = interceptorsList;
  }

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 30),
    ),
  );

  void _addInterceptors(Dio dio) {
    dio.interceptors.addAll(
      [
        if (_interceptorsList != null) ..._interceptorsList!,
        if (kDebugMode) APILoggingInterceptor(),
        if (kDebugMode)
          DioInterceptor(
            logIsAllowed: false,
            networkInspector: NetworkInspector(),
          ),
      ],
    );
  }

  Future<BaseResponse> get(
    String url, {
    Map<String, dynamic>? queryParams,
    CancelToken? cancelToken,
    bool canShowErrorToast = false,
    int? receiveTimeoutInSec,
  }) =>
      _apiRequestCall(
        "GET",
        url,
        queryParams: queryParams,
        cancelToken: cancelToken,
        canShowErrorToast: canShowErrorToast,
        receiveTimeoutInSec: receiveTimeoutInSec,
      );

  Future<BaseResponse> post(
    String url, {
    dynamic body,
    CancelToken? cancelToken,
    bool canShowErrorToast = false,
    String? refreshToken,
  }) =>
      _apiRequestCall(
        "POST",
        url,
        body: body,
        cancelToken: cancelToken,
        canShowErrorToast: canShowErrorToast,
        refreshToken: refreshToken,
      );

  Future<BaseResponse> put(
    String url, {
    dynamic body,
    bool canShowErrorToast = false,
  }) =>
      _apiRequestCall(
        "PUT",
        url,
        body: body,
        canShowErrorToast: canShowErrorToast,
      );

  Future<BaseResponse> _apiRequestCall(
    String method,
    String url, {
    dynamic body,
    Map<String, dynamic>? queryParams,
    CancelToken? cancelToken,
    bool canShowErrorToast = false,
    int? receiveTimeoutInSec,
    String? refreshToken,
  }) async {
    final CancelToken newCancelToken = cancelToken ?? CancelToken();
    _cancelTokenList.add(newCancelToken);

    try {
      final Response networkResponse = await _dio.request(
        url,
        data: body,
        queryParameters: queryParams,
        options: Options(
          method: method,
          headers: getHeaders(),
          receiveTimeout: Duration(seconds: receiveTimeoutInSec ?? 30),
        ),
        cancelToken: newCancelToken,
      );
      _cancelTokenList.remove(newCancelToken);
      return _decodeSuccessResponse(networkResponse);
    } catch (e, st) {
      _cancelTokenList.remove(newCancelToken);
      throw _decodeErrorResponse(
        _parseError(e, st),
        canShowErrorToast: canShowErrorToast,
      );
    }
  }

  BaseResponse _decodeSuccessResponse(Response response) {
    final BaseResponse baseResponse = BaseResponse.fromBaseJson(response.data);
    if (!baseResponse.success && baseResponse.errorMessage.isNotEmpty) {
      throw ErrorResponseException(
        message: baseResponse.errorMessage,
        code: baseResponse.errorCode,
        data: baseResponse.data,
      );
    }
    return baseResponse;
  }

  dynamic _decodeErrorResponse(
    dynamic errorToThrow, {
    bool? canShowErrorToast,
  }) {
    if (errorToThrow is UnauthorizedException) {
      //Toast.warning(errorToThrow.message!);
    } else if (canShowErrorToast == true) {
      if (errorToThrow is APIException) {
        //Toast.error(errorToThrow.message ?? "Something went wrong.");
      } else {
       // Toast.error("Something went wrong.");
      }
    }
    return errorToThrow;
  }

  dynamic _parseError(
    dynamic clientError,
    StackTrace st,
  ) {
    if (clientError is DioException) {
      if (clientError.error is SocketException ||
          clientError.type == DioExceptionType.connectionTimeout) {
        return InternetException("No Internet Connection");
      } else if (clientError.type == DioExceptionType.badResponse) {
        final int statusCode = clientError.response?.statusCode ?? 0;

        if (statusCode == 401 || statusCode == 403) {
          _clearRequestsQueue();
          return _onUnauthorized(
            clientError.requestOptions.uri.toString(),
            statusCode: statusCode,
          );
        } else if (clientError.response?.data is Map) {
          final BaseResponse baseResponse =
              BaseResponse.fromBaseJson(clientError.response?.data);

          if (!baseResponse.success && baseResponse.errorMessage.isNotEmpty) {
            return ErrorResponseException(
              message: baseResponse.errorMessage,
              code: baseResponse.errorCode,
              data: baseResponse.data,
            );
          }
        }
      }
    }
    return clientError;
  }

  Map<String, dynamic> getHeaders() {
    return {
      "content-type": "application/json; charset=utf-8",
      "authorization": "Bearer $_tokenKey",
      "connection": "close",
      "x-client-app": _appMeta.deviceInfo.os,
      "x-client-version": _appMeta.appInfo.buildNumber.toString(),
      "x-client-sub-version": _appMeta.appInfo.version,
      "x-client-os-type": _appMeta.deviceInfo.os,
      "x-client-os-version": _appMeta.deviceInfo.sdkInt.toString(),
      "x-client-package": _appMeta.appInfo.packageName,
      ...?_additionalHeaders?.call(),
    };
  }

  void _clearRequestsQueue() {
    for (final CancelToken cancelToken in _cancelTokenList) {
      cancelToken.cancel();
    }
  }
}
