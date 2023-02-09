import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:daru_estate/misc/ext/load_data_result_ext.dart';
import 'package:daru_estate/misc/ext/rx_ext.dart';
import 'package:daru_estate/misc/ext/string_ext.dart';

import '../domain/entity/customer/new_customer_parameter.dart';
import '../domain/entity/customer/new_customer_response.dart';
import '../domain/repository/source_repository.dart';
import '../misc/controllerstate/obscure_password_text_field_controller_state.dart';
import '../misc/controllerstate/text_field_controller_state.dart';
import '../misc/date_util.dart';
import '../misc/error/validation_error.dart';
import '../misc/injector.dart';
import '../misc/load_data_result.dart';
import '../misc/login_helper.dart';
import '../misc/manager/controller_manager.dart';
import '../misc/typedef.dart';
import '../misc/validation/validation_result.dart';
import '../misc/validation/validator/email_validator.dart';
import '../misc/validation/validator/validator.dart';
import '../misc/validation/validatorgroup/add_customer_validator_group.dart';
import '../presentation/widget/attachment_file.dart';
import 'base_getx_controller.dart';

typedef _OnShowRegisterRequestProcessLoadingCallback = Future<void> Function();
typedef _OnRegisterRequestProcessSuccessCallback = Future<void> Function();
typedef _OnShowRegisterRequestProcessFailedCallback = Future<void> Function(dynamic e);

class MarketingAddCustomerController extends BaseGetxController {
  final SourceRepository sourceRepository;

  final TextEditingController _nameTextEditingController = TextEditingController();
  late final Rx<TextFieldControllerState> nameTextFieldControllerStateRx;

  DateTime? _birthdate;
  late final Rx<Validator> birthdateValidatorRx;

  final TextEditingController _birthplaceTextEditingController = TextEditingController();
  late final Rx<TextFieldControllerState> birthplaceTextFieldControllerStateRx;

  final TextEditingController _nikTextEditingController = TextEditingController();
  late final Rx<TextFieldControllerState> nikTextFieldControllerStateRx;

  final TextEditingController _emailTextEditingController = TextEditingController();
  late final Rx<TextFieldControllerState> emailTextFieldControllerStateRx;

  final TextEditingController _phoneTextEditingController = TextEditingController();
  late final Rx<TextFieldControllerState> phoneTextFieldControllerStateRx;

  final TextEditingController _addressTextEditingController = TextEditingController();
  late final Rx<TextFieldControllerState> addressTextFieldControllerStateRx;

  final TextEditingController _postalCodeTextEditingController = TextEditingController();
  late final Rx<TextFieldControllerState> postalCodeTextFieldControllerStateRx;

  final TextEditingController _provinceTextEditingController = TextEditingController();
  late final Rx<TextFieldControllerState> provinceTextFieldControllerStateRx;

  final TextEditingController _cityTextEditingController = TextEditingController();
  late final Rx<TextFieldControllerState> cityTextFieldControllerStateRx;

  final TextEditingController _subDistrictTextEditingController = TextEditingController();
  late final Rx<TextFieldControllerState> subDistrictTextFieldControllerStateRx;

  final TextEditingController _villageTextEditingController = TextEditingController();
  late final Rx<TextFieldControllerState> villageTextFieldControllerStateRx;

  String? _houseId;
  late final Rx<Validator> houseValidatorRx;

  DateTime? _bookingFeeDate;
  late final Rx<Validator> bookingFeeDateValidatorRx;

  String? _bookingFeePic;
  late final Rx<Validator> bookingFeePicValidatorRx;

  late final AddCustomerValidatorGroup addCustomerValidatorGroup;

  Rx<TextEditingController> loginTextEditingController = TextEditingController().obs;
  Rx<DateTimeWrapper> birthdateDateTimeWrapper = DateTimeWrapper(dateTime: null).obs;
  Rx<DateTimeWrapper> bookingFeeDateTimeWrapper = DateTimeWrapper(dateTime: null).obs;
  Rx<FileSelectedWrapper> bookingFeePicFileSelectedWrapperRx = FileSelectedWrapper(fileSelected: null).obs;
  Rx<SelectedHouseWrapper> selectedHouseWrapperRx = SelectedHouseWrapper(selectedHouseJsonMap: null).obs;

