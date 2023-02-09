import '../authorization.dart';
import '../user/user.dart';

class LoginResponse {
  User user;
  Authorization authorization;

  LoginResponse({
    required this.user,
    required this.authorization
  });
}