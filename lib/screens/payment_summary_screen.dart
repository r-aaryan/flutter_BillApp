// OTP ATTEMPT PERPLEX
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
  final String userId; // Add userId to pass it for fetching details

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

  void _makePayment() async {
    // Assuming you have a method to get the logged-in user's phone number

    SelectedBill.UID = FirebaseAuth.instance.currentUser!.uid;

// Fetch customer details from Firestore
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

    // String userPhoneNumber = '+91${phoneNumber}';
    String userPhoneNumber = '+911234567890';
    String currency = 'USD'; // Fetch from user data
    double totalAmount = widget.billAmount; // Fetch from user data
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => OTPScreen(
                phoneNumber: userPhoneNumber,
                currency: currency,
                totalAmount: totalAmount,
              )),
    );
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













//   Future<void> _sendOtpToEmail(String email) async {
//     try {
//       await FirebaseAuth.instance.sendSignInLinkToEmail(
//         email: email,
//         actionCodeSettings: ActionCodeSettings(
//           url: 'https://gibmesmth.page.link',
//           handleCodeInApp: true,
//           androidPackageName: 'com.example.bp_app',
//           androidInstallApp: true,
//           // iOSBundleId: 'com.example.yourapp',
//         ),
//       );
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("OTP sent to $email")),
//       );
//     } catch (e) {
//       throw Exception("Failed to send OTP: ${e.toString()}");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Payment Summary')),
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator())
//           : Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Service Provider: ${widget.serviceProvider}',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     'Debit Account: ${widget.debitAccount}',
//                     style: TextStyle(fontSize: 16),
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     'Bill Amount: ${widget.currency} ${widget.billAmount.toStringAsFixed(2)}',
//                     style: TextStyle(fontSize: 16),
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     'Applicable Fees: ${widget.currency} ${_applicableFees.toStringAsFixed(2)}',
//                     style: TextStyle(fontSize: 16),
//                   ),
//                   SizedBox(height: 16),
//                   Divider(),
//                   Text(
//                     'Total Amount: ${widget.currency} ${(widget.billAmount + _applicableFees).toStringAsFixed(2)}',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: _makePayment,
//                     child: Text('Make Payment'),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }
// }
