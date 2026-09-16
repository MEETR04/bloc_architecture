import 'package:bloc_architecture/core/api/api_endpoints.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Supported application running environments.
/// Kept for legacy compatibility — prefer [AppEnv] for new code.
enum Environment { dev, staging, prod }

/// Typed application environment and configuration manager.
/// Loads and validates configuration parameters from `.env` with safe fallbacks.
class AppConfig {
  AppConfig._();

  static late final Environment environment;
  static late final String baseUrl;
  static late final String apiKey;
  static late final Duration connectTimeout;
  static late final Duration receiveTimeout;
  static late final bool enableHttpLogging;

  /// Initializes the application configuration.
  ///
  /// [envOverride] pins the active [AppEnv] regardless of build mode.
  /// When null, [AppEnvironmentConfig] auto-selects: staging in debug,
  /// prod in release.
  static void init({AppEnv? envOverride}) {
    // Resolve the deployment environment.
    AppEnvironmentConfig.override = envOverride;
    AppEnvironmentConfig.resolve();

    // Map AppEnv → legacy Environment enum.
    environment = switch (AppEnvironmentConfig.activeEnv) {
      AppEnv.staging => Environment.staging,
      AppEnv.prod => Environment.prod,
    };

    // Base URL comes from the env config, not dotenv.
    baseUrl = AppEnvironmentConfig.baseUrl;

    apiKey = dotenv.env['API_KEY'] ?? '';
    connectTimeout = Duration(
      milliseconds:
          int.tryParse(dotenv.env['CONNECT_TIMEOUT_MS'] ?? '') ?? 30000,
    );
    receiveTimeout = Duration(
      milliseconds:
          int.tryParse(dotenv.env['RECEIVE_TIMEOUT_MS'] ?? '') ?? 30000,
    );
    enableHttpLogging = dotenv.env['ENABLE_HTTP_LOGGING'] != 'false';
  }

  /// Returns true if currently running in production environment.
  static bool get isProduction => environment == Environment.prod;

  /// Returns true if currently running in staging environment.
  static bool get isStaging => environment == Environment.staging;

  /// Returns true if currently running in development environment.
  static bool get isDevelopment => environment == Environment.dev;
}
