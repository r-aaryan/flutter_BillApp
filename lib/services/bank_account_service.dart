
import 'package:cloud_firestore/cloud_firestore.dart';

class BankAccountService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getBankAccountsByUserId(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('customers')
          .doc(userId)
          .collection('bankAccounts')
          .get();

      return querySnapshot.docs.map((doc) {
        return {
          'accountId': doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
      }).toList();
    } catch (e) {
      throw Exception("Failed to fetch bank accounts: $e");
    }
  }
}
