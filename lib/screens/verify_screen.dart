import 'package:flutter/material.dart';

class VerifyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Verify Payment')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Add your payment processing logic here
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Payment verified and processed successfully!')),
            );
          },
          child: Text('Process Payment'),
        ),
      ),
    );
  }
}
