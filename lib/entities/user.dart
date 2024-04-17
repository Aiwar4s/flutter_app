class User{
  final String id;
  final String username;
  final String email;
  final UserRole role;
  final num? averageRating;

  User(this.id, this.email, this.username, this.role, this.averageRating);

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'email': email,
    'role': role.toString().split('.').last,
    'averageRating': averageRating
  };

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      json['id'],
      json['email'],
      json['username'],
      json['role'] == null ? UserRole.user : json['role'] == 'admin' ? UserRole.admin : UserRole.user,
      json['averageRating'] ?? 0.0
    );
  }

  bool get isAdmin => role == UserRole.admin;
}

enum UserRole{
  admin,
  user
}