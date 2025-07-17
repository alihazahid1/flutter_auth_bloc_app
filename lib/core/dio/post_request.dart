import 'package:dio/dio.dart';

class PostRequest {
  static Future<Response?> postFullUrl(
    String fullUrl,
    Map<String, dynamic> data,
  ) async {
    try {
      final dio = Dio(); // Raw Dio instance without interceptors
      final response = await dio.post(fullUrl, data: data);

      print('[✅] Response Status: ${response.statusCode}');
      print('[✅] Response Data: ${response.data}');

      return response;
    } catch (e) {
      print('[❌] Full URL POST request error: $e');
      return null;
    }
  }
}
