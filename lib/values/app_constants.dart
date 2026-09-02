import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract final class AppConstants {
  // Encryption
  static final String aesKey = dotenv.env['BACKEND_AES_KEY'] ?? '';

  // Sign-up defaults
  static const String defaultBusinessName = 'AGRO';
  static const String defaultOtp = '1234';
  static const String defaultLoginType = 'A';
  static const String defaultUserType = 'Parent';
  static const String reqresApiKey = 'free_user_3EL7qD1vk5SKSKhg1oaoxFkSv5A';

  // Sorting Options
  static const String sortAZ = 'A → Z';
  static const String sortZA = 'Z → A';
  static const List<String> sortOptions = [sortAZ, sortZA];

  // Media Extensions
  static const List<String> imageExtensions = [
    '.jpg',
    '.jpeg',
    '.png',
    '.gif',
    '.bmp',
  ];
  static const List<String> videoExtensions = [
    '.mp4',
    '.mkv',
    '.avi',
    '.mov',
    '.webm',
  ];
  static const List<String> docExtensions = [
    '.pdf',
    '.doc',
    '.docx',
    '.xls',
    '.xlsx',
    '.txt',
  ];
}

enum SelectionType { single, multiple }

enum PickedFileType { image, video, file }

enum SourceType { camera, gallery }
