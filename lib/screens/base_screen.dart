import 'package:flutter/material.dart';
import 'package:bp_app/widgets/app_drawer.dart';

class BaseScreen extends StatelessWidget {
  final Widget child; // Accepts the main content for each screen
  final String title;

  BaseScreen({required this.child, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      drawer: AppDrawer(), // Attach the persistent drawer
      body: child, // Render the main content
    );
  }
}
