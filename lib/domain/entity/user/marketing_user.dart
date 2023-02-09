import 'user.dart';

class MarketingUser extends User {
  String marketingId;

  MarketingUser({
    required String id,
    required this.marketingId,
    required String email,
    required String name
  }) : super(
    id: id,
    email: email,
    name: name
  );
}