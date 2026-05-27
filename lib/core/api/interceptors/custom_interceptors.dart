import 'dart:convert';

import 'package:bloc_architecture/core/api/exceptions/app_exception.dart';
import 'package:bloc_architecture/core/api/exceptions/dio_exception_utils.dart';
import 'package:bloc_architecture/core/db/app_db.dart';
import 'package:bloc_architecture/core/locator/locator.dart';
import 'package:bloc_architecture/service/enc_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class CustomInterceptors extends Interceptor {
  @override
  Future<dynamic> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers['content-type'] = 'text/plain';
    options.headers['contentType'] = 'text/plain';
    options.headers['responseType'] = 'text/plain';
    options.responseType = ResponseType.plain;

    final appDB = locator.get<AppDB>();
    final enc = locator.get<EncService>();
    options.headers.putIfAbsent('api-key', () => enc.encrypt(appDB.apiKey));
    options.headers.putIfAbsent('accept-language', () => 'en');
    if (appDB.token.isNotEmpty) {
      options.headers['token'] = enc.encrypt(appDB.token);
    }
    if (options.data != null) {
      options.data = enc.encrypt(jsonEncode(options.data));
    }

    return handler.next(options);
  }

  @override
  Future<dynamic> onResponse(
    var response,
    ResponseInterceptorHandler handler,
  ) async {
    if (kDebugMode) debugPrint(' RESPONSE : ${response.data}');
    final enc = locator.get<EncService>();
    response.data = jsonDecode(enc.decrypt(response.data.toString()));

    return handler.next(response);
  }

  @override
  Future<dynamic> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    try {
      final enc = locator.get<EncService>();

      // Check if response data exists and looks encrypted
      if (err.response?.data != null && err.response?.data is String) {
        try {
          final decrypted = enc.decrypt(err.response!.data.toString());
          err.response!.data = jsonDecode(decrypted);
        } catch (_) {
          // If decryption fails, just leave it as-is (maybe plain text)
        }
      }

      DioExceptionUtil.handleError(err);
    } on AppException catch (e) {
      debugPrint('DioException Interceptor ${err.response?.data}');
      debugPrint('AppException Interceptor ${e.message}');
      throw AppException(e.message);
    }
    return handler.next(err);
  }
}
