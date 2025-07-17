import 'package:dio/dio.dart';
import '../storage/app_storage.dart';
import 'api_client.dart';

class AppInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = AppStorage.instance.accessToken;
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    print('[🔐] Token attached: $token');
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      print('[⚠️] Token expired! Attempting to refresh...');

      final refreshToken = AppStorage.instance.refreshToken;

      if (refreshToken != null) {
        try {
          final dio = Dio();
          final response = await dio.post(
            'auth/refresh',
            data: {'refreshToken': refreshToken},
          );

          final newAccessToken = response.data['accessToken'];
          print('[✅] Token refreshed: $newAccessToken');

          await AppStorage.instance.saveAccessToken(newAccessToken);

          final options = err.requestOptions;
          options.headers['Authorization'] = 'Bearer $newAccessToken';

          final retryResponse = await ApiClient().dio.fetch(options);
          return handler.resolve(retryResponse);
        } catch (e) {
          print('[❌] Refresh token failed');
          return handler.reject(err);
        }
      } else {
        print('[🚫] No refresh token found.');
      }
    }

    return handler.next(err);
  }
}
