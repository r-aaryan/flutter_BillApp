class BankAccount {
  final String accountNumber;
  final String currency;
  final double balance;

  BankAccount({
    required this.accountNumber,
    required this.currency,
    required this.balance,
  });

  // Convert a BankAccount instance to a map to store it in Firestore
  Map<String, dynamic> toMap() {
    return {
      'accountNumber': accountNumber,
      'currency': currency,
      'balance': balance,
    };
  }

  // Convert a map from Firestore to a BankAccount instance
  factory BankAccount.fromMap(Map<String, dynamic> map) {
    return BankAccount(
      accountNumber: map['accountNumber'] ?? '',
      currency: map['currency'] ?? '',
      balance: map['balance'] ?? 0.0,
    );
  }

  @override
  String toString() {
    return 'Account Number: $accountNumber, Currency: $currency, Balance: $balance';
  }
}
