import '../installment_status.dart';
import '../user/user.dart';

class Customer {
  String id;
  String userId;
  String marketingId;
  String houseId;
  String terminId;
  String name;
  String birthdate;
  String birthplace;
  String nik;
  String email;
  String phone;
  String address;
  String postalCode;
  String province;
  String city;
  String subDistrict;
  String village;
  DateTime bookingFeeDate;
  String bookingFeePicture;
  InstallmentStatus status;

  Customer({
    required this.id,
    required this.userId,
    required this.marketingId,
    required this.houseId,
    required this.terminId,
    required this.name,
    required this.birthdate,
    required this.birthplace,
    required this.nik,
    required this.email,
    required this.phone,
    required this.address,
    required this.postalCode,
    required this.province,
    required this.city,
    required this.subDistrict,
    required this.village,
    required this.bookingFeeDate,
    required this.bookingFeePicture,
    required this.status
  });
}

class CustomerWithLoggedUser extends Customer {
  User loggedUser;

  CustomerWithLoggedUser({
    required this.loggedUser,
    required super.id,
    required super.userId,
    required super.marketingId,
    required super.houseId,
    required super.terminId,
    required super.name,
    required super.birthdate,
    required super.birthplace,
    required super.nik,
    required super.email,
    required super.phone,
    required super.address,
    required super.postalCode,
    required super.province,
    required super.city,
    required super.subDistrict,
    required super.village,
    required super.bookingFeeDate,
    required super.bookingFeePicture,
    required super.status
  });
}