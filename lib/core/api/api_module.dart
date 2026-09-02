import 'dart:async';

import 'package:bloc_architecture/core/api/interceptors/custom_interceptors.dart';
import 'package:bloc_architecture/core/api/interceptors/http_logger_interceptor.dart';
import 'package:bloc_architecture/core/api/interceptors/internet_interceptor.dart';
import 'package:bloc_architecture/core/api/interceptors/retry_interceptor.dart';
import 'package:bloc_architecture/core/config/app_config.dart';
import 'package:bloc_architecture/core/locator/locator.dart';
import 'package:bloc_architecture/features/auth/data/datasource/auth_api.dart';
import 'package:bloc_architecture/features/home/data/datasource/home_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiModule {
  Future<void> provides() async {
    final dio = await setup();

    locator
      ..registerSingleton<Dio>(dio)
      ..registerSingleton<AuthApi>(AuthApi(dio))
      ..registerSingleton<HomeApi>(HomeApi(dio));
  }

  static FutureOr<Dio> setup() async {
    final Dio dio = Dio()
      ..options = BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: AppConfig.connectTimeout,
        receiveTimeout: AppConfig.receiveTimeout,
        validateStatus: (status) {
          if (status == null) return false;
          // Standard HTTP success range 200..299
          return status >= 200 && status < 300;
        },
        contentType: 'application/json',
        responseType: ResponseType.json,
      );

    if (kDebugMode && AppConfig.enableHttpLogging) {
      dio.interceptors.add(HttpLoggerInterceptor());
    }
    dio.interceptors.add(RetryInterceptor(dio: dio));
    dio.interceptors.add(CustomInterceptors());
    dio.interceptors.add(InternetInterceptors());

    return dio;
  }
}
