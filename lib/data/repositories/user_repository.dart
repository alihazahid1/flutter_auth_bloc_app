import 'package:dio/dio.dart';
import 'package:bloc_login/presentation/bloc/bloc/auth_bloc.dart';

class UserRepository {
  final Dio dio;
  final AuthBloc authBloc;
  UserRepository({
    required String accessToken,
    required String refreshToken,
    required this.authBloc,
  }) : dio = Dio() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add the current access token to every request
          options.headers['Authorization'] = 'Bearer $accessToken';
          return handler.next(options);
        },

        onError: (DioException error, handler) async {
          if (error.response?.statusCode == 401) {
            print("⚠️ Token expired, attempting refresh...");
            try {
              // Attempt to refresh the token
              final response = await dio.post(
                'https://whale-app-pqthm.ondigitalocean.app/api/v0/auth/refresh_token',
                options: Options(
                  headers: {'Authorization': 'Bearer $refreshToken'},
                ),
              );

              if (response.statusCode == 200) {
                final newAccessToken = response.data['accessToken'];
                print("✅ Token refreshed successfully");

                // Update the access token in the headers
                dio.options.headers['Authorization'] = 'Bearer $newAccessToken';

                // Retry the original request with the new token
                final options = error.requestOptions;
                options.headers['Authorization'] = 'Bearer $newAccessToken';
                final retryResponse = await dio.fetch(options);
                return handler.resolve(retryResponse);
              } else {
                print(" Failed to refresh token: ${response.statusCode}");
              }
            } catch (e) {
              print(" Error refreshing token: $e");
            }
          }
        },
      ),
    );
  }

  Future<void> test401() async {
    try {
      final response = await dio.get(
        'https://whale-app-pqthm.ondigitalocean.app/api/v0/user/me',
        options: Options(headers: {'AUTHORIZATION': 'Bearer token'}),
      );
      print('Response: ${response.data}');
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        print('Unauthorized access - 401 error');
      } else {
        print('Error: ${e.message}');
      }
    }
  }

  Future<String> fetchUserData() async {
    final response = await dio.get(
      'https://discordapp.com/channels/@me/1394225747568099480/1395011955479285811',
    );
    print('Response: ${response.data}');
    return response.data.toString();
  }
}
