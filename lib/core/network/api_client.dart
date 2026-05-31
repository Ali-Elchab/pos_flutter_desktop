import 'package:dio/dio.dart';
import 'package:pos_flutter_desktop/core/constants/api_constants.dart';
import 'package:pos_flutter_desktop/core/network/api_exception.dart';

class ApiClient {
  ApiClient({Dio? dio, String baseUrl = ApiConstants.baseUrl})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: baseUrl,
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
              headers: const {
                'Accept': 'application/json',
                'Content-Type': 'application/json',
              },
            ),
          );

  final Dio _dio;

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        path,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (error) {
      throw ApiException(
        _resolveErrorMessage(error),
        statusCode: error.response?.statusCode,
      );
    }
  }

  String _resolveErrorMessage(DioException error) {
    final data = error.response?.data;
    if (data is Map<String, dynamic>) {
      final message = data['message'] ?? data['title'] ?? data['error'];
      if (message is String && message.isNotEmpty) return message;
    }

    return error.message ?? 'Unable to connect to the backend.';
  }
}
