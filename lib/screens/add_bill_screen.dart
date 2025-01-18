import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bp_app/services/bill_service.dart';

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
      String userId = _auth.currentUser!.uid;

      try {
        await _billService.addBill(
          userId: userId,
          providerId: widget.providerId,
          categoryId: '', // Add categoryId if needed
          accountNumber: accountNumber,
          amountDue: amountDue,
          dueDate: DateFormat('yyyy-MM-dd').format(_dueDate!),
          status: 'Unpaid',
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
      appBar: AppBar(
        title: Text(
          'Add Bill for ${widget.providerName}',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF0B2A5E),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _accountNumberController,
                decoration: InputDecoration(
                  labelText: 'Account Number',
                  labelStyle: TextStyle(
                    fontFamily: 'Poppins',
                  ),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter account number'
                    : null,
              ),
              TextFormField(
                controller: _amountDueController,
                decoration: InputDecoration(
                  labelText: 'Amount Due',
                  labelStyle: TextStyle(
                    fontFamily: 'Poppins',
                  ),
                ),
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
                title: Text(
                  _dueDate != null
                      ? 'Due Date: ${DateFormat('yyyy-MM-dd').format(_dueDate!)}'
                      : 'Select Due Date',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                  ),
                ),
                trailing: Icon(
                  Icons.calendar_today,
                  color: Color(0xFF0B2A5E),
                ),
                onTap: () => _pickDueDate(context),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitBill,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0B2A5E), // Correct parameter for background color
                ),
                child: Text(
                  'Add Bill',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
