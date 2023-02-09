import '../domain/entity/installment_status.dart';
import 'constant.dart';
import 'installment_status_appearance_data.dart';

class _InstallmentStatusHelperImpl {
  InstallmentStatusAppearanceData toInstallmentStatusAppearanceData(InstallmentStatus installmentStatus) {
    if (installmentStatus == InstallmentStatus.approved) {
      return InstallmentStatusAppearanceData(
        statusTitle: "Permintaan Cicilan Disetujui",
        statusDescription: "Permintaan cicilan telah disetujui",
        color: Constant.colorSuccessGreen
      );
    } else if (installmentStatus == InstallmentStatus.request) {
      return InstallmentStatusAppearanceData(
        statusTitle: "Permintaan Cicilan Dibuat",
        statusDescription: "Permintaan cicilan telah dibuat",
        color: Constant.colorDarkGrey
      );
    } else if (installmentStatus == InstallmentStatus.needApprove) {
      return InstallmentStatusAppearanceData(
        statusTitle: "Butuh Disetujui",
        statusDescription: "Permintaan cicilan butuh untuk disetujui",
        color: Constant.colorYellow
      );
    } else if (installmentStatus == InstallmentStatus.deny) {
      return InstallmentStatusAppearanceData(
        statusTitle: "Permintaan Cicilan Ditolak",
        statusDescription: "Permintaan cicilan telah ditolak",
        color: Constant.colorRedDanger
      );
    } else if (installmentStatus == InstallmentStatus.goal) {
      return InstallmentStatusAppearanceData(
        statusTitle: "Cicilan Diselesaikan",
        statusDescription: "Cicilan berhasil diselesaikan",
        color: Constant.colorSuccessGreen
      );
    } else {
      return InstallmentStatusAppearanceData(
        statusTitle: "Tidak Diketahui Statusnya",
        statusDescription: "Status saat ini tidak diketahui seperti apa",
        color: Constant.colorDarkGrey
      );
    }
  }
}

// ignore: non_constant_identifier_names
final InstallmentStatusHelper = _InstallmentStatusHelperImpl();