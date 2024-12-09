import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/bank_account.dart';

class BankAccountService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Fetch all bank accounts for the logged-in user from Firestore
  Future<List<BankAccount>> fetchUserAccounts(String userId) async {
    try {
      // Assuming there is a collection 'bankAccounts' for each user
      QuerySnapshot snapshot = await _db
          .collection('users')
          .doc(userId)
          .collection('bankAccounts')  // Subcollection of user
          .get();
      
      return snapshot.docs.map((doc) {
        return BankAccount.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print('Error fetching bank accounts: $e');
      return [];
    }
  }
}
