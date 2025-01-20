import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign up with email and password
  Future<User?> signUp(String email, String password, String name,
      String phoneNumber, String dob) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      // Add user details to Firestore
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('customers')
            .doc(user.uid)
            .set({
          'name': name,
          'email': email,
          'phoneNumber': phoneNumber,
          'dob': dob,
          'primaryAccountId': '',
        });
      }
      return user;
    } catch (e) {
      print("Error during sign-up: $e");
      return null;
    }
  }

  // Sign in with email and password
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (e) {
      print("Error during sign-in: $e");
      return null;
    }
  }

  // Fetch user details from Firestore
  Future<Map<String, dynamic>?> getUserDetails(String uid) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('customers')
          .doc(uid)
          .get();
      return userDoc.data() as Map<String, dynamic>;
    } catch (e) {
      print("Error fetching user details: $e");
      return null;
    }
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      print("Password reset email sent to $email");
    } catch (e) {
      print("Error sending password reset email: $e");
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print("Error during sign-out: $e");
    }
  }
}
