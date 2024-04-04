class User{
  final String username;
  final String email;
  final UserRole role;

  User(this.email, this.username, this.role);

  Map<String, dynamic> toJson() => {
    'username': username,
    'email': email,
    'role': role.toString().split('.').last
  };

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      json['email'],
      json['username'],
      json['role'] == 'admin' ? UserRole.admin : UserRole.user
    );
  }
}

enum UserRole{
  admin,
  user
}