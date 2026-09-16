import 'package:flutter/foundation.dart';

/// Defines base URLs for each deployment environment.
class _EnvUrls {
  const _EnvUrls({required this.staging, required this.prod});

  final String staging;
  final String prod;
}

/// Resolves and exposes the active base URL based on the current [AppEnv].
///
/// Selection order:
///   1. Explicit [AppEnvironmentConfig.override] (highest priority)
///   2. [kReleaseMode] → prod
///   3. debug / profile → staging
///   4. Fallback → prod (if nothing resolves)
class AppEnvironmentConfig {
  AppEnvironmentConfig._();

  static const _urls = _EnvUrls(
    staging: 'https://staging.reqres.in/api',
    prod: 'https://reqres.in/api',
  );

  /// Optional manual override. Set before [resolve] is called (e.g. in main).
  static AppEnv? override;

  static late AppEnv _resolved;

  /// Must be called once at startup (before [baseUrl] is accessed).
  static void resolve() {
    if (override != null) {
      _resolved = override!;
      return;
    }
    _resolved = kReleaseMode ? AppEnv.prod : AppEnv.staging;
  }

  /// The active environment after [resolve] has been called.
  static AppEnv get activeEnv => _resolved;

  /// The base URL for the active environment.
  static String get baseUrl {
    switch (_resolved) {
      case AppEnv.staging:
        return _urls.staging;
      case AppEnv.prod:
        return _urls.prod;
    }
  }
}

/// Supported deployment environments.
enum AppEnv { staging, prod }

/// API path constants — environment-agnostic.
class APIEndPoints {
  APIEndPoints._();

  static const login = '/login';
  static const register = '/register';
  static const getUsers = '/users';
}
