// models/user_model.dart
class UserGetAll {
  final String id;
  final String name;
  final String email;
  final String role;

  UserGetAll(
      {required this.id,
      required this.name,
      required this.email,
      required this.role});

  factory UserGetAll.fromJson(Map<String, dynamic> json) {
    return UserGetAll(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
    );
  }
}
