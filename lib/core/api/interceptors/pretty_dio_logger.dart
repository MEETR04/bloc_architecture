/*
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class PrettyDioLogger extends Interceptor {
  static const String _topLeftCorner = '┌';
  static const String _bottomLeftCorner = '└';
  static const String _middleCorner = '├';
  static const String _verticalLine = '│';
  static const String _doubleDivider = '─';
  static const String _singleDivider = '┄';
  static const String _heavyDivider = '━';
  final bool request;
  final bool requestHeader;
  final bool requestBody;
  final bool responseHeader;
  final bool responseBody;
  final bool error;
  final bool compact;
  final int maxWidth;

  PrettyDioLogger({
    this.request = true,
    this.requestHeader = true,
    this.requestBody = true,
    this.responseHeader = false,
    this.responseBody = true,
    this.error = true,
    this.compact = true,
    this.maxWidth = 90,
  });

  // ANSI color codes for terminal
  String _bold(String text) => '\x1B[1m$text\x1B[0m';

  String _green(String text) => '\x1B[32m$text\x1B[0m';

  String _blue(String text) => '\x1B[34m$text\x1B[0m';

  String _red(String text) => '\x1B[31m$text\x1B[0m';

  String _yellow(String text) => '\x1B[33m$text\x1B[0m';

  String _cyan(String text) => '\x1B[36m$text\x1B[0m';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (request) {
      _printRequestHeader(options);
    }
    if (requestHeader) {
      _printMapAsTable(options.queryParameters, header: 'Query Parameters');
      final requestHeaders = <String, dynamic>{};
      requestHeaders.addAll(options.headers);
      requestHeaders['contentType'] = options.contentType?.toString();
      requestHeaders['responseType'] = options.responseType.toString();
      requestHeaders['followRedirects'] = options.followRedirects;
      requestHeaders['connectTimeout'] = options.connectTimeout?.toString();
      requestHeaders['receiveTimeout'] = options.receiveTimeout?.toString();
      _printMapAsTable(requestHeaders, header: 'Headers');
    }
    if (requestBody && options.method != 'GET') {
      final dynamic data = options.data;
      if (data != null) {
        if (data is Map) {
          _printMapAsTable(data, header: 'Body');
        } else if (data is FormData) {
          final formDataMap = <String, dynamic>{}
            ..addEntries(data.fields)
            ..addEntries(data.files);
          _printMapAsTable(formDataMap, header: 'Form Data');
        } else {
          _printBlock(data.toString());
        }
      }
    }
    _printLine();
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Only print the response header block if we intend to print either headers or body.
    if (responseHeader || responseBody) {
      _printResponseHeader(response);
    }

    if (responseHeader) {
      final responseHeaders = <String, String>{};
      response.headers.forEach(
        (key, list) => responseHeaders[key] = list.toString(),
      );
      _printMapAsTable(responseHeaders, header: 'Headers');
    }

    if (responseBody) {
      if (response.data != null) {
        _printResponse(response.data);
      }
    }

    // If neither header nor body was printed, don't print a trailing line.
    if (responseHeader || responseBody) {
      _printLine();
    }

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Only print the error header if the logger is configured to print errors.
    if (error) {
      _printErrorHeader(err);

      if (err.response != null) {
        if (err.response?.data != null) {
          // If responseBody is true, print decrypted/response body
          if (responseBody) {
            _printResponse(err.response!.data);
          } else {
            // If responseBody disabled but we still want error details, print status/message
            _printBlock(
              'Status: ${err.response?.statusCode ?? 'No Status'}; '
              'Message: ${err.response?.statusMessage ?? err.message}',
            );
          }
        } else {
          _printBlock(err.message ?? 'Unknown Error');
        }
      } else {
        _printBlock(err.message ?? 'Unknown Error');
      }

      _printLine();
    }

    super.onError(err, handler);
  }

  void _printResponse(dynamic data) {
    if (data is Map) {
      if (compact && data.length == 1) {
        debugPrint(
          '$_middleCorner ${_cyan(data.keys.first.toString())}: ${data.values.first}',
        );
      } else {
        _printPrettyMap(data);
      }
    } else if (data is List) {
      debugPrint('$_middleCorner [');
      _printList(data);
      debugPrint('$_middleCorner ]');
    } else {
      _printBlock(data.toString());
    }
  }

  void _printResponseHeader(Response response) {
    final uri = response.requestOptions.uri;
    final method = response.requestOptions.method;
    final statusCode = response.statusCode;
    final statusMessage = response.statusMessage ?? '';
    debugPrint('');
    debugPrint('$_topLeftCorner${'$_doubleDivider' * maxWidth}');
    debugPrint(
      '$_verticalLine ${_bold(_green('📥 RESPONSE'))} ${_bold('$statusCode')} $statusMessage',
    );
    debugPrint('$_middleCorner${'$_heavyDivider' * maxWidth}');
    debugPrint('$_middleCorner ${_bold(method)} ${_blue(uri.toString())}');
    debugPrint('$_middleCorner${'$_singleDivider' * (maxWidth - 1)}');
  }

  void _printRequestHeader(RequestOptions options) {
    final uri = options.uri;
    final method = options.method;
    debugPrint('');
    debugPrint('$_topLeftCorner${'$_doubleDivider' * maxWidth}');
    debugPrint('$_verticalLine ${_bold(_cyan('📤 REQUEST'))} ${_bold(method)}');
    debugPrint('$_middleCorner${'$_heavyDivider' * maxWidth}');
    debugPrint('$_middleCorner ${_blue(uri.toString())}');
    debugPrint('$_middleCorner${'$_singleDivider' * (maxWidth - 1)}');
  }

  void _printErrorHeader(DioException err) {
    final uri = err.requestOptions.uri;
    final method = err.requestOptions.method;
    final statusCode = err.response?.statusCode ?? 'No Status';
    final statusMessage = err.response?.statusMessage ?? '';
    final errorType = err.type.toString();
    debugPrint('');
    debugPrint('$_topLeftCorner${'$_doubleDivider' * maxWidth}');
    debugPrint(
      '$_verticalLine ${_bold(_red('⚠️ ERROR'))} ${_bold('$statusCode')} $statusMessage',
    );
    debugPrint('$_middleCorner${'$_heavyDivider' * maxWidth}');
    debugPrint('$_middleCorner ${_bold(method)} ${_blue(uri.toString())}');
    debugPrint('$_middleCorner ${_yellow('Type:')} $errorType');
    debugPrint('$_middleCorner${'$_singleDivider' * (maxWidth - 1)}');
  }

  void _printLine([String pre = '', String suf = '╝']) =>
      debugPrint('$pre$_bottomLeftCorner${'$_doubleDivider' * maxWidth}$suf');

  void _printBlock(String msg) {
    final lines = msg.split('\n');
    for (var line in lines) {
      debugPrint('$_middleCorner $line');
    }
  }

  void _printMapAsTable(Map? map, {String? header}) {
    if (map == null || map.isEmpty) return;
    if (header != null) {
      debugPrint('$_middleCorner ${_bold(_cyan(header))}');
    }
    map.forEach((key, value) => _printKV(key.toString(), value));
  }

  void _printPrettyMap(
    Map data, {
    String indent = '',
    bool isListItem = false,
  }) {
    var isFirst = true;
    data.forEach((key, value) {
      if (value is Map) {
        if (compact && value.isEmpty) {
          debugPrint('$_middleCorner $indent${_cyan(key.toString())}: {}');
        } else {
          debugPrint('$_middleCorner $indent${_cyan(key.toString())}: {');
          _printPrettyMap(value, indent: '$indent ');
          debugPrint('$_middleCorner $indent}');
        }
      } else if (value is List) {
        if (compact && value.isEmpty) {
          debugPrint('$_middleCorner $indent${_cyan(key.toString())}: []');
        } else if (compact && value.length == 1) {
          debugPrint(
            '$_middleCorner $indent${_cyan(key.toString())}: [${value[0]}]',
          );
        } else {
          debugPrint('$_middleCorner $indent${_cyan(key.toString())}: [');
          _printList(value, indent: '$indent ');
          debugPrint('$_middleCorner $indent]');
        }
      } else {
        _printKV(key, value, indent: indent);
      }
      isFirst = false;
    });
  }

  void _printList(List list, {String indent = ''}) {
    for (var i = 0; i < list.length; i++) {
      final value = list[i];
      if (value is Map) {
        if (compact && value.isEmpty) {
          debugPrint('$_middleCorner $indent{}');
        } else {
          debugPrint('$_middleCorner $indent{');
          _printPrettyMap(value, indent: '$indent ');
          debugPrint('$_middleCorner $indent}');
        }
      } else if (value is List) {
        debugPrint('$_middleCorner $indent[');
        _printList(value, indent: '$indent ');
        debugPrint('$_middleCorner $indent]');
      } else {
        debugPrint('$_middleCorner $indent$value');
      }
    }
  }

  void _printKV(String key, Object? v, {String indent = ''}) {
    final pre = '$_middleCorner $indent';
    final msg = v.toString();
    if (msg.length > maxWidth) {
      debugPrint('$pre ${_cyan(key)}:');
      _printBlock(msg);
    } else {
      debugPrint('$pre ${_cyan(key)}: $msg');
    }
  }
}
*/