  MarketingAddCustomerController(ControllerManager? controllerManager, this.sourceRepository) : super(controllerManager) {
    addCustomerValidatorGroup = AddCustomerValidatorGroup(
      birthdateValidator: Validator(
        onValidate: () => _birthdate != null ? SuccessValidationResult() : FailedValidationResult(e: ValidationError(message: "${"Tanggal lahir dibutuhkan".tr}."))
      ),
      birthplaceValidator: Validator(
        onValidate: () => !_birthplaceTextEditingController.text.isEmptyString ? SuccessValidationResult() : FailedValidationResult(e: ValidationError(message: "${"Tempat lahir dibutuhkan".tr}."))
      ),
      nikValidator: Validator(
        onValidate: () => !_nikTextEditingController.text.isEmptyString ? SuccessValidationResult() : FailedValidationResult(e: ValidationError(message: "${"Nik dibutuhkan".tr}."))
      ),
      emailValidator: EmailValidator(
        email: () => _emailTextEditingController.text
      ),
      nameValidator: Validator(
        onValidate: () => !_nameTextEditingController.text.isEmptyString ? SuccessValidationResult() : FailedValidationResult(e: ValidationError(message: "${"Nama dibutuhkan".tr}."))
      ),
      phoneValidator: Validator(
        onValidate: () => !_phoneTextEditingController.text.isEmptyString ? SuccessValidationResult() : FailedValidationResult(e: ValidationError(message: "${"Nomor telepon dibutuhkan".tr}."))
      ),
      addressValidator: Validator(
        onValidate: () => !_addressTextEditingController.text.isEmptyString ? SuccessValidationResult() : FailedValidationResult(e: ValidationError(message: "${"Alamat dibutuhkan".tr}."))
      ),
      postalCodeValidator: Validator(
        onValidate: () => !_postalCodeTextEditingController.text.isEmptyString ? SuccessValidationResult() : FailedValidationResult(e: ValidationError(message: "${"Kode pos dibutuhkan".tr}."))
      ),
      provinceValidator: Validator(
        onValidate: () => !_provinceTextEditingController.text.isEmptyString ? SuccessValidationResult() : FailedValidationResult(e: ValidationError(message: "${"Provinsi dibutuhkan".tr}."))
      ),
      cityValidator: Validator(
        onValidate: () => !_cityTextEditingController.text.isEmptyString ? SuccessValidationResult() : FailedValidationResult(e: ValidationError(message: "${"Kota dibutuhkan".tr}."))
      ),
      subDistrictValidator: Validator(
        onValidate: () => !_subDistrictTextEditingController.text.isEmptyString ? SuccessValidationResult() : FailedValidationResult(e: ValidationError(message: "${"Kecamatan dibutuhkan".tr}."))
      ),
      villageValidator: Validator(
        onValidate: () => !_villageTextEditingController.text.isEmptyString ? SuccessValidationResult() : FailedValidationResult(e: ValidationError(message: "${"Kelurahan dibutuhkan".tr}."))
      ),
      houseValidator: Validator(
        onValidate: () => !_houseId.isEmptyString ? SuccessValidationResult() : FailedValidationResult(e: ValidationError(message: "${"Rumah dibutuhkan".tr}."))
      ),
      bookingFeeDateValidator: Validator(
        onValidate: () => _bookingFeeDate != null ? SuccessValidationResult() : FailedValidationResult(e: ValidationError(message: "${"Tanggal pembayaran dibutuhkan".tr}."))
      ),
      bookingFeePicValidator: Validator(
        onValidate: () => !_bookingFeePic.isEmptyString ? SuccessValidationResult() : FailedValidationResult(e: ValidationError(message: "${"Bukti pembayaran dibutuhkan".tr}."))
      ),
    );
    birthplaceTextFieldControllerStateRx = TextFieldControllerState(
      textEditingController: _birthplaceTextEditingController,
      validator: addCustomerValidatorGroup.birthplaceValidator
    ).obs;
    nikTextFieldControllerStateRx = TextFieldControllerState(
      textEditingController: _nikTextEditingController,
      validator: addCustomerValidatorGroup.nikValidator
    ).obs;
    emailTextFieldControllerStateRx = TextFieldControllerState(
      textEditingController: _emailTextEditingController,
      validator: addCustomerValidatorGroup.emailValidator
    ).obs;
    nameTextFieldControllerStateRx = TextFieldControllerState(
      textEditingController: _nameTextEditingController,
      validator: addCustomerValidatorGroup.nameValidator
    ).obs;
    phoneTextFieldControllerStateRx = TextFieldControllerState(
      textEditingController: _phoneTextEditingController,
      validator: addCustomerValidatorGroup.phoneValidator
    ).obs;
    addressTextFieldControllerStateRx = TextFieldControllerState(
      textEditingController: _addressTextEditingController,
      validator: addCustomerValidatorGroup.addressValidator
    ).obs;
    postalCodeTextFieldControllerStateRx = TextFieldControllerState(
      textEditingController: _postalCodeTextEditingController,
      validator: addCustomerValidatorGroup.postalCodeValidator
    ).obs;
    provinceTextFieldControllerStateRx = TextFieldControllerState(
      textEditingController: _provinceTextEditingController,
      validator: addCustomerValidatorGroup.provinceValidator
    ).obs;
    cityTextFieldControllerStateRx = TextFieldControllerState(
      textEditingController: _cityTextEditingController,
      validator: addCustomerValidatorGroup.cityValidator
    ).obs;
    subDistrictTextFieldControllerStateRx = TextFieldControllerState(
      textEditingController: _subDistrictTextEditingController,
      validator: addCustomerValidatorGroup.subDistrictValidator
    ).obs;
    villageTextFieldControllerStateRx = TextFieldControllerState(
      textEditingController: _villageTextEditingController,
      validator: addCustomerValidatorGroup.villageValidator
    ).obs;
    birthdateValidatorRx = addCustomerValidatorGroup.birthdateValidator.obs;
    houseValidatorRx = addCustomerValidatorGroup.houseValidator.obs;
    bookingFeeDateValidatorRx = addCustomerValidatorGroup.bookingFeeDateValidator.obs;
    bookingFeePicValidatorRx = addCustomerValidatorGroup.bookingFeePicValidator.obs;
  }

