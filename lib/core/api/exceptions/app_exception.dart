class AppException implements Exception {
  AppException([this.message, this.prefix = '']);
  final String? message;
  final String? prefix;

  @override
  String toString() => prefix != null && prefix!.isNotEmpty
      ? (message != null && message!.isNotEmpty ? '$prefix: $message' : prefix!)
      : (message ?? 'Unknown error occurred');
}

class FetchDataException extends AppException {
  FetchDataException([String? message])
    : super(message ?? 'Error during Communication', 'Communication Error');
}

class BadRequestException extends AppException {
  BadRequestException([String? message])
    : super(message ?? 'Invalid Request', 'Bad Request');
}

class UnauthorisedException extends AppException {
  UnauthorisedException([String? message])
    : super(message ?? 'Please login again', 'Unauthorized');
}

class NotFoundException extends AppException {
  NotFoundException([String? message])
    : super(message ?? 'Resource not found', 'Not Found');
}

class ConflictException extends AppException {
  ConflictException([String? message])
    : super(message ?? 'Resource conflict occurred', 'Conflict');
}

class InvalidInputException extends AppException {
  InvalidInputException([String? message])
    : super(message ?? 'Invalid Input', 'Invalid Input');
}

class RequestCanceledException extends AppException {
  RequestCanceledException([String? message])
    : super(message ?? 'Request was cancelled', 'Cancelled');
}

class ServerSideException extends AppException {
  ServerSideException([String? message])
    : super(message ?? "Server couldn't process request", 'Server Error');
}

class ConnectionException extends AppException {
  ConnectionException([String? message])
    : super(message ?? 'Connection to server failed', 'Connection Error');
}

class NoInternetException extends AppException {
  NoInternetException([String? message])
    : super(message ?? 'No internet connection', 'No Internet');
}
