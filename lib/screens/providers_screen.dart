<<<<<<< HEAD
=======
// import 'package:flutter/material.dart';
// import '../services/bill_service.dart';

// class ProvidersScreen extends StatefulWidget {
//   final String categoryId;

//   ProvidersScreen({required this.categoryId});

//   @override
//   _ProvidersScreenState createState() => _ProvidersScreenState();
// }

// class _ProvidersScreenState extends State<ProvidersScreen> {
//   final BillService _billService = BillService();
//   late Future<List<Map<String, dynamic>>> _providers;

//   @override
//   void initState() {
//     super.initState();
//     _providers = _billService.getProvidersByCategoryId(widget.categoryId);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Service Providers')),
//       body: FutureBuilder<List<Map<String, dynamic>>>(
//         future: _providers,
//         builder: (context, snapshot) {
//           // Handling the loading state
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }

//           // Handle error case
//           if (snapshot.hasError) {
//             return Center(child: Text('Error loading providers.'));
//           }

//           // Handle the empty data case
//           if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('No providers found.'));
//           }

//           // Process the fetched data
//           final providers = snapshot.data!;
//           return ListView.builder(
//             itemCount: providers.length,
//             itemBuilder: (context, index) {
//               final provider = providers[index];
//               return ListTile(
//                 title: Text(provider['name']),
//                 subtitle: Text(provider['contact'] ?? 'No contact info'), // Provide a fallback for missing contact info
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
//-------------------------------------

// lib/screens/providers_screen.dart
>>>>>>> origin/frontend
import 'package:flutter/material.dart';
import '../services/bill_service.dart';
import '../services/auth_service.dart';
import 'bills_screen.dart';

class ProvidersScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  ProvidersScreen({required this.categoryId, required this.categoryName});

  @override
  _ProvidersScreenState createState() => _ProvidersScreenState();
}

class _ProvidersScreenState extends State<ProvidersScreen> {
  final BillService _billService = BillService();
  final AuthService _authService = AuthService();
  late Future<List<Map<String, dynamic>>> _providers;

  @override
  void initState() {
    super.initState();
    _providers = _billService.getProvidersByCategoryId(widget.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
<<<<<<< HEAD
        backgroundColor: Color(0xFF0B2A5E),
        iconTheme: IconThemeData(
          color: Colors.white, // Set icon color to white
        ),// Dark blue background
        title: Text(
          'Providers for ${widget.categoryName}',
          style: TextStyle(
            fontFamily: 'Poppins', // Set font to Poppins
            color: Colors.white, // White font color
          ),
        ),
      ),
      body: DefaultTextStyle(
        style: TextStyle(
          fontFamily: 'Poppins', // Set default font to Poppins
          fontSize: 16, // Base font size
          color: Colors.black, // Default text color
        ),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _providers,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error loading providers.',
                  style: TextStyle(color: Colors.red), // Highlight error in red
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No providers found.'));
            }

            final providers = snapshot.data!;
            return ListView.builder(
              itemCount: providers.length,
              itemBuilder: (context, index) {
                final provider = providers[index];
                return ListTile(
                  leading: Icon(
                    Icons.business,
                    color: Colors.blue[900], // Icon color set to dark blue
                  ),
                  title: Text(
                    provider['name'],
                    style: TextStyle(fontWeight: FontWeight.bold), // Bold provider name
                  ),
                  subtitle: Text(provider['contact'] ?? 'No contact info'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BillsScreen(
                          providerId: provider['id'],
                          providerName: provider['name'],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
=======
        title: Text('Providers for ${widget.categoryName}'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _providers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading providers.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No providers found.'));
          }

          final providers = snapshot.data!;
          return ListView.builder(
            itemCount: providers.length,
            itemBuilder: (context, index) {
              final provider = providers[index];
              return ListTile(
                leading: Icon(Icons.business), // You can map icons similarly
                title: Text(provider['name']),
                subtitle: Text(provider['contact'] ?? 'No contact info'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BillsScreen(
                        providerId: provider['id'],
                        providerName: provider['name'],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
>>>>>>> origin/frontend
      ),
    );
  }
}
