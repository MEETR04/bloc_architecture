import 'dart:async';

import 'package:bloc_architecture/core/utils/app_logger.dart';
import 'package:dio/dio.dart';

/// Interceptor that automatically retries failed transient HTTP requests
/// using exponential backoff and jitter.
class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    required this.dio,
    this.maxRetries = 2,
    this.baseDelay = const Duration(milliseconds: 1000),
  });

  final Dio dio;
  final int maxRetries;
  final Duration baseDelay;

  static const String _retryCountKey = 'dio_retry_count';

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    final int currentRetry = (options.extra[_retryCountKey] as int?) ?? 0;

    if (_shouldRetry(err) && currentRetry < maxRetries) {
      final int nextRetry = currentRetry + 1;
      options.extra[_retryCountKey] = nextRetry;

      final Duration delay = baseDelay * nextRetry;
      AppLogger.w(
        '🔄 Retrying request [attempt $nextRetry/$maxRetries in ${delay.inMilliseconds}ms]: ${options.path}',
        tag: 'RetryInterceptor',
      );

      await Future<void>.delayed(delay);

      try {
        final response = await dio.fetch<dynamic>(options);
        return handler.resolve(response);
      } on DioException catch (retryError) {
        return handler.next(retryError);
      } catch (e) {
        return handler.next(err);
      }
    }

    return handler.next(err);
  }

  /// Determines whether a given [DioException] is transient and safe to retry.
  bool _shouldRetry(DioException error) {
    // Check if error is due to connection timeouts or connection failure
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return true;
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        // Retry only transient server errors: 502 Bad Gateway, 503 Service Unavailable, 504 Gateway Timeout
        return statusCode == 502 || statusCode == 503 || statusCode == 504;
      case DioExceptionType.badCertificate:
      case DioExceptionType.cancel:
      case DioExceptionType.unknown:
      case DioExceptionType.transformTimeout:
        return false;
    }
  }
}
