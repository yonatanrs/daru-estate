import '../../domain/entity/installment_status.dart';
import '../../misc/response_wrapper.dart';

extension InstallmentStatusEntityMapping on ResponseWrapper {
  InstallmentStatus mapFromResponseToInstallmentStatus() {
    if (response == "a") {
      return InstallmentStatus.approved;
    } else if (response == "r") {
      return InstallmentStatus.request;
    } else if (response == "na") {
      return InstallmentStatus.needApprove;
    } else if (response == "d") {
      return InstallmentStatus.deny;
    } else if (response == "g") {
      return InstallmentStatus.goal;
    } else {
      return InstallmentStatus.unknown;
    }
  }
}