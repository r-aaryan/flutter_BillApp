import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'payment_summary_screen.dart';
import 'payment_gateway.dart';
class OTPScreen extends StatefulWidget {
  final String phoneNumber;
  final double totalAmount;
  final String currency;

  OTPScreen({
    required this.phoneNumber,
    required this.totalAmount,
    required this.currency,
  });

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? verificationId;
  String otp = '';
  bool otpSent = false;
  bool isLoading = false;
  String feedbackMessage = '';

  @override
  void initState() {
    super.initState();
    sendOTP(); // Automatically send OTP when screen is initialized
  }

  void sendOTP() async {
    setState(() {
      isLoading = true;
      feedbackMessage = '';
    });

    await _auth.verifyPhoneNumber(
      phoneNumber: widget.phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        // Navigate to payment gateway or next screen
        navigateToPaymentGateway();
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() {
          feedbackMessage = e.message ?? 'Verification failed';
          isLoading = false;
        });
      },
      codeSent: (String verId, int? resendToken) {
        setState(() {
          verificationId = verId;
          otpSent = true; // OTP has been sent
          isLoading = false;
          feedbackMessage = 'OTP sent successfully!';
        });
      },
      codeAutoRetrievalTimeout: (String verId) {
        verificationId = verId;
      },
    );
  }

  void verifyOTP() async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId!, smsCode: otp);
      await _auth.signInWithCredential(credential);
      // Navigate to payment gateway or next screen
      navigateToPaymentGateway();
    } catch (e) {
      setState(() {
        feedbackMessage = 'Incorrect OTP. Please try again.';
      });
    }
  }

  void navigateToPaymentGateway() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentGatewayScreen(
          totalAmount: widget.totalAmount,
          currency: widget.currency,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Enter OTP')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('A verification code has been sent to ${widget.phoneNumber}'),
            if (otpSent)
              TextField(
                onChanged: (value) {
                  otp = value;
                },
                decoration: InputDecoration(labelText: 'Enter OTP'),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: otpSent ? verifyOTP : sendOTP,
              child: Text(otpSent ? 'Verify OTP' : 'Send OTP'),
            ),
            SizedBox(height: 20),
            if (isLoading) CircularProgressIndicator(),
            if (feedbackMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  feedbackMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
