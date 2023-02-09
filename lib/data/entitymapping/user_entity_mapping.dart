import '../../domain/entity/user/customer_user.dart';
import '../../domain/entity/user/marketing_user.dart';
import '../../domain/entity/user/user.dart';
import '../../misc/error/message_error.dart';
import '../../misc/response_wrapper.dart';

extension UserEntityMapping on ResponseWrapper {
  User mapFromResponseToUser() {
    String roles = response["roles"];
    if (roles == "c") {
      return CustomerUser(
        id: response["id"].toString(),
        customerId: response["customer_id"] ?? "",
        email: response["email"],
        name: response["name"],
      );
    } else if (roles == "m") {
      return MarketingUser(
        id: response["id"].toString(),
        marketingId: response["marketing_id"] ?? "",
        email: response["email"],
        name: response["name"],
      );
    } else {
      throw MessageError(title: "User roles is not suitable ($roles)");
    }
  }
}