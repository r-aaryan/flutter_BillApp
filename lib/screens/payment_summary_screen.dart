import 'package:flutter/material.dart';

class PaymentSummaryScreen extends StatefulWidget {
  final String serviceProvider;
  final String debitAccount;
  final double billAmount;
  final String currency;

  PaymentSummaryScreen({
    required this.serviceProvider,
    required this.debitAccount,
    required this.billAmount,
    required this.currency,
  });

  @override
  _PaymentSummaryScreenState createState() => _PaymentSummaryScreenState();
}

class _PaymentSummaryScreenState extends State<PaymentSummaryScreen> {
  double _applicableFees = 0.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    // Ensure non-null initialization
    if (widget.billAmount <= 0 || widget.currency.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid payment details provided.")),
      );
      Navigator.pop(context); // Return to the previous screen if invalid
    } else {
      _fetchPaymentSummary();
    }
  }

  Future<void> _fetchPaymentSummary() async {
    // Simulate API delay
    await Future.delayed(Duration(seconds: 2));

    // Simulated fee calculation
    setState(() {
      _applicableFees = widget.billAmount * 0.02; // Example: 2% fee
      _isLoading = false;
    });
  }

  void _makePayment() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              'Payment of ${widget.currency} ${(widget.billAmount + _applicableFees).toStringAsFixed(2)} made successfully!')),
    );
    // Implement actual payment logic or navigation
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Payment Summary')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Service Provider: ${widget.serviceProvider}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Debit Account: ${widget.debitAccount}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Bill Amount: ${widget.currency} ${widget.billAmount.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Applicable Fees: ${widget.currency} ${_applicableFees.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Divider(),
                  Text(
                    'Total Amount: ${widget.currency} ${(widget.billAmount + _applicableFees).toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _makePayment,
                    child: Text('Make Payment'),
                  ),
                ],
              ),
            ),
    );
  }
}
