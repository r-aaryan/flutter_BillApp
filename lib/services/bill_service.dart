  import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BillService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Fetch categories from Firestore
  Future<List<Map<String, dynamic>>> getCategories() async {
    try {
      QuerySnapshot snapshot = await _db.collection('categories').get();
      return snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'name': doc['name'],
          'icon': doc['icon'],
        };
      }).toList();
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }

  /// Fetch providers by category ID
  Future<List<Map<String, dynamic>>> getProvidersByCategoryId(
      String categoryId) async {
    try {
      QuerySnapshot snapshot = await _db
          .collection('providers')
          .where('categoryId', isEqualTo: categoryId)
          .get();
      return snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'name': doc['name'],
          'contact': doc['contact'], // Assuming providers have a contact field
        };
      }).toList();
    } catch (e) {
      print('Error fetching providers: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getBillsByProviderAndUser({
    required String providerId,
    required String userId,
  }) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('bills')
          .where('providerId', isEqualTo: providerId)
          .where('userId', isEqualTo: userId)
          .get();

      return snapshot.docs.map((doc) {
        return {
          'documentId': doc.id, // Include the document ID
          'accountNumber': doc['accountNumber'],
          'amountDue': doc['amountDue'],
          'dueDate': DateTime.parse(doc['dueDate']), // Parse to DateTime
          'paymentStatus':
              doc['status'], // Match the field "status" in Firestore
        };
      }).toList();
    } catch (e) {
      print('Error fetching bills: $e');
      return [];
    }
  }

  // Add bill
  Future<void> addBill({
    required String userId,
    required String providerId,
    required String categoryId,
    required String accountNumber,
    required double amountDue,
    required String dueDate,
    required String status,
  }) async {
    try {
      await _db.collection('bills').add({
        'userId': userId, // The user associated with the bill
        'providerId': providerId, // The provider the bill is for
        'categoryId': categoryId, // The category ID, if available
        'accountNumber': accountNumber, // Account number for the bill
        'amountDue': amountDue, // The amount for the bill
        'dueDate': dueDate, // The due date for the bill (formatted as a string)
        'status': status, // The status of the bill (Paid/Unpaid)
        'createdAt': FieldValue
            .serverTimestamp(), // Timestamp of when the bill is created
      });
      print('Bill added successfully');
    } catch (e) {
      print('Error adding bill: $e');
    }
  }
}
