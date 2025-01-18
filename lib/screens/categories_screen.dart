// import 'package:flutter/material.dart';
// import '../services/bill_service.dart';
// import 'providers_screen.dart';

// class CategoriesScreen extends StatefulWidget {
//   @override
//   _CategoriesScreenState createState() => _CategoriesScreenState();
// }

// class _CategoriesScreenState extends State<CategoriesScreen> {
//   final BillService _billService = BillService();
//   late Future<List<Map<String, dynamic>>> _categories;

//   @override
//   void initState() {
//     super.initState();
//     _categories = _billService.getCategories();
//   }

//   // Method to map icon name to actual Material Icon
//   IconData _getIconFromName(String iconName) {
//     switch (iconName) {
//       case 'electric_bolt':
//         return Icons.electrical_services; // Replace with appropriate icon
//       // Add other cases for other icons as needed
//       default:
//         return Icons.help_outline; // Fallback icon if not found
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Bill Categories')),
//       body: FutureBuilder<List<Map<String, dynamic>>>(
//         future: _categories,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error loading categories.'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('No categories found.'));
//           }

//           final categories = snapshot.data!;
//           return ListView.builder(
//             itemCount: categories.length,
//             itemBuilder: (context, index) {
//               final category = categories[index];
//               String iconName = category['icon'] ?? ''; // Fallback to empty string
//               IconData iconData = _getIconFromName(iconName);

//               // Check for null or missing category ID
//               String categoryId = category['id'] ?? ''; // Use empty string if null

//               return ListTile(
//                 leading: Icon(iconData), // Use dynamic icon based on the name
//                 title: Text(category['name']),
//                 onTap: () {
//                   if (categoryId.isNotEmpty) {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ProvidersScreen(categoryId: categoryId),
//                       ),
//                     );
//                   } else {
//                     // Handle the case where the categoryId is missing or null
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text('Category ID is missing')),
//                     );
//                   }
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
//-----------------------------------

// lib/screens/categories_screen.dart
// import 'package:flutter/material.dart';
// import '../services/bill_service.dart';
// import 'providers_screen.dart';
// import 'base_screen.dart';

// class CategoriesScreen extends StatefulWidget {
//   @override
//   _CategoriesScreenState createState() => _CategoriesScreenState();

// Widget build(BuildContext context) {
//     return BaseScreen(
//       title: 'Categories',
//       child: Center(
//         child: Text('Categories Screen Content Here'),
//       ),
//     );
//   }
// }



// class _CategoriesScreenState extends State<CategoriesScreen> {
//   final BillService _billService = BillService();
//   late Future<List<Map<String, dynamic>>> _categories;

//   @override
//   void initState() {
//     super.initState();
//     _categories = _billService.getCategories();
//   }

//   // Method to map icon name to actual Material Icon
//   IconData _getIconFromName(String iconName) {
//     switch (iconName) {
//       case 'electric_bolt':
//         return Icons.electrical_services;
//       case 'water_drop':
//         return Icons.water;
//       case 'phone_android':
//         return Icons.phone_android;
//       default:
//         return Icons.help_outline;
//     }
//   }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Bill Categories')),
//       body: FutureBuilder<List<Map<String, dynamic>>>(
//         future: _categories,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return const Center(child: Text('Error loading categories.'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text('No categories found.'));
//           }

//           final categories = snapshot.data!;
//           return ListView.builder(
//             itemCount: categories.length,
//             itemBuilder: (context, index) {
//               final category = categories[index];
//               String iconName = category['icon'] ?? '';
//               IconData iconData = _getIconFromName(iconName);

//               String categoryId = category['id'] ?? '';
//               String categoryName = category['name'] ?? 'Unnamed Category';

//               return ListTile(
//                 leading: Icon(iconData),
//                 title: Text(categoryName),
//                 onTap: () {
//                   if (categoryId.isNotEmpty) {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ProvidersScreen(
//                           categoryId: categoryId,
//                           categoryName: categoryName,
//                         ),
//                       ),
//                     );
//                   } else {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text('Category ID is missing')),
//                     );
//                   }
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }





// }
//------------2---2-2-2-----
import 'package:flutter/material.dart';
import '../services/bill_service.dart';
import 'providers_screen.dart';
import 'base_screen.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final BillService _billService = BillService();
  late Future<List<Map<String, dynamic>>> _categories;

  @override
  void initState() {
    super.initState();
    _categories = _billService.getCategories();
  }

  // Method to map icon name to actual Material Icon
  IconData _getIconFromName(String iconName) {
    switch (iconName) {
      case 'electric_bolt':
        return Icons.electrical_services;
      case 'water_drop':
        return Icons.water;
      case 'phone_android':
        return Icons.phone_android;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Bill Categories',
      titleBackgroundColor: Color(0xFF0B2A5E), // Set the background color to dark blue
      child: DefaultTextStyle(
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 18, // Increased font size
        ),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _categories,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error loading categories.'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No categories found.'));
            }

            final categories = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20), // Add space between heading and first row
                  Wrap(
                    spacing: 16.0, // Space between containers horizontally
                    runSpacing: 16.0, // Space between rows vertically
                    alignment: WrapAlignment.start, // Align at the start
                    children: List.generate(categories.length, (index) {
                      final category = categories[index];
                      String iconName = category['icon'] ?? '';
                      IconData iconData = _getIconFromName(iconName);

                      String categoryId = category['id'] ?? '';
                      String categoryName = category['name'] ?? 'Unnamed Category';

                      return Container(
                        width: (MediaQuery.of(context).size.width - 48) / 2, // Two containers in a row
                        margin: EdgeInsets.only(
                          left: index % 2 == 0 ? 16.0 : 0.0, // Add left margin for the first container in each row
                        ),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white, // Set container background color to white
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 4,
                              offset: Offset(0, 2), // Shadow position
                            ),
                          ],
                        ),
                        child: InkWell(
                          onTap: () {
                            if (categoryId.isNotEmpty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProvidersScreen(
                                    categoryId: categoryId,
                                    categoryName: categoryName,
                                  ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Category ID is missing')),
                              );
                            }
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                iconData,
                                size: 40, // Increased icon size
                                color: Colors.blue[900], // Dark blue icon color
                              ),
                              SizedBox(height: 10),
                              Text(
                                categoryName,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20, // Increased text size
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black, // Set text color to black
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
