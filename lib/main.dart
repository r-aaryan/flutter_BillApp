import 'package:bp_app/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'signup_screen.dart';
import 'screens/categories_screen.dart';
<<<<<<< HEAD
import 'splash_screen.dart'; // Import the SplashScreen
=======
>>>>>>> origin/frontend

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
<<<<<<< HEAD
      debugShowCheckedModeBanner: false,
      title: 'BP_App',
      theme: ThemeData(primarySwatch: Colors.blue,fontFamily: 'Poppins'),
      initialRoute: '/splash', // Set SplashScreen as the initial route
      routes: {
        '/splash': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),// Add the SplashScreen route
        '/signup': (context) => SignUpScreen(),
        '/categories': (context) => CategoriesScreen(),
        '/home': (context) => Scaffold(
          body: Center(child: Text("Welcome Home!")),
        ),
=======
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
>>>>>>> origin/frontend
      },
    );
  }
}
