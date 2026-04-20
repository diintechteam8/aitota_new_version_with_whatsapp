import 'package:dio/dio.dart';
import '../utils/request_interceptor.dart';
import 'api_endpoints.dart';
import 'dio_role_interceptor.dart';
import 'logging_interceptor.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  late final Dio _dio;

  factory DioClient() {
    return _instance;
  }

  DioClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // Prefix relative paths with the active role's base URL per request
    _dio.interceptors.add(RoleAwareBaseUrlInterceptor());

    // Attach token, content-type, etc.
    _dio.interceptors.add(RequestInterceptor());

    // Logging interceptor for debugging
    _dio.interceptors.add(LoggingInterceptor());
  }

  Dio get dio => _dio; // <-- ✅ use this to access dio
}

