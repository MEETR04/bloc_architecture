// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'app_exception.dart';

class DioExceptionUtil {
  // general methods:------------------------------------------------------------
  static String handleError(DioException error) {
    String errorDescription = 'Unknown Error';

    debugPrint(error.toString());
    switch (error.type) {
      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          throw ConnectionException(
            'Connection to Server failed due to internet connection',
          );
        } else if (error.response!.statusCode == -9) {
          throw NoInternetException('No Internet Connection');
        } else {
          throw InvalidInputException('Something went wrong');
        }

      case DioExceptionType.cancel:
        errorDescription = 'Request to API server was cancelled';
        break;
      case DioExceptionType.connectionTimeout:
        throw RequestCanceledException('Connection timeout with API server');

      case DioExceptionType.receiveTimeout:
        throw ServerSideException(
          'Receive timeout in connection with API server',
        );

      case DioExceptionType.badResponse:
        debugPrint('Response:');
        debugPrint(error.toString());
        if (error.response!.statusCode == 12039 ||
            error.response!.statusCode == 12040) {
          throw ConnectionException(
            'Connection to Server failed due to internet connection',
          );
        } else if (401 == error.response!.statusCode) {
          /* locator.get<AppDB>().logout();
          locator<AppRouter>().replaceAll([const LoginRoute()]);*/
          throw UnauthorisedException('Please login again');
        } else if (401 < error.response!.statusCode! &&
            error.response!.statusCode! <= 417) {
          throw BadRequestException('Something went wrong');
        } else if (500 <= error.response!.statusCode! &&
            error.response!.statusCode! <= 505) {
          throw ServerSideException("Request can't be handled");
        } else {
          throw InvalidInputException('Something went wrong');
        }

      case DioExceptionType.sendTimeout:
        throw ServerSideException('Request to API server timed out');
      case DioExceptionType.badCertificate:
        throw ServerSideException('Request to API server timed out');
      case DioExceptionType.connectionError:
        throw RequestCanceledException(
          'Connection to API server failed due to internet connection',
        );
    }

    return errorDescription;
  }
}
