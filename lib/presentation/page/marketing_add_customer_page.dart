import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:daru_estate/misc/ext/validation_result_ext.dart';
import 'package:sizer/sizer.dart';

import '../../controller/marketing_add_customer_controller.dart';
import '../../domain/repository/source_repository.dart';
import '../../misc/constant.dart';
import '../../misc/controllerstate/obscure_password_text_field_controller_state.dart';
import '../../misc/controllerstate/text_field_controller_state.dart';
import '../../misc/dialog_helper.dart';
import '../../misc/errorprovider/error_provider.dart';
import '../../misc/getextended/get_extended.dart';
import '../../misc/getextended/get_restorable_route_future.dart';
import '../../misc/injector.dart';
import '../../misc/inputdecoration/default_input_decoration.dart';
import '../../misc/manager/controller_manager.dart';
import '../../misc/validation/validator/validator.dart';
import '../widget/attachment_file.dart';
import '../widget/date_time_chooser.dart';
import '../widget/field.dart';
import '../widget/house_chooser.dart';
import '../widget/modified_text_field.dart';
import '../widget/modifiedappbar/modified_app_bar.dart';
import '../widget/password_obscurer.dart';
import '../widget/rx_consumer.dart';
import 'crop_picture_page.dart';
import 'getx_page.dart';
import 'select_house_page.dart';

class MarketingAddCustomerPage extends RestorableGetxPage<_MarketingAddCustomerPageRestoration> {
  late final ControllerMember<MarketingAddCustomerController> _marketingAddCustomerController = ControllerMember<MarketingAddCustomerController>().addToControllerManager(controllerManager);

  MarketingAddCustomerPage({Key? key}) : super(key: key, pageRestorationId: () => "marketing-add-customer-page");

  @override
  void onSetController() {
    _marketingAddCustomerController.controller = GetExtended.put<MarketingAddCustomerController>(MarketingAddCustomerController(controllerManager, Injector.locator<SourceRepository>()), tag: pageName);
  }

  @override
  // ignore: library_private_types_in_public_api
  _MarketingAddCustomerPageRestoration createPageRestoration() => _MarketingAddCustomerPageRestoration(
    onCompleteSetBookingFeePicture: (imageUrl) {
      if (imageUrl != null) {
        _marketingAddCustomerController.controller.setBookingFeePic(imageUrl);
      }
      Get.back();
    },
    onCompleteSelectHouse: (selectedHouseJsonString) {
      if (selectedHouseJsonString != null) {
        _marketingAddCustomerController.controller.setHouseJsonMap(json.decode(selectedHouseJsonString));
      }
    }
  );

