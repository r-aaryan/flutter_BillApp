import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bp_app/models/payment.dart';
class PaymentLog {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> savePayment(Payment payment) async {
    try {
      await _firestore.collection('payments').add(payment.toMap());
    } catch (e) {
      throw Exception('Failed to save payment: $e');
    }
  }
}
