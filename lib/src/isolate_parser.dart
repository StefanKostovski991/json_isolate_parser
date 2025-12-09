import 'dart:convert';
import 'dart:isolate';

typedef FromJson<T> = T Function(Map<String, dynamic> json);
typedef FromJsonList<T> = T Function(Map<String, dynamic> json);

/// Parse a JSON object string or Map on a background isolate into T.
Future<T> parseObjectInIsolate<T>({
  required Object source,
  required FromJson<T> fromJson,
}) async {
  return Isolate.run<T>(() {
    final Map<String, dynamic> map;

    if (source is String) {
      final decoded = json.decode(source);
      if (decoded is Map<String, dynamic>) {
        map = decoded;
      } else {
        throw FormatException('Expected JSON object, got ${decoded.runtimeType}');
      }
    } else if (source is Map<String, dynamic>) {
      map = source;
    } else {
      throw ArgumentError('Source must be a JSON string or Map<String, dynamic>');
    }

    return fromJson(map);
  });
}

/// Parse a JSON array string or List on a background isolate into List<T>.
Future<List<T>> parseListInIsolate<T>({
  required Object source,
  required FromJsonList<T> fromJson,
}) async {
  return Isolate.run<List<T>>(() {
    final List<dynamic> list;

    if (source is String) {
      final decoded = json.decode(source);
      if (decoded is List) {
        list = decoded;
      } else {
        throw FormatException('Expected JSON array, got ${decoded.runtimeType}');
      }
    } else if (source is List) {
      list = source;
    } else {
      throw ArgumentError('Source must be a JSON string or List<dynamic>');
    }

    return list
        .map((e) {
          if (e is Map<String, dynamic>) {
            return fromJson(e);
          }
          throw FormatException('Array element must be a JSON object, got ${e.runtimeType}');
        })
        .toList(growable: false);
  });
}
