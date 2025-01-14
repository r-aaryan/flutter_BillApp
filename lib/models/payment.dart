class Payment {
  final String providerName;
  final String payeeEmail;
  final String payeePhone;
  final double amountPaid;
  final String orderId;
  final String transactionId;
  final DateTime transactionDate;
  final String paymentMethod;
  final String status;

  Payment({
    required this.providerName,
    required this.payeeEmail,
    required this.payeePhone,
    required this.amountPaid,
    required this.orderId,
    required this.transactionId,
    required this.transactionDate,
    required this.paymentMethod,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'providerName': providerName,
      'payeeEmail': payeeEmail,
      'payeePhone': payeePhone,
      'amountPaid': amountPaid,
      'orderId': orderId,
      'transactionId': transactionId,
      'transactionDate': transactionDate.toIso8601String(),
      'paymentMethod': paymentMethod,
      'status': status,
    };
  }
}
