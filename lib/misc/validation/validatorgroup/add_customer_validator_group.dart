import '../validator/validator.dart';
import 'validator_group.dart';

class AddCustomerValidatorGroup extends ValidatorGroup {
  Validator birthdateValidator;
  Validator birthplaceValidator;
  Validator nikValidator;
  Validator emailValidator;
  Validator nameValidator;
  Validator phoneValidator;
  Validator addressValidator;
  Validator postalCodeValidator;
  Validator provinceValidator;
  Validator cityValidator;
  Validator subDistrictValidator;
  Validator villageValidator;
  Validator houseValidator;
  Validator bookingFeeDateValidator;
  Validator bookingFeePicValidator;

  AddCustomerValidatorGroup({
    required this.birthdateValidator,
    required this.birthplaceValidator,
    required this.nikValidator,
    required this.emailValidator,
    required this.nameValidator,
    required this.phoneValidator,
    required this.addressValidator,
    required this.postalCodeValidator,
    required this.provinceValidator,
    required this.cityValidator,
    required this.subDistrictValidator,
    required this.villageValidator,
    required this.houseValidator,
    required this.bookingFeeDateValidator,
    required this.bookingFeePicValidator,
  }) {
    validatorList.add(birthdateValidator);
    validatorList.add(birthplaceValidator);
    validatorList.add(nikValidator);
    validatorList.add(emailValidator);
    validatorList.add(nameValidator);
    validatorList.add(phoneValidator);
    validatorList.add(addressValidator);
    validatorList.add(postalCodeValidator);
    validatorList.add(provinceValidator);
    validatorList.add(cityValidator);
    validatorList.add(subDistrictValidator);
    validatorList.add(villageValidator);
    validatorList.add(houseValidator);
    validatorList.add(bookingFeeDateValidator);
    validatorList.add(bookingFeePicValidator);
  }
}