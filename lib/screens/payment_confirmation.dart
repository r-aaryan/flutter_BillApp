import 'package:bp_app/models/selected_bill.dart';
import 'package:flutter/material.dart';

class PaymentConfirmationScreen extends StatelessWidget {
  final String providerName;
  final String payeeEmail;
  final String payeePhone;
  final double amountPaid;
  final String orderId;
  final String transactionId;
  final DateTime transactionDate;
  final String paymentMethod;

  PaymentConfirmationScreen({
    required this.providerName,
    required this.payeeEmail,
    required this.payeePhone,
    required this.amountPaid,
    required this.orderId,
    required this.transactionId,
    required this.transactionDate,
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Payment Confirmation')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Success Image
            Center(
              child: Image.asset(
                'assets/success.png', // Your success image path
                height: 100,
                width: 100,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Payment Successful!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            _buildDetailRow('Provider Name:', providerName),
            _buildDetailRow('Payee Email:', payeeEmail),
            _buildDetailRow('Payee Phone:', payeePhone),
            _buildDetailRow('Amount Paid:', '₹${amountPaid.toStringAsFixed(2)}'),
            _buildDetailRow('Order ID:', orderId),
            _buildDetailRow('Transaction ID:', transactionId),
            _buildDetailRow('Date & Time:', '${transactionDate.toLocal()}'),
            _buildDetailRow('Payment Method:', paymentMethod),

            SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  SelectedBill.clear(); // Clear selected bank account
                  Navigator.popUntil(context, ModalRoute.withName('/categories')); // Navigate back to home
                },
                child: Text('Go Home'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(title)),
          Expanded(child: Text(value, textAlign: TextAlign.end)),
        ],
      ),
    );
  }
}

