import 'package:flutter/material.dart';
import '../models/bank_account.dart';
class PaymentScreen extends StatelessWidget {
  final BankAccount account;

  PaymentScreen({required this.account});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Payment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('Account: ${account.accountNumber}'),
            Text('Currency: ${account.currency}'),
            Text('Balance: \INR${account.balance.toStringAsFixed(2)}'), //CC
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle the payment logic here
              },
              child: Text('Pay Bill'),
            ),
          ],
        ),
      ),
    );
  }
}
