import '../../domain/entity/authorization.dart';
import '../../misc/response_wrapper.dart';

extension AuthorizationEntityMapping on ResponseWrapper {
  Authorization mapFromResponseToAuthorization() {
    return Authorization(
      token: response["token"],
      type: response["type"]
    );
  }
}