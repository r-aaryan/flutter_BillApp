import 'package:flutter/material.dart';
import 'package:bp_app/screens/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppDrawer extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _logout(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(_auth.currentUser?.displayName ?? 'User Name'),
            accountEmail: Text(_auth.currentUser?.email ?? 'user@example.com'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                (_auth.currentUser?.displayName != null &&
                    _auth.currentUser!.displayName!.isNotEmpty)
                    ? _auth.currentUser!.displayName![0].toUpperCase()
                    : 'U',
                style: TextStyle(fontSize: 24, color: Colors.blue),
              ),
            ),
            decoration: BoxDecoration(
              color: Color(0xFF0B2A5E), // Dark blue color
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }
}
