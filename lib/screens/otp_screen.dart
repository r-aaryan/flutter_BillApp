import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      appBar: AppBar(
        title: Text(
          'Enter OTP',
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
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'A verification code has been sent to ${widget.phoneNumber}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 20),
              if (otpSent)
                TextField(
                  onChanged: (value) {
                    otp = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Enter OTP',
                    labelStyle: TextStyle(
                      fontFamily: 'Poppins',
                    ),
                    border: OutlineInputBorder(),
                  ),
                  textAlign: TextAlign.center,
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: otpSent ? verifyOTP : sendOTP,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0B2A5E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  otpSent ? 'Verify OTP' : 'Send OTP',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white, // White text color
                  ),
                ),
              ),
              SizedBox(height: 10),
              if (isLoading) CircularProgressIndicator(),
              if (feedbackMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    feedbackMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red,
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
