import 'package:json_isolate_parser/json_isolate_parser.dart';

class User {
  final int id;
  final String name;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }

  @override
  String toString() => 'User(id: $id, name: $name, email: $email)';
}


void main() async {
  final client = JsonApiClient();

  final user = await client.getObject<User>(
    url: 'https://jsonplaceholder.typicode.com/users/1',
    fromJson: User.fromJson,
  );

  if (user != null) {
    print('User: $user');
  } else {
    print('Failed to fetch user');
  }

  final users = await client.getList<User>(
    url: 'https://jsonplaceholder.typicode.com/users',
    fromJson: User.fromJson,
  );

  print('Users: $users');
}



