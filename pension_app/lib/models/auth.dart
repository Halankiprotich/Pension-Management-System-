class AuthModel {
  final String token;
  final String username;
  final String role;

  AuthModel({
    required this.token,
    required this.username,
    required this.role,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      token: json['token'],
      username: json['username'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'username': username,
      'role': role,
    };
  }
}