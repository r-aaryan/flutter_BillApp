import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bp_app/services/bill_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'select_bank_account_screen.dart';
import 'package:bp_app/screens/add_bill_screen.dart';

class BillsScreen extends StatefulWidget {
  final String providerId;
  final String providerName;

  BillsScreen({required this.providerId, required this.providerName});

  @override
  _BillsScreenState createState() => _BillsScreenState();
}

class _BillsScreenState extends State<BillsScreen> {
  final BillService _billService = BillService();
  late Future<List<Map<String, dynamic>>> _billsFuture;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    String userId = _auth.currentUser!.uid;
    _billsFuture = _billService.getBillsByProviderAndUser(
      userId: userId,
      providerId: widget.providerId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0B2A5E), // Dark blue background
        iconTheme: IconThemeData(
          color: Colors.white, // Set icon color to white
        ),
        title: Text(
          'Bills for ${widget.providerName}',
          style: TextStyle(
            fontFamily: 'Poppins', // Set font to Poppins
            color: Colors.white, // White text color
          ),
        ),
      ),
      body: DefaultTextStyle(
        style: TextStyle(
          fontFamily: 'Poppins', // Set default font to Poppins
          fontSize: 16, // Base font size
          color: Colors.black, // Default text color
        ),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _billsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error loading bills.',
                  style: TextStyle(color: Colors.red), // Highlight error in red
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No bills found.'));
            }

            final bills = snapshot.data!;
            return ListView.builder(
              itemCount: bills.length,
              itemBuilder: (context, index) {
                final bill = bills[index];

                // Convert dueDate to DateTime if it's a string
                DateTime dueDate;
                if (bill['dueDate'] is String) {
                  dueDate = DateFormat('yyyy-MM-dd').parse(bill['dueDate']);
                } else {
                  dueDate = bill['dueDate'];
                }

                final formattedDate = DateFormat('yyyy-MM-dd').format(dueDate);

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(
                      'Account: ${bill['accountNumber']}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Amount Due: \$${bill['amountDue'].toStringAsFixed(2)}'),
                        Text('Due Date: $formattedDate'),
                        Text('Status: ${bill['paymentStatus']}'),
                      ],
                    ),
                    trailing: Icon(
                      bill['paymentStatus'] == 'Paid'
                          ? Icons.check_circle
                          : Icons.pending,
                      color: bill['paymentStatus'] == 'Paid'
                          ? Colors.green
                          : Colors.orange,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SelectBankAccountScreen(
                            billDetails: bill,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddBillScreen(
                providerId: widget.providerId,
                providerName: widget.providerName,
              ),
            ),
          ).then((_) {
            setState(() {
              String userId = _auth.currentUser!.uid;
              _billsFuture = _billService.getBillsByProviderAndUser(
                userId: userId,
                providerId: widget.providerId,
              );
            });
          });
        },
        backgroundColor: Colors.blue[900], // Match FAB with AppBar color
        foregroundColor: Colors.white, // Set the FAB icon color to white
        child: Icon(Icons.add),
        tooltip: 'Add Bill',
      ),
    );
  }
}
