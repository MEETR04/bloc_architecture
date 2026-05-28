import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class HttpLogPrinter extends LogPrinter {
  @override
  List<String> log(LogEvent event) {
    final message = event.message;
    final level = event.level;

    String color;
    String resetColor = '\x1B[0m';

    if (Platform.isIOS) {
      color = '';
      resetColor = '';
    } else if (level == Level.info) {
      // Request -> Green
      color = '\x1B[32m';
    } else if (level == Level.warning) {
      // Response -> Cream
      color = '\x1B[38;5;230m';
    } else if (level == Level.error) {
      // Error -> Red
      color = '\x1B[31m';
    } else {
      color = '\x1B[0m';
    }

    final lines = message.toString().split('\n');
    return lines.map((line) => '$color$line$resetColor').toList();
  }
}

class _PrintOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    for (final line in event.lines) {
      // ignore: avoid_print
      print(line);
    }
  }
}

class HttpLoggerInterceptor extends Interceptor {
  HttpLoggerInterceptor()
    : _logger = Logger(
        printer: HttpLogPrinter(),
        filter: DevelopmentFilter(),
        output: _PrintOutput(),
      );
  final Logger _logger;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final buffer = StringBuffer()
      ..writeln('┌${'─' * 79}')
      ..writeln('│ 📤 REQUEST [${options.method}] ${options.uri}')
      ..writeln('├${'─' * 79}');

    if (options.headers.isNotEmpty) {
      buffer.writeln('│ Headers:');
      options.headers.forEach((key, value) {
        buffer.writeln('│   $key: $value');
      });
    }

    if (options.queryParameters.isNotEmpty) {
      buffer.writeln('│ Query Parameters:');
      options.queryParameters.forEach((key, value) {
        buffer.writeln('│   $key: $value');
      });
    }

    if (options.data != null) {
      buffer.writeln('│ Body:');
      final bodyStr = _formatBody(options.data);
      for (final line in bodyStr.split('\n')) {
        buffer.writeln('│   $line');
      }
    }
    buffer.write('└${'─' * 79}');

    // stamp start time so response/error can compute elapsed duration
    options.extra['_requestStartMs'] = DateTime.now().millisecondsSinceEpoch;

    _logger.i(buffer.toString());
    super.onRequest(options, handler);
  }

  @override
  void onResponse(var response, ResponseInterceptorHandler handler) {
    final startMs = response.requestOptions.extra['_requestStartMs'] as int?;
    final elapsed = startMs != null
        ? '${DateTime.now().millisecondsSinceEpoch - startMs}ms'
        : '?ms';

    final buffer = StringBuffer()
      ..writeln('┌${'─' * 79}')
      ..writeln(
        '│ 📥 RESPONSE [${response.statusCode} ${response.statusMessage ?? ''}]  ⏱ $elapsed  ${response.requestOptions.uri}',
      )
      ..writeln('├${'─' * 79}');

    if (response.data != null) {
      buffer.writeln('│ Body:');
      final bodyStr = _formatBody(response.data);
      for (final line in bodyStr.split('\n')) {
        buffer.writeln('│   $line');
      }
    }
    buffer.write('└${'─' * 79}');

    _logger.w(buffer.toString());
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final startMs = err.requestOptions.extra['_requestStartMs'] as int?;
    final elapsed = startMs != null
        ? '${DateTime.now().millisecondsSinceEpoch - startMs}ms'
        : '?ms';

    final buffer = StringBuffer()
      ..writeln('┌${'─' * 79}')
      ..writeln(
        '│ ⚠️ ERROR [${err.response?.statusCode ?? 'No Status'}]  ⏱ $elapsed  ${err.requestOptions.uri}',
      )
      ..writeln('├${'─' * 79}')
      ..writeln('│ Message: ${err.message}');
    if (err.response?.data != null) {
      buffer.writeln('│ Response Body:');
      final bodyStr = _formatBody(err.response!.data);
      for (final line in bodyStr.split('\n')) {
        buffer.writeln('│   $line');
      }
    }
    buffer.write('└${'─' * 79}');

    _logger.e(buffer.toString());
    super.onError(err, handler);
  }

  String _formatBody(dynamic data) {
    try {
      if (data is Map || data is List) {
        return const JsonEncoder.withIndent('  ').convert(data);
      } else if (data is String) {
        final decoded = jsonDecode(data);
        return const JsonEncoder.withIndent('  ').convert(decoded);
      }
    } catch (_) {}
    return data.toString();
  }
}
