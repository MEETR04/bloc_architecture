import 'dart:io';

import 'package:dio/dio.dart';

import 'app_exception.dart';

/// Helper utility to safely convert [DioException] instances into typed [AppException] domain errors
/// with automatic message extraction from JSON payloads.
class DioExceptionUtil {
  DioExceptionUtil._();

  /// Converts a [DioException] into a domain [AppException] with extracted server message.
  static AppException parseError(DioException error) {
    final serverMessage = _extractServerMessage(error.response?.data);

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return ConnectionException(
          serverMessage ??
              'Connection to server failed. Please check your network.',
        );

      case DioExceptionType.cancel:
        return RequestCanceledException(
          serverMessage ?? 'Request was cancelled.',
        );

      case DioExceptionType.badCertificate:
        return ConnectionException('SSL certificate verification failed.');

      case DioExceptionType.transformTimeout:
        return ServerSideException('Data transformation timed out.');

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode ?? 500;
        return _mapStatusCodeToException(statusCode, serverMessage);

      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          return NoInternetException('No internet connection available.');
        }
        return AppException(
          serverMessage ??
              error.message ??
              'An unexpected network error occurred.',
        );
    }
  }

  /// Backward-compatible alias for existing call sites.
  static String handleError(DioException error) {
    final exception = parseError(error);
    throw exception;
  }

  /// Maps HTTP status codes to specific [AppException] subtypes.
  static AppException _mapStatusCodeToException(
    int statusCode,
    String? serverMessage,
  ) {
    if (statusCode == 401 || statusCode == 403) {
      return UnauthorisedException(
        serverMessage ?? 'Unauthorized access. Please login again.',
      );
    } else if (statusCode == 404) {
      return NotFoundException(
        serverMessage ?? 'Requested resource was not found.',
      );
    } else if (statusCode == 409) {
      return ConflictException(serverMessage ?? 'Resource conflict detected.');
    } else if (statusCode >= 400 && statusCode < 500) {
      return BadRequestException(
        serverMessage ?? 'Bad request. Please verify your inputs.',
      );
    } else if (statusCode >= 500) {
      return ServerSideException(
        serverMessage ?? 'Internal server error. Please try again later.',
      );
    } else {
      return AppException(
        serverMessage ?? 'Unexpected response code: $statusCode',
      );
    }
  }

  /// Safely extracts error description from various backend response formats:
  /// - `{ "error": "User not found" }`
  /// - `{ "message": "Validation failed" }`
  /// - `{ "errors": ["Email is invalid"] }`
  /// - `{ "detail": "Token expired" }`
  static String? _extractServerMessage(dynamic data) {
    if (data == null) return null;
    if (data is String && data.trim().isNotEmpty) {
      return data.trim();
    }
    if (data is Map) {
      if (data['error'] != null) {
        final err = data['error'];
        if (err is String) return err;
        if (err is Map && err['message'] != null) {
          return err['message'].toString();
        }
      }
      if (data['message'] != null) {
        final msg = data['message'];
        if (msg is String) return msg;
        if (msg is List && msg.isNotEmpty) return msg.join(', ');
      }
      if (data['detail'] != null) return data['detail'].toString();
      if (data['msg'] != null) return data['msg'].toString();
      if (data['errors'] != null) {
        final errors = data['errors'];
        if (errors is List && errors.isNotEmpty) return errors.join(', ');
        if (errors is Map) {
          final values = errors.values
              .expand((e) => e is List ? e : [e])
              .join(', ');
          if (values.isNotEmpty) return values;
        }
      }
    }
    return null;
  }
}
