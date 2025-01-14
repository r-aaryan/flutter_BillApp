import 'package:cloud_firestore/cloud_firestore.dart';

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
