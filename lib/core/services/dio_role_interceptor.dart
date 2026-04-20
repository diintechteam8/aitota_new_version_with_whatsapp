import 'package:dio/dio.dart';

import 'app_config.dart';

/// Interceptor that prefixes relative paths with the current role's base URL
/// and switches dynamically when the role changes via AppConfig.
class RoleAwareBaseUrlInterceptor extends Interceptor {
  final AppConfig _config = AppConfig.instance;

  bool _isAbsolute(String url) {
    return url.startsWith('http://') || url.startsWith('https://');
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final currentBase = _config.baseUrl;

    if (!_isAbsolute(options.path)) {
      // If path is relative, prefix with the active base URL
      options.baseUrl = currentBase;
    } else {
      // If path is absolute, clear the baseUrl to prevent joining
      options.baseUrl = "";
    }

    super.onRequest(options, handler);
  }
}


