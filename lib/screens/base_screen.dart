import 'package:flutter/material.dart';
import 'package:bp_app/widgets/app_drawer.dart';

class BaseScreen extends StatelessWidget {
  final Widget child; // Accepts the main content for each screen
  final String title; // The title of the app bar
  final Color? titleBackgroundColor; // Optional background color for the app bar

  BaseScreen({
    required this.child,
    required this.title,
    this.titleBackgroundColor, // Make this parameter optional
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'Poppins', // Set the font to Poppins
            fontWeight: FontWeight.bold, // Make it bold
            color: Colors.white, // Set the text color to white
          ),
        ),
        backgroundColor: titleBackgroundColor ?? Theme.of(context).primaryColor, // Use the provided color or default to the theme's primary color
        iconTheme: IconThemeData(
          color: Colors.white, // Set all icons in the AppBar to white
        ),
      ),
      drawer: AppDrawer(), // Attach the persistent drawer
      body: child, // Render the main content
    );
  }
}
