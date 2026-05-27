import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract final class AppConstants {
  // Encryption
  static final String aesKey = dotenv.env['BACKEND_AES_KEY'] ?? '';

  // Sign-up defaults
  static const String defaultBusinessName = 'AGRO';
  static const String defaultOtp = '1234';
  static const String defaultLoginType = 'A';
  static const String defaultUserType = 'Parent';
}
