/// Models
class User {
  final String id;
  final String username;
  final String? role;
  final int? roleId;

  User({
    required this.id,
    required this.username,
    this.role,
    this.roleId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      role: json['role'],
      roleId: json['role_id'],
    );
  }
}
