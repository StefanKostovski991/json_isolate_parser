# json_isolate_parser

A Dart package that performs **JSON parsing in a separate thread using isolates**, ensuring smooth performance and preventing UI jank.  
Built on top of the [`dio`](https://pub.dev/packages/dio) HTTP client for efficient networking.

---

## ✨ Features
- 🚀 Parse large JSON responses without blocking the main thread.
- 🔄 Uses Dart isolates for concurrency and performance.
- 🌐 Integrated with Dio for seamless HTTP requests + parsing.
- 🛡️ Safe and efficient parsing for Flutter and Dart applications.

---

## 📦 Installation
Add the dependency in your `pubspec.yaml`:

## 🛠️ Usage

import 'package:dio/dio.dart';
import 'package:json_isolate_parser/json_isolate_parser.dart';

void main() async {
  final dio = Dio();

  // Fetch JSON data
  final response = await dio.get('https://jsonplaceholder.typicode.com/posts');

  // Parse JSON in a separate isolate
  final parsedData = await JsonIsolateParser.parse(response.data);

  print(parsedData); // Parsed list of posts
}


```yaml
dependencies:
  json_isolate_parser: ^0.0.2

