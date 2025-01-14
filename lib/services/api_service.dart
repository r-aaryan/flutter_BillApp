import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bp_app/models/payment.dart';



//try3
class ApiService {
  final String razorPayKey =
      'rzp_test_1KkBp1mnCHf6B5'; // Replace with your Razorpay Key ID
  final String razorPaySecret =
      'iH9d5D8qkSkqpCXtIrNM2ERg'; // Replace with your Razorpay Secret

  Future<String> createOrder(int amount) async {
    var auth =
        'Basic ' + base64Encode(utf8.encode('$razorPayKey:$razorPaySecret'));
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': auth,
    };

    var requestBody = json.encode({
      "amount": amount * 100, // Amount in paise
      "currency": "INR",
      "receipt": "Receipt no. 1",
      "notes": {
        "notes_key_1": "Merchant_Bp_App",
        "notes_key_2": "Payment for services"
      }
    });

    final response = await http.post(
      Uri.parse('https://api.razorpay.com/v1/orders'),
      headers: headers,
      body: requestBody,
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['id']; // Return the order ID
    } else {
      throw Exception('Failed to create order: ${response.body}');
    }
  }

  //payment service api
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> savePayment(Payment payment) async {
    try {
      await _firestore.collection('payments').add(payment.toMap());
    } catch (e) {
      throw Exception('Failed to save payment: $e');
    }
  }
}
