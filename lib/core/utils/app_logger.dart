import 'package:bloc_architecture/core/locator/locator.dart';
import 'package:bloc_architecture/core/utils/crash_reporter.dart';
import 'package:flutter/foundation.dart';

/// Centralized application logger providing structured log levels and crash reporting integration.
class AppLogger {
  AppLogger._();

  /// Logs debug-level message in debug mode.
  static void d(String message, {String? tag}) {
    if (kDebugMode) {
      debugPrint('🔍 [DEBUG]${tag != null ? ' [$tag]' : ''} $message');
    }
  }

  /// Logs info-level message in debug mode.
  static void i(String message, {String? tag}) {
    if (kDebugMode) {
      debugPrint('ℹ️ [INFO]${tag != null ? ' [$tag]' : ''} $message');
    }
  }

  /// Logs warning-level message.
  static void w(String message, {String? tag, Object? error}) {
    if (kDebugMode) {
      debugPrint(
        '⚠️ [WARN]${tag != null ? ' [$tag]' : ''} $message ${error != null ? '| $error' : ''}',
      );
    }
  }

  /// Logs error-level message and forwards to the registered [ICrashReporter].
  static void e(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
    bool fatal = false,
  }) {
    if (kDebugMode) {
      debugPrint(
        '❌ [ERROR]${tag != null ? ' [$tag]' : ''} $message ${error != null ? '| $error' : ''}',
      );
      if (stackTrace != null) debugPrint('StackTrace: $stackTrace');
    }

    if (error != null && locator.isRegistered<ICrashReporter>()) {
      locator<ICrashReporter>().recordError(
        error,
        stackTrace,
        reason: message,
        fatal: fatal,
      );
    }
  }
}
