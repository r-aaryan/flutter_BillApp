// import 'package:flutter/material.dart';

// class PaymentGatewayScreen extends StatelessWidget {
//   final double totalAmount;
//   final String currency;

//   PaymentGatewayScreen({
//     required this.totalAmount,
//     required this.currency,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Payment Gateway')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Amount to Pay',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 20),
//             Text(
//               '$currency ${totalAmount.toStringAsFixed(2)}',
//               style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 40),
//             ElevatedButton(
//               onPressed: () {
//                 // Implement payment processing logic here
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('Payment processing...')),
//                 );
//               },
//               child: Text('Proceed to Payment'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//RAZORPAY

import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

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

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Handle successful payment here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment Successful: ${response.paymentId}")),
    );
    // Navigate or perform any other action after success
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Handle payment failure here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment Failed: ${response.message}")),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet here (if applicable)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("External Wallet Used: ${response.walletName}")),
    );
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_1KkBp1mnCHf6B5', // Replace with your Razorpay Key ID
      'amount': (widget.totalAmount * 100).toString(), // Amount in paise
      'currency': widget.currency,
      'name': 'BP_App',
      'description': 'Payment for services',
      'prefill': {
        'contact': '1234567890', // User's phone number (optional)
        'email': 'user@example.com', // User's email (optional)
      },
      'theme': {'color': '#F37254'},

      'method': {
        'upi': true, // Enable UPI option
        'netbanking': true, // Enable net banking option
        'card': true, // Enable card option
        'wallets': true, // Enable wallets option
      },

      



    };

    try {
       _razorpay.open(options);
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error opening Razorpay Checkout")),
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
      appBar: AppBar(title: Text('Payment Gateway')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Amount to Pay',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              '${widget.currency} ${widget.totalAmount.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: openCheckout,
              child: Text('Proceed to Payment'),
            ),
          ],
        ),
      ),
    );
  }
}
