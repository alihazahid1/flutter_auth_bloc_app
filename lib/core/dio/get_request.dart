import 'package:dio/dio.dart';
import 'api_client.dart';

class GetRequest {
  static Future<Response?> get(String endpoint) async {
    try {
      final dio = ApiClient().dio;
      final response = await dio.get('user/me');
      return response;
    } catch (e) {
      print('[❌] GET request error: $e');
      return null;
    }
  }
}
