import 'package:bloc_architecture/core/api/exceptions/dio_exception_utils.dart';
import 'package:bloc_architecture/core/config/app_config.dart';
import 'package:bloc_architecture/core/utils/app_logger.dart';
import 'package:dio/dio.dart';

/// Common HTTP request and response interceptor for headers, logging, and error tracing.
class CustomInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers.putIfAbsent('accept-language', () => 'en');
    options.headers.putIfAbsent('content-type', () => 'application/json');
    if (AppConfig.apiKey.isNotEmpty) {
      options.headers.putIfAbsent('x-api-key', () => AppConfig.apiKey);
    }

    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    AppLogger.d(
      'RESPONSE [${response.statusCode}]: ${response.requestOptions.path}',
      tag: 'Dio',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final appException = DioExceptionUtil.parseError(err);
    AppLogger.w(
      'Dio error on ${err.requestOptions.path}: $appException',
      tag: 'Dio',
      error: err,
    );
    handler.next(err);
  }
}
