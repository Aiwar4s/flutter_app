class User{
  final String id;
  final String username;
  final String email;
  final UserRole role;

  User(this.id, this.email, this.username, this.role);

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'email': email,
    'role': role.toString().split('.').last
  };

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      json['id'],
      json['email'],
      json['username'],
      json['role'] == null ? UserRole.user : json['role'] == 'admin' ? UserRole.admin : UserRole.user
    );
  }

  bool get isAdmin => role == UserRole.admin;
}

enum UserRole{
  admin,
  user
}