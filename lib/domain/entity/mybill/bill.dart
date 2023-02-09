class Bill {
  String id;
  String customerId;
  String terminId;
  String houseType;
  DateTime schemeDate;
  String schemeName;
  String schemeNominal;
  String status;
  String paymentId;
  DateTime? paidDate;

  Bill({
    required this.id,
    required this.customerId,
    required this.terminId,
    required this.houseType,
    required this.schemeDate,
    required this.schemeName,
    required this.schemeNominal,
    required this.status,
    required this.paymentId,
    required this.paidDate
  });
}