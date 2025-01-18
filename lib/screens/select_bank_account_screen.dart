import 'package:flutter/material.dart';
import 'package:bp_app/services/bank_account_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bp_app/screens/bill_payment_screen.dart';
import 'package:bp_app/models/selected_bill.dart'; // Import the SelectedBill class

class SelectBankAccountScreen extends StatefulWidget {
  final Map<String, dynamic> billDetails;

  SelectBankAccountScreen({
    required this.billDetails,
  });

  @override
  _SelectBankAccountScreenState createState() =>
      _SelectBankAccountScreenState();
}

class _SelectBankAccountScreenState extends State<SelectBankAccountScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final BankAccountService _bankAccountService = BankAccountService();
  late Future<List<Map<String, dynamic>>> _accountsFuture;
  String? _selectedAccountId;

  @override
  void initState() {
    super.initState();
    String userId = _auth.currentUser!.uid;
    _accountsFuture = _bankAccountService.getBankAccountsByUserId(userId);
  }

  void _confirmSelection() async {
    if (_selectedAccountId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a bank account.')),
      );
    } else {
      try {
        final accounts = await _accountsFuture;
        final selectedAccount = accounts.firstWhere(
              (account) => account['accountId'] == _selectedAccountId,
        );

        // Save the selected account details in the singleton
        SelectedBill.accountNumber = _selectedAccountId;
        SelectedBill.balance = selectedAccount['balance'].toString();
        SelectedBill.currency = selectedAccount['currency'];

        // Navigate to the next screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BillPaymentScreen(
              accountId: selectedAccount['accountId'],
              currency: selectedAccount['currency'],
              billDetails: widget.billDetails,
            ),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error selecting account. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select Bank Account',
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
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _accountsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error loading accounts.'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No bank accounts found.'));
            }

            final accounts = snapshot.data!;
            return ListView.builder(
              itemCount: accounts.length,
              itemBuilder: (context, index) {
                final account = accounts[index];
                return Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.white, // White background
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3), // Shadow position
                      ),
                    ],
                  ),
                  child: RadioListTile<String>(
                    value: account['accountId'],
                    groupValue: _selectedAccountId,
                    title: Text(
                      'Account: ${account['accountNumber']}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, // Make heading bold
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Currency: ${account['currency']}'),
                        Text(
                          'Balance: ₹${double.parse(account['balance'].toString()).toStringAsFixed(2)}',
                        ),
                      ],
                    ),
                    onChanged: (value) {
                      setState(() {
                        _selectedAccountId = value;
                      });
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _confirmSelection,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF0B2A5E), // Dark blue button background
          ),
          child: Text(
            'Confirm Selection',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.white, // White text color for the button
            ),
          ),
        ),
      ),
    );
  }
}