  @override
  Widget buildPage(BuildContext context) {
    // ignore: prefer_function_declarations_over_variables
    VoidCallback beginRegister = () => _marketingAddCustomerController.controller.register(
      onUnfocusAllWidget: () => FocusScope.of(context).unfocus(),
      onShowRegisterRequestProcessLoadingCallback: () async => DialogHelper.showLoadingDialog(context),
      onRegisterRequestProcessSuccessCallback: () async => Get.back(),
      onShowRegisterRequestProcessFailedCallback: (e) => DialogHelper.showFailedModalBottomDialogFromErrorProvider(
        context: context,
        errorProvider: Injector.locator<ErrorProvider>(),
        e: e
      )
    );
    return Scaffold(
      appBar: ModifiedAppBar(
        title: Text("Tambah Customer".tr),
        titleInterceptor: (context, title) => Row(
          children: [
            Expanded(
              child: title ?? Container()
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(4.w),
          child: Column(
            children: [
              RxConsumer<TextFieldControllerState>(
                rxValue: _marketingAddCustomerController.controller.emailTextFieldControllerStateRx,
                onConsumeValue: (context, value) => Field(
                  fieldName: "Email",
                  child: (context, validationResult, validator) => ModifiedTextField(
                    isError: validationResult.isFailed,
                    controller: value.textEditingController,
                    decoration: DefaultInputDecoration(hintText: "Enter Email".tr),
                    onChanged: (value) => validator?.validate(),
                    textInputAction: TextInputAction.next,
                  ),
                  validator: value.validator,
                ),
              ),
              SizedBox(height: 3.h),
              RxConsumer<TextFieldControllerState>(
                rxValue: _marketingAddCustomerController.controller.nikTextFieldControllerStateRx,
                onConsumeValue: (context, value) => Field(
                  fieldName: "NIK",
                  child: (context, validationResult, validator) => ModifiedTextField(
                    isError: validationResult.isFailed,
                    controller: value.textEditingController,
                    decoration: DefaultInputDecoration(hintText: "Enter NIK".tr),
                    onChanged: (value) => validator?.validate(),
                    textInputAction: TextInputAction.next,
                  ),
                  validator: value.validator,
                ),
              ),
              SizedBox(height: 3.h),
              RxConsumer<TextFieldControllerState>(
                rxValue: _marketingAddCustomerController.controller.nameTextFieldControllerStateRx,
                onConsumeValue: (context, value) => Field(
                  fieldName: "Name",
                  child: (context, validationResult, validator) => ModifiedTextField(
                    isError: validationResult.isFailed,
                    controller: value.textEditingController,
                    decoration: DefaultInputDecoration(hintText: "Enter Name".tr),
                    onChanged: (value) => validator?.validate(),
                    textInputAction: TextInputAction.next,
                  ),
                  validator: value.validator,
                ),
              ),
              SizedBox(height: 3.h),
              RxConsumer<TextFieldControllerState>(
                rxValue: _marketingAddCustomerController.controller.birthplaceTextFieldControllerStateRx,
                onConsumeValue: (context, value) => Field(
                  fieldName: "Tempat Lahir",
                  child: (context, validationResult, validator) => ModifiedTextField(
                    isError: validationResult.isFailed,
                    controller: value.textEditingController,
                    decoration: DefaultInputDecoration(hintText: "Enter Tempat Lahir".tr),
                    onChanged: (value) => validator?.validate(),
                    textInputAction: TextInputAction.next,
                  ),
                  validator: value.validator,
                ),
              ),
              SizedBox(height: 3.h),
              RxConsumer<Validator>(
                rxValue: _marketingAddCustomerController.controller.birthdateValidatorRx,
                onConsumeValue: (context, value) => Field(
                  fieldName: "Tanggal Lahir",
                  child: (context, validationResult, validator) => RxConsumer<DateTimeWrapper>(
                    rxValue: _marketingAddCustomerController.controller.birthdateDateTimeWrapper,
                    onConsumeValue: (context, value) => DateTimeChooser(
                      selectedDateTime: value.dateTime,
                      hintText: "Pilih tanggal lahir...".tr,
                      onDateTimeSelected: (dateTime) {
                        _marketingAddCustomerController.controller.setBirthdate(dateTime);
                      },
                      onDateTimeReset: () {
                        _marketingAddCustomerController.controller.setBirthdate(null);
                      },
                    ),
                  ),
                  validator: value,
                ),
              ),
              SizedBox(height: 3.h),
              RxConsumer<TextFieldControllerState>(
                rxValue: _marketingAddCustomerController.controller.phoneTextFieldControllerStateRx,
                onConsumeValue: (context, value) => Field(
                  fieldName: "Phone",
                  child: (context, validationResult, validator) => ModifiedTextField(
                    isError: validationResult.isFailed,
                    controller: value.textEditingController,
                    decoration: DefaultInputDecoration(hintText: "Enter Phone".tr),
                    onChanged: (value) => validator?.validate(),
                    textInputAction: TextInputAction.next,
                  ),
                  validator: value.validator,
                ),
              ),
              SizedBox(height: 3.h),
              RxConsumer<TextFieldControllerState>(
                rxValue: _marketingAddCustomerController.controller.addressTextFieldControllerStateRx,
                onConsumeValue: (context, value) => Field(
                  fieldName: "Enter Address",
                  child: (context, validationResult, validator) => ModifiedTextField(
                    isError: validationResult.isFailed,
                    controller: value.textEditingController,
                    decoration: DefaultInputDecoration(hintText: "Enter Address".tr),
                    onChanged: (value) => validator?.validate(),
                    textInputAction: TextInputAction.next,
                  ),
                  validator: value.validator,
                ),
              ),
              SizedBox(height: 3.h),
              RxConsumer<TextFieldControllerState>(
                rxValue: _marketingAddCustomerController.controller.postalCodeTextFieldControllerStateRx,
                onConsumeValue: (context, value) => Field(
                  fieldName: "Enter Kode Pos",
                  child: (context, validationResult, validator) => ModifiedTextField(
                    isError: validationResult.isFailed,
                    controller: value.textEditingController,
                    decoration: DefaultInputDecoration(hintText: "Enter Kode Pos".tr),
                    onChanged: (value) => validator?.validate(),
                    textInputAction: TextInputAction.next,
                  ),
                  validator: value.validator,
                ),
              ),
              SizedBox(height: 3.h),
              RxConsumer<TextFieldControllerState>(
                rxValue: _marketingAddCustomerController.controller.provinceTextFieldControllerStateRx,
                onConsumeValue: (context, value) => Field(
                  fieldName: "Provinsi",
                  child: (context, validationResult, validator) => ModifiedTextField(
                    isError: validationResult.isFailed,
                    controller: value.textEditingController,
                    decoration: DefaultInputDecoration(hintText: "Enter Provinsi".tr),
                    onChanged: (value) => validator?.validate(),
                    textInputAction: TextInputAction.next,
                  ),
                  validator: value.validator,
                ),
              ),
              SizedBox(height: 3.h),
              RxConsumer<TextFieldControllerState>(
                rxValue: _marketingAddCustomerController.controller.cityTextFieldControllerStateRx,
                onConsumeValue: (context, value) => Field(
                  fieldName: "Kota",
                  child: (context, validationResult, validator) => ModifiedTextField(
                    isError: validationResult.isFailed,
                    controller: value.textEditingController,
                    decoration: DefaultInputDecoration(hintText: "Enter Kota".tr),
                    onChanged: (value) => validator?.validate(),
                    textInputAction: TextInputAction.next,
                  ),
                  validator: value.validator,
                ),
              ),
              SizedBox(height: 3.h),
              RxConsumer<TextFieldControllerState>(
                rxValue: _marketingAddCustomerController.controller.subDistrictTextFieldControllerStateRx,
                onConsumeValue: (context, value) => Field(
                  fieldName: "Kecamatan",
                  child: (context, validationResult, validator) => ModifiedTextField(
                    isError: validationResult.isFailed,
                    controller: value.textEditingController,
                    decoration: DefaultInputDecoration(hintText: "Enter Kecamatan".tr),
                    onChanged: (value) => validator?.validate(),
                    textInputAction: TextInputAction.next,
                  ),
                  validator: value.validator,
                ),
              ),
              SizedBox(height: 3.h),
              RxConsumer<TextFieldControllerState>(
                rxValue: _marketingAddCustomerController.controller.villageTextFieldControllerStateRx,
                onConsumeValue: (context, value) => Field(
                  fieldName: "Village",
                  child: (context, validationResult, validator) => ModifiedTextField(
                    isError: validationResult.isFailed,
                    controller: value.textEditingController,
                    decoration: DefaultInputDecoration(hintText: "Enter Village".tr),
                    onChanged: (value) => validator?.validate(),
                    textInputAction: TextInputAction.next,
                  ),
                  validator: value.validator,
                ),
              ),
              SizedBox(height: 3.h),
              RxConsumer<Validator>(
                rxValue: _marketingAddCustomerController.controller.houseValidatorRx,
                onConsumeValue: (context, value) => Field(
                  fieldName: "Rumah",
                  child: (context, validationResult, validator) => RxConsumer<SelectedHouseWrapper>(
                    rxValue: _marketingAddCustomerController.controller.selectedHouseWrapperRx,
                    onConsumeValue: (context, value) => HouseChooser(
                      selectedHouseJsonMap: value.selectedHouseJsonMap,
                    ),
                  ),
                  validator: value,
                ),
              ),
              SizedBox(height: 3.h),
              RxConsumer<Validator>(
                rxValue: _marketingAddCustomerController.controller.bookingFeeDateValidatorRx,
                onConsumeValue: (context, value) => Field(
                  fieldName: "Booking Fee Date",
                  child: (context, validationResult, validator) => RxConsumer<DateTimeWrapper>(
                    rxValue: _marketingAddCustomerController.controller.bookingFeeDateTimeWrapper,
                    onConsumeValue: (context, value) => DateTimeChooser(
                      selectedDateTime: value.dateTime,
                      hintText: "Pilih Tanggal Booking Fee...".tr,
                      onDateTimeSelected: (dateTime) {
                        _marketingAddCustomerController.controller.setBookingFeeDate(dateTime);
                      },
                      onDateTimeReset: () {
                        _marketingAddCustomerController.controller.setBookingFeeDate(null);
                      },
                    ),
                  ),
                  validator: value,
                ),
              ),
              SizedBox(height: 3.h),
              RxConsumer<Validator>(
                rxValue: _marketingAddCustomerController.controller.bookingFeePicValidatorRx,
                onConsumeValue: (context, value) => Field(
                  fieldName: "Booking Fee Picture",
                  validator: value,
                  child: (context, validationResult, validator) => RxConsumer<FileSelectedWrapper>(
                    rxValue: _marketingAddCustomerController.controller.bookingFeePicFileSelectedWrapperRx,
                    onConsumeValue: (context, value) => PhotoAttachmentFile(
                      selectFileButtonText: "Upload Gambar".tr,
                      fileSelected: value.fileSelected,
                      onImageSelectedWithoutCropping: (filePath) {
                        _marketingAddCustomerController.controller.setBookingFeePic(filePath);
                      },
                    ),
                  )
                ),
              ),
              SizedBox(height: 3.h),
              SizedBox(
                width: double.infinity,
                height: 5.h,
                child: TextButton(
                  onPressed: beginRegister,
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    foregroundColor: Colors.white,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  child: Text("Continue".tr),
                )
              ),
            ],
          ),
        )
      ),
    );
  }
}

class MarketingAddCustomerPageGetPageBuilderAssistant extends GetPageBuilderAssistant {
  @override
  GetPageBuilder get pageBuilder => (() => MarketingAddCustomerPage());

  @override
  GetPageBuilder get pageWithOuterGetxBuilder => (() => GetxPageBuilder.buildRestorableGetxPage(MarketingAddCustomerPage()));
}

class _MarketingAddCustomerPageRestoration extends MixableGetxPageRestoration with CropPicturePageRestorationMixin, SelectHousePageRestorationMixin {
  final RouteCompletionCallback<String?>? _onCompleteSetBookingFeePicture;
  final RouteCompletionCallback<String?>? _onCompleteSelectHouse;

  _MarketingAddCustomerPageRestoration({
    RouteCompletionCallback<String?>? onCompleteSetBookingFeePicture,
    RouteCompletionCallback<String?>? onCompleteSelectHouse,
  }) : _onCompleteSetBookingFeePicture = onCompleteSetBookingFeePicture,
    _onCompleteSelectHouse = onCompleteSelectHouse;

  @override
  void initState() {
    onCompleteSetPicture = _onCompleteSetBookingFeePicture;
    onCompleteSelectHouse = _onCompleteSelectHouse;
    super.initState();
  }

  @override
  // ignore: unnecessary_overrides
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(restorator, oldBucket, initialRestore);
  }

  @override
  // ignore: unnecessary_overrides
  void dispose() {
    super.dispose();
  }
}

mixin MarketingAddCustomerPageRestorationMixin on MixableGetxPageRestoration {
  late MarketingAddCustomerPageRestorableRouteFuture marketingAddCustomerPageRestorableRouteFuture;

  @override
  void initState() {
    super.initState();
    marketingAddCustomerPageRestorableRouteFuture = MarketingAddCustomerPageRestorableRouteFuture(restorationId: restorationIdWithPageName('marketing-add-customer-route'));
  }

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(restorator, oldBucket, initialRestore);
    marketingAddCustomerPageRestorableRouteFuture.restoreState(restorator, oldBucket, initialRestore);
  }

