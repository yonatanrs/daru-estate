import 'package:daru_estate/misc/ext/error_provider_ext.dart';
import 'package:daru_estate/misc/ext/load_data_result_ext.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../domain/entity/mydata/get_my_data_response.dart';
import '../../misc/constant.dart';
import '../../misc/errorprovider/error_provider.dart';
import '../../misc/installment_status_appearance_data.dart';
import '../../misc/installment_status_helper.dart';
import '../../misc/load_data_result.dart';
import 'loaddataresultimplementer/load_data_result_implementer_directly.dart';

class CustomerHeader extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final ErrorProvider errorProvider;
  final LoadDataResult<GetMyDataResponse> getMyDataResponseLoadDataResult;

  const CustomerHeader({
    Key? key,
    required this.getMyDataResponseLoadDataResult,
    required this.errorProvider,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoadDataResultImplementerDirectly(
      loadDataResult: getMyDataResponseLoadDataResult,
      errorProvider: errorProvider,
      onImplementLoadDataResultDirectly: (loadDataResult, errorProvider) {
        String loadingText = "Loading".tr;
        String loggedName = "($loadingText)";
        String installmentStatusTitleString = "($loadingText)";
        String installmentStatusDescriptionString = "($loadingText)";
        Color backgroundColor = Constant.colorGrey;
        if (loadDataResult.isSuccess) {
          GetMyDataResponse getMyDataResponse = loadDataResult.resultIfSuccess!;
          InstallmentStatusAppearanceData installmentStatusAppearanceData = InstallmentStatusHelper.toInstallmentStatusAppearanceData(getMyDataResponse.customer.status);
          loggedName = "Selamat Datang ${getMyDataResponse.customer.name}";
          installmentStatusTitleString = installmentStatusAppearanceData.statusTitle;
          installmentStatusDescriptionString = installmentStatusAppearanceData.statusDescription;
          backgroundColor = installmentStatusAppearanceData.color;
        } else if (loadDataResult.isFailed) {
          dynamic e = loadDataResult.resultIfFailed;
          ErrorProviderResult errorProviderResult = errorProvider.onGetErrorProviderResult(e).toErrorProviderResultNonNull();
          installmentStatusTitleString = errorProviderResult.title;
          installmentStatusDescriptionString = errorProviderResult.message;
          backgroundColor = Constant.colorRedDanger;
        }
        return Padding(
          padding: padding ?? EdgeInsets.all(Constant.paddingListItem),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(loggedName, style: const TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 1.h),
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: backgroundColor
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(installmentStatusTitleString, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
                          SizedBox(height: 0.5.h),
                          Text(installmentStatusDescriptionString, style: TextStyle(color: Constant.colorGrey2)),
                        ]
                      ),
                    ),
                  ],
                )
              )
            ],
          )
        );
      }
    );
  }
}