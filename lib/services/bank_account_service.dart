// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../models/bank_account.dart';

// class BankAccountService {
//   final FirebaseFirestore _db = FirebaseFirestore.instance;
//   // final String userId = FirebaseAuth.instance.currentUser!.uid;


//   // Fetch all bank accounts for the logged-in user from Firestore
//   Future<List<BankAccount>> fetchUserAccounts(String userId) async {
//     try {
//       // Assuming there is a collection 'bankAccounts' for each user
//       QuerySnapshot snapshot = await _db
//           .collection('customers')
//           .doc(userId)
//           .collection('bankAccounts')  // Subcollection of user
//           .get();
      
//       return snapshot.docs.map((doc) {
//         return BankAccount.fromMap(doc.data() as Map<String, dynamic>);
//       }).toList();
//     } catch (e) {
//       print('Error fetching bank accounts: $e');
//       return [];
//     }
//   }
// }

//8888888888888888888888888888
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
