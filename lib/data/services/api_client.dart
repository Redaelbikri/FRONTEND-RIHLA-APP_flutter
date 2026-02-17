import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../core/config/api_config.dart';

class ApiException implements Exception {
  final int? statusCode;
  final String message;
  final dynamic data;

  ApiException({required this.message, this.statusCode, this.data});

  @override
  String toString() => 'ApiException($statusCode): $message';
}

typedef OnUnauthorized = Future<void> Function();

class ApiClient {
  ApiClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: const Duration(seconds: 12),
        receiveTimeout: const Duration(seconds: 12),
        sendTimeout: const Duration(seconds: 12),
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: ApiConfig.tokenKey);
          if (token != null && token.trim().isNotEmpty) {
            options.headers['Authorization'] = 'Bearer ${token.trim()}';
          }
          handler.next(options);
        },
        onError: (e, handler) async {
          final status = e.response?.statusCode;
          if (status == 401 && _onUnauthorized != null) {
            await _onUnauthorized!.call();
          }
          handler.next(e);
        },
      ),
    );

    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
        compact: true,
      ),
    );

    dio.interceptors.add(_GetRetryInterceptor(dio));
  }

  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  late final Dio dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  OnUnauthorized? _onUnauthorized;

  void setUnauthorizedHandler(OnUnauthorized handler) {
    _onUnauthorized = handler;
  }

  ApiException mapDioError(DioException e) {
    final status = e.response?.statusCode;
    final data = e.response?.data;

    String msg = 'Network error';

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      msg = 'Request timeout';
    } else if (e.error is SocketException) {
      msg = 'No internet connection';
    } else if (status != null) {
      // Try parse typical backend structures
      msg = 'HTTP $status';

      if (data is Map) {
        if (data['message'] != null) msg = data['message'].toString();
        if (data['error'] != null) msg = data['error'].toString();
      } else if (data is String && data.trim().isNotEmpty) {
        msg = data.trim();
      }
    } else if (e.message != null && e.message!.trim().isNotEmpty) {
      msg = e.message!.trim();
    }

    return ApiException(statusCode: status, message: msg, data: data);
  }
}

/// Retries only idempotent GET requests
class _GetRetryInterceptor extends Interceptor {
  final Dio _dio;
  _GetRetryInterceptor(this._dio);

  static const int _maxRetries = 2;

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    final req = err.requestOptions;

    final isGet = req.method.toUpperCase() == 'GET';
    final canRetry = isGet && _shouldRetry(err);
    final retries = (req.extra['retries'] as int?) ?? 0;

    if (canRetry && retries < _maxRetries) {
      req.extra['retries'] = retries + 1;

      await Future.delayed(Duration(milliseconds: 350 * (retries + 1)));

      try {
        final res = await _dio.fetch(req);
        return handler.resolve(res);
      } catch (_) {
        return handler.next(err);
      }
    }

    return handler.next(err);
  }

  bool _shouldRetry(DioException e) {
    return e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.error is SocketException;
  }
}
