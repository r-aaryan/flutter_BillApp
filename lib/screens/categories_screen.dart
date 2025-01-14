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
          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              String iconName = category['icon'] ?? '';
              IconData iconData = _getIconFromName(iconName);

              String categoryId = category['id'] ?? '';
              String categoryName = category['name'] ?? 'Unnamed Category';

              return ListTile(
                leading: Icon(iconData),
                title: Text(categoryName),
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
              );
            },
          );
        },
      ),
    );
  }
}
