import 'package:bloc_architecture/core/api/exceptions/app_exception.dart';
import 'package:bloc_architecture/core/api/exceptions/dio_exception_utils.dart';
import 'package:bloc_architecture/values/app_constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class CustomInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // AES encryption commented out — reqres.in uses plain JSON
    // options.headers['content-type'] = 'text/plain';
    // options.headers['contentType'] = 'text/plain';
    // options.headers['responseType'] = 'text/plain';
    // options.responseType = ResponseType.plain;
    // final enc = locator.get<EncService>();
    // options.headers.putIfAbsent("api-key", () => enc.encrypt(appDB.apiKey));
    // if (appDB.token.isNotEmpty) {
    //   options.headers['token'] = enc.encrypt(appDB.token);
    // }
    // if (options.data != null) {
    //   options.data = enc.encrypt(jsonEncode(options.data));
    // }

    options.headers.putIfAbsent('accept-language', () => 'en');
    options.headers.putIfAbsent('content-type', () => 'application/json');
    options.headers.putIfAbsent('x-api-key', () => AppConstants.reqresApiKey);

    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    // AES decryption commented out — reqres.in returns plain JSON
    // final enc = locator.get<EncService>();
    // response.data = jsonDecode(enc.decrypt(response.data.toString()));

    if (kDebugMode) {
      debugPrint(
        'RESPONSE [${response.statusCode}]: ${response.requestOptions.path}',
      );
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    try {
      DioExceptionUtil.handleError(err);
    } on AppException catch (e) {
      debugPrint('DioException: ${err.response?.data}');
      debugPrint('AppException: ${e.message}');
      throw AppException(e.message);
    }
    handler.next(err);
  }
}
