import 'dart:io';

import 'package:dio/dio.dart';

class InternetInterceptors extends Interceptor {
  @override
  Future<dynamic> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final result = await InternetAddress.lookup('www.google.com');
      if (result.isEmpty || result.first.rawAddress.isEmpty) {
        return handler.reject(
          DioException(
            requestOptions: options,
            type: DioExceptionType.connectionError,
            error: 'No internet connection',
          ),
        );
      }
      return handler.next(options);
    } on SocketException {
      return handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
          error: 'No internet connection',
        ),
      );
    }
  }
}
