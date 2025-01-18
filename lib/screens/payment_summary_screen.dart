import 'package:bp_app/models/selected_bill.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'otp_screen.dart';

class PaymentSummaryScreen extends StatefulWidget {
  final String serviceProvider;
  final String debitAccount;
  final double billAmount;
  final String currency;
  final String userId;

  PaymentSummaryScreen({
    required this.serviceProvider,
    required this.debitAccount,
    required this.billAmount,
    required this.currency,
    required this.userId,
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

    if (widget.billAmount <= 0 || widget.currency.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid payment details provided.")),
      );
      Navigator.pop(context);
    } else {
      _fetchPaymentSummary();
    }
  }

  Future<void> _fetchPaymentSummary() async {
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _applicableFees = widget.billAmount * 0.00; // Example: 0% fee
      _isLoading = false;
    });
  }

  void _makePayment() async {
    SelectedBill.UID = FirebaseAuth.instance.currentUser!.uid;

    final customerDoc = await FirebaseFirestore.instance
        .collection('customers')
        .doc(widget.userId)
        .get();

    if (!customerDoc.exists) {
      throw Exception("Customer details not found.");
    }

    final customerData = customerDoc.data();
    final email = customerData?['email'];
    final phoneNumber = customerData?['phoneNumber'];

    if (email == null && phoneNumber == null) {
      throw Exception("No contact details available.");
    }

    String userPhoneNumber = '+911234567890';
    String currency = 'INR';
    double totalAmount = widget.billAmount;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OTPScreen(
          phoneNumber: userPhoneNumber,
          currency: currency,
          totalAmount: totalAmount,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0B2A5E), // Heading background color
        title: Text(
          'Payment Summary',
          style: TextStyle(
            color: Colors.white, // Font color
            fontFamily: 'Poppins', // Font style
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white), // Icon color
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white, // Container background color
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3), // Shadow position
                ),
              ],
            ),
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Service Provider: ${widget.serviceProvider}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins', // Font style
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Debit Account: ${widget.debitAccount}',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins', // Font style
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Bill Amount: ${widget.currency} ${widget.billAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins', // Font style
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Applicable Fees: ${widget.currency} ${_applicableFees.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins', // Font style
                  ),
                ),
                SizedBox(height: 16),
                Divider(),
                Text(
                  'Total Amount: ${widget.currency} ${(widget.billAmount + _applicableFees).toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins', // Font style
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _makePayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF0B2A5E), // Button color
                    ),
                    child: Text(
                      'Make Payment',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white, // Font color
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
