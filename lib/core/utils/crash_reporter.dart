import 'package:flutter/foundation.dart';

/// Abstract interface for crash and error tracking services (e.g. Firebase Crashlytics, Sentry).
abstract interface class ICrashReporter {
  /// Records a non-fatal or fatal application error.
  void recordError(
    Object error,
    StackTrace? stackTrace, {
    String? reason,
    bool fatal = false,
  });

  /// Records an uncaught Flutter framework error.
  void recordFlutterError(FlutterErrorDetails details);

  /// Sets user identifier for crash report diagnostics.
  void setUserIdentifier(String identifier);
}

/// Default developer crash reporter logging diagnostics in debug mode.
/// Easily swappable with Firebase Crashlytics or Sentry in production.
class DefaultCrashReporter implements ICrashReporter {
  @override
  void recordError(
    Object error,
    StackTrace? stackTrace, {
    String? reason,
    bool fatal = false,
  }) {
    if (kDebugMode) {
      debugPrint(
        '🚨 [CRASH_REPORT] Error: $error | Reason: $reason | Fatal: $fatal',
      );
      if (stackTrace != null) debugPrint('StackTrace: $stackTrace');
    }
  }

  @override
  void recordFlutterError(FlutterErrorDetails details) {
    if (kDebugMode) {
      debugPrint('🚨 [FLUTTER_ERROR] ${details.exceptionAsString()}');
      if (details.stack != null) debugPrint('StackTrace: ${details.stack}');
    }
  }

  @override
  void setUserIdentifier(String identifier) {
    if (kDebugMode) {
      debugPrint('👤 [USER_ID] Set user identifier: $identifier');
    }
  }
}
