import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../constants/app_constants.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${AppConstants.apiKey}',
        },
      ),
    );
    _dio.interceptors.add(_LogInterceptor());
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParams}) {
    return _dio.get(path, queryParameters: queryParams);
  }
}

class _LogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('═══════════════════════════════════════════');
    debugPrint('🌐 API REQUEST: ${options.method} ${options.uri}');
    debugPrint('📋 HEADERS: ${options.headers}');
    if (options.queryParameters.isNotEmpty) {
      debugPrint('🔍 QUERY: ${options.queryParameters}');
    }
    debugPrint('═══════════════════════════════════════════');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('═══════════════════════════════════════════');
    debugPrint('✅ API RESPONSE: ${response.statusCode} ${response.requestOptions.uri}');
    final data = response.data;
    if (data is List) {
      debugPrint('📦 Data: List of ${data.length} items');
      if (data.isNotEmpty) {
        final first = data.first;
        debugPrint('📄 First item sample: $first');
      }
    } else {
      debugPrint('📄 Body: $data');
    }
    debugPrint('═══════════════════════════════════════════');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint('═══════════════════════════════════════════');
    debugPrint('❌ API ERROR: ${err.response?.statusCode} ${err.requestOptions.uri}');
    debugPrint('❌ Type: ${err.type}');
    debugPrint('❌ Message: ${err.message}');
    if (err.response != null) {
      debugPrint('❌ Response body: ${err.response?.data}');
    }
    debugPrint('❌ Stack: ${err.stackTrace}');
    debugPrint('═══════════════════════════════════════════');
    handler.next(err);
  }
}
