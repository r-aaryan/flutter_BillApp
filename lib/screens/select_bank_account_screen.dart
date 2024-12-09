import 'package:flutter/material.dart';
import '../models/bank_account.dart';
import '../services/bank_account_service.dart';
import 'payment_screen.dart';

class SelectBankAccountScreen extends StatefulWidget {
  @override
  _SelectBankAccountScreenState createState() => _SelectBankAccountScreenState();
}

class _SelectBankAccountScreenState extends State<SelectBankAccountScreen> {
  final BankAccountService _bankAccountService = BankAccountService();
  late Future<List<BankAccount>> _accounts;
  BankAccount? _selectedAccount;

  @override
  void initState() {
    super.initState();
    // Assuming the user ID is fetched from Firebase Authentication
    final String userId = "user_uid";  // Replace with the actual user ID
    _accounts = _bankAccountService.fetchUserAccounts(userId);
  }

  void _onAccountSelected(BankAccount account) {
    setState(() {
      _selectedAccount = account;
    });
  }

  void _proceedToPayment() {
    if (_selectedAccount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a bank account')),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PaymentScreen(account: _selectedAccount!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Bank Account')),
      body: FutureBuilder<List<BankAccount>>(
        future: _accounts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching accounts'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No accounts found'));
          }

          final accounts = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Select an account to debit the bill from:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: accounts.length,
                    itemBuilder: (context, index) {
                      final account = accounts[index];
                      return ListTile(
                        title: Text('Account: ${account.accountNumber}'),
                        subtitle: Text(
                            '${account.currency} ${account.balance.toStringAsFixed(2)}'),
                        trailing: _selectedAccount == account
                            ? Icon(Icons.check_circle, color: Colors.green)
                            : null,
                        onTap: () => _onAccountSelected(account),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _proceedToPayment,
                  child: Text('Proceed to Payment'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
