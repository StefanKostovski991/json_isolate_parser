import 'package:dio/dio.dart';
import 'isolate_parser.dart';

class JsonApiClient {
  JsonApiClient({
    Dio? dio,
    BaseOptions? options,
  }) : _dio = dio ?? Dio(options);

  final Dio _dio;

  /// GET a single JSON object and parse it as T using an isolate.
  Future<T?> getObject<T>({
  required String url,
  required FromJson<T> fromJson,
}) async {
  try {
    final response = await _dio.get(url);
    final data = response.data;
    final source = (data is String || data is Map<String, dynamic>) ? data : data.toString();
    return await parseObjectInIsolate<T>(source: source, fromJson: fromJson);
  } on DioException catch (e) {
    print('Request failed: ${e.message}, status: ${e.response?.statusCode}');
    return null; // or rethrow, depending on your needs
  } catch (e) {
    print('Parsing failed: $e');
    return null;
  }
}


  /// GET a JSON array and parse it as List<T> using an isolate.
  Future<List<T>> getList<T>({
    required String url,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    required FromJsonList<T> fromJson,
  }) async {
    final response = await _dio.get(
      url,
      queryParameters: queryParameters,
      options: Options(headers: headers, responseType: ResponseType.json),
    );

    final data = response.data;
    final source = (data is String || data is List) ? data : _safeJsonString(data);
    return parseListInIsolate<T>(source: source, fromJson: fromJson);
  }

  /// POST with a JSON body and parse a JSON object response as T.
  Future<T> postObject<T>({
    required String url,
    Object? body,
    Map<String, dynamic>? headers,
    required FromJson<T> fromJson,
  }) async {
    final response = await _dio.post(
      url,
      data: body,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          ...?headers,
        },
        responseType: ResponseType.json,
      ),
    );

    final data = response.data;
    final source = (data is String || data is Map<String, dynamic>) ? data : _safeJsonString(data);
    return parseObjectInIsolate<T>(source: source, fromJson: fromJson);
  }

  String _safeJsonString(Object? data) {
    // Fallback to stringifying unknown types and letting the parser handle it.
    return data is String ? data : data.toString();
  }
}
