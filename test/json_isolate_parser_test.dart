import 'package:flutter_test/flutter_test.dart';
import 'package:json_isolate_parser/json_isolate_parser.dart';

class User {
  final int id;
  final String name;

  User({required this.id, required this.name});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}

void main() {
  test('parseObjectInIsolate parses a single user', () async {
    const jsonString = '{"id": 1, "name": "Alice"}';

    final user = await parseObjectInIsolate<User>(
      source: jsonString,
      fromJson: User.fromJson,
    );

    expect(user.id, 1);
    expect(user.name, 'Alice');
  });

  test('parseListInIsolate parses a list of users', () async {
    const jsonString = '[{"id": 1, "name": "Alice"}, {"id": 2, "name": "Bob"}]';

    final users = await parseListInIsolate<User>(
      source: jsonString,
      fromJson: User.fromJson,
    );

    expect(users.length, 2);
    expect(users[0].name, 'Alice');
    expect(users[1].name, 'Bob');
  });
}
