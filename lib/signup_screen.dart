// <<<<<<< HEAD
// =======
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class SignUpScreen extends StatelessWidget {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Sign Up'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: _emailController,
//               decoration: InputDecoration(labelText: 'Email'),
//             ),
//             TextField(
//               controller: _passwordController,
//               decoration: InputDecoration(labelText: 'Password'),
//               obscureText: true,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                 try {
//                   // Sign-Up Logic
//                   // Firebase Authentication Sign-Up
//                   await FirebaseAuth.instance.createUserWithEmailAndPassword(
//                     email: _emailController.text.trim(),
//                     password: _passwordController.text.trim(),
//                   );

//                   // Navigate to CategoriesScreen on success
//                   Navigator.pushReplacementNamed(context, '/categories');
//                 } catch (e) {
//                   // Handle errors
//                   print(e);
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('Sign-Up Failed: $e')),
//                   );
//                 }
//               },
//               child: Text('Sign Up'),
//             ),
//             SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text("Already have an account? "),
//                 GestureDetector(
//                   onTap: () {
//                     // Navigate to Login Screen
//                     Navigator.pushNamed(context, '/login');
//                   },
//                   child: Text(
//                     'Log In',
//                     style: TextStyle(
//                       color: Colors.blue,
//                       decoration: TextDecoration.underline,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//-----------------------------------
// import 'package:flutter/material.dart';
// import 'package:bp_app/services/auth_service.dart';
// import 'package:intl/intl.dart';

// class SignUpScreen extends StatefulWidget {
//   @override
//   _SignUpScreenState createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   final AuthService _authService = AuthService();
//   final _formKey = GlobalKey<FormState>();

//   // Controllers to capture user input
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   String? _dob;

//   // Show date picker for selecting DOB
//   Future<void> _pickDate(BuildContext context) async {
//     DateTime? selectedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime(2000),
//       firstDate: DateTime(1900),
//       lastDate: DateTime.now(),
//     );
//     if (selectedDate != null) {
//       setState(() {
//         _dob = DateFormat('yyyy-MM-dd').format(selectedDate);
//       });
//     }
//   }

//   void _submit() async {
//     if (_formKey.currentState!.validate()) {
//       String name = _nameController.text.trim();
//       String email = _emailController.text.trim();
//       String password = _passwordController.text;
//       String phone = _phoneController.text.trim();

//       // Call AuthService to sign up the user
//       var user = await _authService.signUp(email, password, name, phone, _dob ?? '');
//       if (user != null) {
//         Navigator.pushReplacementNamed(context, '/categories');
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to sign up. Please try again.')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Sign Up')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               TextFormField(
//                 controller: _nameController,
//                 decoration: InputDecoration(labelText: 'Name'),
//                 validator: (value) =>
//                     value == null || value.isEmpty ? 'Name is required' : null,
//               ),
//               TextFormField(
//                 controller: _emailController,
//                 decoration: InputDecoration(labelText: 'Email'),
//                 keyboardType: TextInputType.emailAddress,
//                 validator: (value) => value == null || !value.contains('@')
//                     ? 'Enter a valid email'
//                     : null,
//               ),
//               TextFormField(
//                 controller: _passwordController,
//                 decoration: InputDecoration(labelText: 'Password'),
//                 obscureText: true,
//                 validator: (value) => value == null || value.length < 6
//                     ? 'Password must be at least 6 characters'
//                     : null,
//               ),
//               TextFormField(
//                 controller: _phoneController,
//                 decoration: InputDecoration(labelText: 'Phone Number'),
//                 keyboardType: TextInputType.phone,
//                 validator: (value) =>
//                     value == null || value.isEmpty ? 'Phone number is required' : null,
//               ),
//               ListTile(
//                 title: Text(_dob != null ? 'DOB: $_dob' : 'Select Date of Birth'),
//                 trailing: Icon(Icons.calendar_today),
//                 onTap: () => _pickDate(context),
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _submit,
//                 child: Text('Sign Up'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//----------22222222222-----------------

import 'package:flutter/material.dart';
import 'package:bp_app/services/auth_service.dart';
import 'package:intl/intl.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String? _dob;

  Future<void> _pickDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (selectedDate != null) {
      setState(() {
        _dob = DateFormat('yyyy-MM-dd').format(selectedDate);
      });
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text.trim();
      String email = _emailController.text.trim();
      String password = _passwordController.text;
      String phone = _phoneController.text.trim();

      var user = await _authService.signUp(email, password, name, phone, _dob ?? '');
      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signup successful! Please login.')),
        );
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to sign up. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/bg.jpg',
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/rl.png',
                        width: 50,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'BILL PAY',
                        style: TextStyle(
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                    'One stop for all your bill payments',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 40),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Sign Up',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 24.0,
                              ),
                            ),
                            SizedBox(height: 16),
                            TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(labelText: 'Name'),
                              style: TextStyle(fontFamily: 'Poppins'),
                              validator: (value) =>
                              value == null || value.isEmpty
                                  ? 'Name is required'
                                  : null,
                            ),
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(labelText: 'Email'),
                              style: TextStyle(fontFamily: 'Poppins'),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) =>
                              value == null || !value.contains('@')
                                  ? 'Enter a valid email'
                                  : null,
                            ),
                            TextFormField(
                              controller: _passwordController,
                              decoration: InputDecoration(labelText: 'Password'),
                              style: TextStyle(fontFamily: 'Poppins'),
                              obscureText: true,
                              validator: (value) =>
                              value == null || value.length < 6
                                  ? 'Password must be at least 6 characters'
                                  : null,
                            ),
                            TextFormField(
                              controller: _phoneController,
                              decoration: InputDecoration(labelText: 'Phone Number'),
                              style: TextStyle(fontFamily: 'Poppins'),
                              keyboardType: TextInputType.phone,
                              validator: (value) =>
                              value == null || value.isEmpty
                                  ? 'Phone number is required'
                                  : null,
                            ),
                            ListTile(
                              title: Text(
                                _dob != null
                                    ? 'DOB: $_dob'
                                    : 'Select Date of Birth',
                                style: TextStyle(fontFamily: 'Poppins'),
                              ),
                              trailing: Icon(Icons.calendar_today),
                              onTap: () => _pickDate(context),
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _submit,
                              child: Text(
                                'Sign Up',
                                style: TextStyle(fontFamily: 'Poppins'),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, '/login');
                              },
                              child: Text(
                                'Already have an account? Login',
                                style: TextStyle(fontFamily: 'Poppins'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
