import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

class AuthInterceptor extends Interceptor {
  final SharedPreferences? sharedPreferences;
  final String? token;
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 50,
      colors: true,
      printEmojis: true,
    ),
  );

  /// Create an AuthInterceptor with either a direct token or SharedPreferences
  /// If both are provided, the direct token takes precedence
  AuthInterceptor({
    this.sharedPreferences,
    this.token,
  }) : assert(token != null || sharedPreferences != null, 
           'Either token or sharedPreferences must be provided');

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      String? authToken = token;
      
      // If no direct token, try to get it from SharedPreferences
      if (authToken == null && sharedPreferences != null) {
        // Log all available keys in SharedPreferences for debugging
        final keys = sharedPreferences!.getKeys();
        _logger.d('SharedPreferences keys: $keys');
        
        // Try multiple possible token keys
        authToken = sharedPreferences!.getString('access_token') ??
                   sharedPreferences!.getString('token') ??
                   sharedPreferences!.getString('auth_token');
      }
      
      _logger.d('Auth token present: ${authToken != null}');
      if (authToken != null) {
        _logger.d('Token starts with: ${authToken.substring(0, 4)}...');
        _logger.d('Token ends with: ...${authToken.substring(authToken.length - 4)}');
        
        // Make sure to set the header with 'Bearer ' prefix
        options.headers['Authorization'] = 'Bearer $authToken';
        _logger.d('Set Authorization header with Bearer token');
      } else {
        _logger.w('No auth token found in interceptor');
      }

      // Ensure JSON by default
      options.headers['Accept'] = 'application/json';
      
      if (options.method == 'POST' || options.method == 'PUT' || options.method == 'PATCH') {
        options.headers['Content-Type'] = 'application/json';
      }
      
      _logger.d('Sending ${options.method} request to ${options.uri}');
      _logger.d('Headers: ${options.headers}');
      
    } catch (e, stackTrace) {
      _logger.e('Error in AuthInterceptor', error: e, stackTrace: stackTrace);
    }
    
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.e('Dio Error:', error: err);
    _logger.e('Response data: ${err.response?.data}');
    _logger.e('Response headers: ${err.response?.headers}');
    
    // If unauthorized, clear the token and redirect to login
    if (err.response?.statusCode == 401) {
      _logger.w('401 Unauthorized - Clearing auth token');
      if (sharedPreferences != null) {
        sharedPreferences!.remove('access_token');
        sharedPreferences!.remove('token');
        sharedPreferences!.remove('auth_token');
      }
      
      // TODO: Add navigation to login screen
      // You'll need to handle this based on your app's navigation system
    }
    
    handler.next(err);
  }
}
