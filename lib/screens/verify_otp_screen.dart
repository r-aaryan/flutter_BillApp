import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String contactMethod; // Email or mobile
  final bool isEmail; // True for email-based OTP

  VerifyOtpScreen({required this.contactMethod, required this.isEmail});

  @override
  _VerifyOtpScreenState createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _isVerifying = false;

  void _verifyOtp() async {
    setState(() {
      _isVerifying = true;
    });

    try {
      if (widget.isEmail) {
        // Check if the email link is valid
        await FirebaseAuth.instance.signInWithEmailLink(
          email: widget.contactMethod,
          emailLink: _otpController.text.trim(),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("OTP Verified Successfully!")),
        );
        // Navigate to next screen
        Navigator.pop(context);
      } else {
        // Mobile-based OTP handling (if added later)
        throw Exception("Mobile OTP verification not implemented.");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid OTP: ${e.toString()}")),
      );
    } finally {
      setState(() {
        _isVerifying = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Verify OTP")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("OTP sent to: ${widget.contactMethod}"),
            SizedBox(height: 16),
            TextField(
              controller: _otpController,
              decoration: InputDecoration(labelText: "Enter OTP/Email Link"),
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 20),
            _isVerifying
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _verifyOtp,
                    child: Text("Verify"),
                  ),
          ],
        ),
      ),
    );
  }
}
