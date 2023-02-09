class NewCustomerParameter {
  String marketingId;
  String houseId;
  String name;
  DateTime birthdate;
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
  String status;

  NewCustomerParameter({
    required this.marketingId,
    required this.houseId,
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