  void setHouseJsonMap(Map<String, dynamic> selectedHouseJsonMap) {
    _houseId = selectedHouseJsonMap["id"];
    selectedHouseWrapperRx.value = SelectedHouseWrapper(selectedHouseJsonMap: selectedHouseJsonMap);
    _updateMarketingAddCustomerController();
    addCustomerValidatorGroup.houseValidator.validate();
  }

  void setBirthdate(DateTime? birthdate) {
    _birthdate = birthdate;
    birthdateDateTimeWrapper.value = DateTimeWrapper(dateTime: birthdate);
    _updateMarketingAddCustomerController();
    addCustomerValidatorGroup.birthdateValidator.validate();
  }

  void setBookingFeeDate(DateTime? bookingFeeDate) {
    _bookingFeeDate = bookingFeeDate;
    bookingFeeDateTimeWrapper.value = DateTimeWrapper(dateTime: bookingFeeDate);
    _updateMarketingAddCustomerController();
    addCustomerValidatorGroup.bookingFeeDateValidator.validate();
  }

  void setBookingFeePic(String bookingFeePic) {
    _bookingFeePic = bookingFeePic;
    bookingFeePicFileSelectedWrapperRx.value = FileSelectedWrapper(fileSelected: _bookingFeePic);
    _updateMarketingAddCustomerController();
    addCustomerValidatorGroup.bookingFeePicValidator.validate();
  }

  void register({
    required OnUnfocusAllWidget onUnfocusAllWidget,
    // ignore: library_private_types_in_public_api
    required _OnShowRegisterRequestProcessLoadingCallback onShowRegisterRequestProcessLoadingCallback,
    // ignore: library_private_types_in_public_api
    required _OnRegisterRequestProcessSuccessCallback onRegisterRequestProcessSuccessCallback,
    // ignore: library_private_types_in_public_api
    required _OnShowRegisterRequestProcessFailedCallback onShowRegisterRequestProcessFailedCallback
  }) async {
    onUnfocusAllWidget();
    if (addCustomerValidatorGroup.validate()) {
      onShowRegisterRequestProcessLoadingCallback();
      LoadDataResult<NewCustomerResponse> registerLoadDataResult = await sourceRepository.newCustomer(
        NewCustomerParameter(
          marketingId: LoginHelper.getMarketingId().result,
          houseId: _houseId!,
          name: _nameTextEditingController.text,
          birthdate: _birthdate!,
          birthplace: _birthplaceTextEditingController.text,
          nik: _nikTextEditingController.text,
          email: _emailTextEditingController.text,
          phone: _phoneTextEditingController.text,
          address: _addressTextEditingController.text,
          postalCode: _postalCodeTextEditingController.text,
          province: _provinceTextEditingController.text,
          city: _cityTextEditingController.text,
          subDistrict: _subDistrictTextEditingController.text,
          village: _villageTextEditingController.text,
          bookingFeeDate: _bookingFeeDate!,
          bookingFeePicture: _bookingFeePic!,
          status: "r"
        )
      ).future(
        parameter: apiRequestManager.addRequestToCancellationPart('register').value
      );
      Get.back();
      if (registerLoadDataResult.isSuccess) {
        onRegisterRequestProcessSuccessCallback();
      } else {
        onShowRegisterRequestProcessFailedCallback(registerLoadDataResult.resultIfFailed);
      }
    }
  }

  void _updateMarketingAddCustomerController() {
    update();
  }

  @override
  void onClose() {
    super.onClose();
    _emailTextEditingController.dispose();
    _birthplaceTextEditingController.dispose();
    _nikTextEditingController.dispose();
    _nameTextEditingController.dispose();
    _phoneTextEditingController.dispose();
    _addressTextEditingController.dispose();
    _postalCodeTextEditingController.dispose();
    _provinceTextEditingController.dispose();
    _cityTextEditingController.dispose();
    _subDistrictTextEditingController.dispose();
    _villageTextEditingController.dispose();
  }
}

class FileSelectedWrapper {
  String? fileSelected;

  FileSelectedWrapper({
    required this.fileSelected
  });
}

class DateTimeWrapper {
  DateTime? dateTime;

  DateTimeWrapper({
    required this.dateTime
  });
}

class SelectedHouseWrapper {
  Map<String, dynamic>? selectedHouseJsonMap;

  SelectedHouseWrapper({
    required this.selectedHouseJsonMap
  });
}