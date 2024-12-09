import 'package:flutter/material.dart';
import 'package:bp_app/services/bill_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

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
        title: Text('Bills for ${widget.providerName}'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _billsFuture,
        builder: (context, snapshot) {
          // if (snapshot.connectionState == ConnectionState.waiting) {
          //   return Center(child: CircularProgressIndicator());
          // } else if (snapshot.hasError) {
          //   return Center(child: Text('Error loading bills.'));
          // } else 
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No bills found.'));
          }

          final bills = snapshot.data!;
return ListView.builder(
  itemCount: bills.length,
  itemBuilder: (context, index) {
    final bill = bills[index];
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text('Account: ${bill['accountNumber']}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Amount Due: \$${bill['amountDue'].toStringAsFixed(2)}'),
            Text('Due Date: ${DateFormat('yyyy-MM-dd').format(bill['dueDate'])}'),
            Text('Status: ${bill['paymentStatus']}'),
          ],
        ),
        trailing: Icon(
          bill['paymentStatus'] == 'Paid' ? Icons.check_circle : Icons.pending,
          color: bill['paymentStatus'] == 'Paid' ? Colors.green : Colors.orange,
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add bill screen (to be implemented)
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddBillScreen(
                providerId: widget.providerId,
                providerName: widget.providerName,
              ),
            ),
          ).then((_) {
            // Refresh bills after adding a new bill
            setState(() {
              String userId = _auth.currentUser!.uid;
              _billsFuture = _billService.getBillsByProviderAndUser(
                userId: userId,
                providerId: widget.providerId,
              );
            });
          });
        },
        child: Icon(Icons.add),
        tooltip: 'Add Bill',
      ),
    );
  }
}

// Placeholder for AddBillScreen
class AddBillScreen extends StatefulWidget {
  final String providerId;
  final String providerName;

  AddBillScreen({required this.providerId, required this.providerName});

  @override
  _AddBillScreenState createState() => _AddBillScreenState();
}

class _AddBillScreenState extends State<AddBillScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _amountDueController = TextEditingController();
  DateTime? _dueDate;
  final BillService _billService = BillService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _pickDueDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      setState(() {
        _dueDate = selectedDate;
      });
    }
  }

void _submitBill() async {
  if (_formKey.currentState!.validate() && _dueDate != null) {
    String accountNumber = _accountNumberController.text.trim();
    double amountDue = double.parse(_amountDueController.text.trim());
    DateTime dueDate = _dueDate!;

    String userId = _auth.currentUser!.uid;

    try {
      // Format the dueDate to a string
      String formattedDueDate = DateFormat('yyyy-MM-dd').format(dueDate);

      // Set a default status for the bill, e.g., "Unpaid"
      String status = 'Unpaid'; // You can change this as per your requirement

      // Call the addBill method
      await _billService.addBill(
        userId: userId,
        providerId: widget.providerId,
        categoryId: '', // You can pass categoryId dynamically if needed
        accountNumber: accountNumber,
        amountDue: amountDue,
        dueDate: formattedDueDate,
        status: status, // Make sure to pass status
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bill added successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding bill: $e')),
      );
    }
  } else if (_dueDate == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please select a due date')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Bill for ${widget.providerName}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _accountNumberController,
                decoration: InputDecoration(labelText: 'Account Number'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter account number' : null,
              ),
              TextFormField(
                controller: _amountDueController,
                decoration: InputDecoration(labelText: 'Amount Due'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter amount due';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              ListTile(
                title: Text(_dueDate != null
                    ? 'Due Date: ${DateFormat('yyyy-MM-dd').format(_dueDate!)}'
                    : 'Select Due Date'),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _pickDueDate(context),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitBill,
                child: Text('Add Bill'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
