import 'dart:async';

import 'package:bloc_architecture/core/api/api_endpoints.dart';
import 'package:bloc_architecture/core/api/interceptors/custom_interceptors.dart';
import 'package:bloc_architecture/core/api/interceptors/http_logger_interceptor.dart';
import 'package:bloc_architecture/core/api/interceptors/internet_interceptor.dart';
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
        baseUrl: APIEndPoints.baseUrl,
        validateStatus: (status) {
          if (status == null) return true;
          if (status == 401) return false;
          return true;
        },
        // reqres.in is standard JSON — no custom responseType needed
        contentType: 'application/json',
        responseType: ResponseType.json,
      );

    if (kDebugMode) {
      dio.interceptors.add(HttpLoggerInterceptor());
    }
    dio.interceptors.add(CustomInterceptors());
    dio.interceptors.add(InternetInterceptors());

    return dio;
  }
}
