import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Supported application running environments.
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
  static void init({Environment env = Environment.dev}) {
    environment = env;
    baseUrl = dotenv.env['BASE_URL'] ?? 'https://reqres.in/api';
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
