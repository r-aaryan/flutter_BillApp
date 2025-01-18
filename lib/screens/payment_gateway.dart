//api order
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:bp_app/services/api_service.dart';
import 'package:bp_app/screens/payment_confirmation.dart';
import 'package:bp_app/models/payment.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bp_app/models/selected_bill.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PaymentGatewayScreen extends StatefulWidget {
  final double totalAmount;
  final String currency;

  PaymentGatewayScreen({
    required this.totalAmount,
    required this.currency,
  });

  @override
  _PaymentGatewayScreenState createState() => _PaymentGatewayScreenState();
}

class _PaymentGatewayScreenState extends State<PaymentGatewayScreen> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  Future<void> updateBillStatus() async {
    // Retrieve the document ID from the singleton
    String? documentId = SelectedBill.documentId;
    String? accountNumber = SelectedBill.accountNumber;
    final String userId = FirebaseAuth.instance.currentUser!.uid;

    print('Updating Bill Status for Document ID: $documentId');
    print('Updating Bill Status for BankAccount ID: $accountNumber');

    if (documentId == null) {
      print('No bill selected for update.');
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('bills')
          .doc(documentId)
          .update({'status': 'Paid'});

      print('Bill status updated to Paid for document ID: $documentId');
    } catch (e) {
      print('Error updating bill status for document ID: $documentId, $e');
    }
  }

  // Update the bank account balance immediately
  Future<void> updateBankAccountBalance() async {
    try {
      final String? UId = SelectedBill.UID;

      if (UId == null) {
        print('Error: No user is logged in.');
        return;
      }
      if (SelectedBill.accountNumber == null) {
        print('No bank account selected for update.');
        return;
      }

      print('Try Updating balance for User ID: $UId'); //UID fetch wrong here
      final accountDoc = FirebaseFirestore.instance
          .collection('customers')
          .doc(UId)
          .collection('bankAccounts')
          .doc(SelectedBill.accountNumber);

      // final currentBalance = SelectedBill.balance;
      double currentBalance =
      double.parse(SelectedBill.balance ?? "0"); // Convert string to double

      if (currentBalance >= widget.totalAmount) {
        await accountDoc.update({
          'balance': (currentBalance - widget.totalAmount).toString()
        }); // Convert back to string
        print('Balance updated successfully.');
        SelectedBill.balance =
            (currentBalance - widget.totalAmount).toString(); // Update locally
      } else {
        print('Insufficient funds.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Insufficient balance in the selected account.")),
        );
        return; // Stop further processing
      }
    } catch (e) {
      print('Error updating bank account balance: $e');
    }
  }

  Future<void> sendTransactionEmail({
    required String recipientEmail,
    required String subject,
    required String textContent,
    // required String htmlContent,
  }) async {
    try {
      // Reference to Firestore 'mail' collection
      final mailRef = FirebaseFirestore.instance.collection('mail');

      // Add a new email document
      await mailRef.add({
        'to': recipientEmail,
        'message': {
          'subject': subject,
          'text': textContent,
          // 'html': htmlContent,
        },
      });

      print('Email scheduled for sending.');
    } catch (e) {
      print('Error sending email: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    // Extract transaction details
    String transactionId = response.paymentId ?? 'transac_id';
    DateTime transactionDate = DateTime.now();
    String providerName = 'BP_App';
    String payeeEmail = 'ar18roxx@gmail.com';
    String payeePhone = '+91-1234567890';
    double amountPaid = widget.totalAmount;
    String paymentMethod = 'Razorpay';
    String status = "Successful";

    print('Payment Successful: Transaction ID: $transactionId');
    print(
        'Selected Bill ID: ${SelectedBill.documentId}'); // Log the selected bill ID

    // Send email notification
    sendTransactionEmail(
      recipientEmail: payeeEmail, // Replace with actual email
      subject: 'Transaction Successful',
      textContent:
      'Your payment of ${widget.totalAmount} was successful. Provider: $providerName, Transaction ID: $transactionId, Date: $transactionDate, Payment Method: $paymentMethod, Status: $status, Order ID: ${response.orderId ?? 'order_id'}, Payee Phone: $payeePhone, Payee Email: $payeeEmail, Amount Paid: $amountPaid ',
    );

    await updateBankAccountBalance();

    // Update bill status
    await updateBillStatus();

    // Create Payment object
    Payment payment = Payment(
      providerName: providerName,
      payeeEmail: payeeEmail,
      payeePhone: payeePhone,
      amountPaid: amountPaid,
      orderId: response.orderId ?? '',
      transactionId: transactionId,
      transactionDate: transactionDate,
      paymentMethod: paymentMethod,
      status: status,
    );

    // Save payment details in Firestore
    ApiService().savePayment(payment).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment logged successfully!")),
      );

      // Navigate to Payment Confirmation Screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentConfirmationScreen(
            providerName: providerName,
            payeeEmail: payeeEmail,
            payeePhone: payeePhone,
            amountPaid: amountPaid,
            orderId: response.orderId ?? 'order_id',
            transactionId: transactionId,
            transactionDate: transactionDate,
            paymentMethod: paymentMethod,
          ),
        ),
      );
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment Failed: ${response.message}")),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("External Wallet Used: ${response.walletName}")),
    );
  }

  void openCheckout() async {
    ApiService apiService = ApiService();

    try {
      String orderId = await apiService.createOrder(widget.totalAmount.toInt());

      var options = {
        'key': 'rzp_test_1KkBp1mnCHf6B5', // Replace with your Razorpay Key ID
        'amount': (widget.totalAmount * 100).toString(), // Amount in paise
        'currency': widget.currency,
        'name': 'BP_App',
        'description': 'Payment for services',
        'order_id': orderId, // Use the generated order ID here
        'prefill': {
          'contact': '1234567890', // User's phone number (optional)
          'email': 'user@example.com', // User's email (optional)
        },
        'theme': {'color': '#F37254'},
      };

      _razorpay.open(options);
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear(); // Clear the Razorpay instance when not needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payment Gateway',
          style: TextStyle(color: Colors.white), // Set heading font color to white
        ),
        backgroundColor: Color(0xFF0B2A5E), // AppBar background color
        // centerTitle: true, // Center the title
        iconTheme: IconThemeData(color: Colors.white), // Set icon color to white
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Outer padding for the entire body
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16.0), // Inner padding for the container
              decoration: BoxDecoration(
                color: Colors.white, // Set container background color
                borderRadius: BorderRadius.circular(12), // Rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Shadow color
                    spreadRadius: 2,
                    blurRadius: 6,
                    offset: Offset(0, 3), // Shadow offset
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Wraps content
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Amount to Pay',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0B2A5E), // Heading font color
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    '${widget.currency} ${widget.totalAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Text color for amount
                    ),
                  ),
                  SizedBox(height: 40),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF0B2A5E), // Button background color
                      padding: EdgeInsets.symmetric(vertical: 16.0), // Button padding
                      textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: openCheckout,
                    child: Center(
                      child: Text(
                        'Proceed to Payment',
                        style: TextStyle(color: Colors.white), // Button text color
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}