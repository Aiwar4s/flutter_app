import 'package:jwt_decoder/jwt_decoder.dart';

import '../../entities/user.dart';

class JwtService {
  static User getUserFromToken(String token) {
    final values = JwtDecoder.decode(token);
    final username = values['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name'];
    final email = values['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress'];
    final role = values['http://schemas.microsoft.com/ws/2008/06/identity/claims/role']
        .contains('Admin') ? UserRole.admin : UserRole.user;
    return User(email, username, role);
  }
}