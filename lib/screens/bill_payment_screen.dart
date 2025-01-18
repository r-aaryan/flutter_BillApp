import 'package:flutter/material.dart';
import 'package:bp_app/screens/payment_summary_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BillPaymentScreen extends StatefulWidget {
  final String accountId;
  final String currency;
  final Map<String, dynamic> billDetails;

  BillPaymentScreen({
    required this.accountId,
    required this.currency,
    required this.billDetails,
  });

  @override
  _BillPaymentScreenState createState() => _BillPaymentScreenState();
}

class _BillPaymentScreenState extends State<BillPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    double? amountDue = widget.billDetails['amountDue'];
    if (amountDue != null) {
      _amountController.text = amountDue.toStringAsFixed(2);
    }
  }

  void _submitPayment() {
    if (_formKey.currentState!.validate()) {
      double amount = double.parse(_amountController.text.trim());

      final serviceProvider = widget.billDetails['providerName'] ?? "Bill Info";
      final debitAccount =
      widget.accountId.isNotEmpty ? widget.accountId : "Unknown Account";
      final currency = widget.currency.isNotEmpty ? widget.currency : "INR";

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentSummaryScreen(
            serviceProvider: serviceProvider,
            debitAccount: debitAccount,
            billAmount: amount,
            currency: currency,
            userId: FirebaseAuth.instance.currentUser!.uid,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double? amountDue = widget.billDetails['amountDue'];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bill Payment',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.white, // White font color
          ),
        ),
        backgroundColor: Color(0xFF0B2A5E), // Dark blue background
        iconTheme: IconThemeData(
          color: Colors.white, // White icon color
        ),
      ),
      body: DefaultTextStyle(
        style: TextStyle(
          fontFamily: 'Poppins', // Set default font to Poppins
          fontSize: 16, // Base font size
          color: Colors.black, // Default text color
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                // mainAxisSize: MainAxisSize.min, // Center content vertically
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (amountDue != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0, top: 16.0), // Top padding added
                      child: Text(
                        'Amount Due: ${amountDue.toStringAsFixed(2)} ${widget.currency}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0), // Top padding added
                    child: TextFormField(
                      controller: _amountController,
                      keyboardType:
                      TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: 'Enter Bill Amount',
                        prefixText: '${widget.currency} ',
                        labelStyle: TextStyle(
                          fontFamily: 'Poppins', // Set the font to Poppins
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a valid amount';
                        }
                        if (double.tryParse(value) == null ||
                            double.parse(value) <= 0) {
                          return 'Amount must be greater than zero';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: _submitPayment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        Color(0xFF0B2A5E), // Dark blue button background
                      ),
                      child: Text(
                        'Proceed to Payment',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white, // White text color
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