  @override
  void dispose() {
    super.dispose();
    marketingAddCustomerPageRestorableRouteFuture.dispose();
  }
}

class MarketingAddCustomerPageRestorableRouteFuture extends GetRestorableRouteFuture {
  late RestorableRouteFuture<void> _pageRoute;

  MarketingAddCustomerPageRestorableRouteFuture({required String restorationId}) : super(restorationId: restorationId) {
    _pageRoute = RestorableRouteFuture<void>(
      onPresent: (NavigatorState navigator, Object? arguments) {
        return navigator.restorablePush(_pageRouteBuilder, arguments: arguments);
      },
    );
  }

  static Route<void>? _getRoute([Object? arguments]) {
    return GetExtended.toWithGetPageRouteReturnValue<void>(GetxPageBuilder.buildRestorableGetxPageBuilder(MarketingAddCustomerPageGetPageBuilderAssistant()));
  }

  static Route<void> _pageRouteBuilder(BuildContext context, Object? arguments) {
    return _getRoute(arguments)!;
  }

  @override
  bool checkBeforePresent([Object? arguments]) => _getRoute(arguments) != null;

  @override
  void presentIfCheckIsPassed([Object? arguments]) => _pageRoute.present(arguments);

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    restorator.registerForRestoration(_pageRoute, restorationId);
  }

  @override
  void dispose() {
    _pageRoute.dispose();
  }
}