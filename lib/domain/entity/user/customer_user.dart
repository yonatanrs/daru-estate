import 'user.dart';

class CustomerUser extends User {
  String customerId;

  CustomerUser({
    required String id,
    required this.customerId,
    required String email,
    required String name
  }) : super(
    id: id,
    email: email,
    name: name
  );
}