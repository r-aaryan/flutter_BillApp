import 'package:bp_app/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'signup_screen.dart';
import 'screens/categories_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BP_App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/signup', // Initial route for the app
      routes: {
        '/signup': (context) => SignUpScreen(),
        '/login': (context) => LoginScreen(),
        '/categories': (context) => CategoriesScreen(),
        '/home': (context) => Scaffold(
              body: Center(child: Text("Welcome Home!")),
            ),
      },
    );
  }
}

