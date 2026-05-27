class AppException implements Exception {
  AppException([this.message, this.prefix = '']);
  final String? message;
  final String? prefix;

  @override
  String toString() => '$message $prefix';
}

class FetchDataException extends AppException {
  FetchDataException(String message)
    : super(message, 'Error during Communication');
}

class BadRequestException extends AppException {
  BadRequestException([String? message]) : super(message, 'Invalid Request');
}

class UnauthorisedException extends AppException {
  UnauthorisedException([String? message]) : super(message, 'Unauthorised');
}

class InvalidInputException extends AppException {
  InvalidInputException([String? message]) : super(message, 'Invalid Input');
}

class RequestCanceledException extends AppException {
  RequestCanceledException([String? message])
    : super(message, 'Request Cancelled');
}

class ServerSideException extends AppException {
  ServerSideException([String? message])
    : super(message, 'Server Side Exception');
}

class ConnectionException extends AppException {
  ConnectionException([String? message]) : super(message, 'Connection Error');
}

class NoInternetException extends AppException {
  NoInternetException([String? message])
    : super(message, 'No Internet Connection');
}
