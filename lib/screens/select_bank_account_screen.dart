
//selectBankAccountScreen PERSISTENT

import 'package:flutter/material.dart';
import 'package:bp_app/services/bank_account_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bp_app/screens/bill_payment_screen.dart';
import 'package:bp_app/models/selected_bill.dart'; // Import the SelectedBankAccount class

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
      // Find the selected account details
      try {
        final accounts = await _accountsFuture;
        final selectedAccount = accounts.firstWhere(
          (account) => account['accountId'] == _selectedAccountId,
        );

        // Save the selected account details in the singleton
        SelectedBill.accountNumber = _selectedAccountId;
        SelectedBill.balance = selectedAccount['balance'].toString();
        SelectedBill.currency = selectedAccount['currency'];

        print('Selected Bank Account: ${SelectedBill.accountNumber}');
        print('Balance: ${SelectedBill.balance}');
        print('Currency: ${SelectedBill.currency}');

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
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Bank Account'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
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
              return RadioListTile<String>(
                value: account['accountId'],
                groupValue: _selectedAccountId,
                title: Text('Account: ${account['accountNumber']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Currency: ${account['currency']}'),
                    Text(
                      'Balance: \$${double.parse(account['balance'].toString()).toStringAsFixed(2)}',
                    ),
                  ],
                ),
                onChanged: (value) {
                  setState(() {
                    _selectedAccountId = value;
                  });
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _confirmSelection,
          child: Text('Confirm Selection'),
        ),
      ),
    );
  }
}
