// import 'package:flutter/material.dart';
//
// class PayBillsScreen extends StatefulWidget {
//   @override
//   _PayBillsScreenState createState() => _PayBillsScreenState();
// }
//
// class _PayBillsScreenState extends State<PayBillsScreen> {
//   final TextEditingController _billAmountController = TextEditingController();
//
//   // List of bill categories and corresponding service providers
//   final Map<String, List<String>> _serviceProviders = {
//     'Electricity': ['Provider A', 'Provider B', 'Provider C'],
//     'Water': ['Provider D', 'Provider E'],
//     'Mobile': ['Provider F', 'Provider G', 'Provider H'],
//   };
//
//   String? _selectedCategory;
//   String? _selectedProvider;
//   List<String> _providers = [];
//
//   void _onCategoryChanged(String? newValue) {
//     setState(() {
//       _selectedCategory = newValue;
//       _providers = _serviceProviders[newValue] ?? [];
//       _selectedProvider = null; // Reset provider selection
//     });
//   }
//
//   void _payBill() {
//     if (_selectedCategory == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please select a bill category.')),
//       );
//       return;
//     }
//     if (_selectedProvider == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please select a service provider.')),
//       );
//       return;
//     }
//     print("Bill paid: ${_billAmountController.text} to $_selectedProvider in $_selectedCategory");
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Pay Bills'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             DropdownButtonFormField<String>(
//               decoration: InputDecoration(labelText: 'Select Bill Category'),
//               value: _selectedCategory,
//               items: _serviceProviders.keys.map((String category) {
//                 return DropdownMenuItem<String>(
//                   value: category,
//                   child: Text(category),
//                 );
//               }).toList(),
//               onChanged: _onCategoryChanged,
//             ),
//             if (_providers.isNotEmpty)
//               DropdownButtonFormField<String>(
//                 decoration: InputDecoration(labelText: 'Select Service Provider'),
//                 value: _selectedProvider,
//                 items: _providers.map((String provider) {
//                   return DropdownMenuItem<String>(
//                     value: provider,
//                     child: Text(provider),
//                   );
//                 }).toList(),
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     _selectedProvider = newValue;
//                   });
//                 },
//               ),
//             TextField(
//               controller: _billAmountController,
//               decoration: InputDecoration(labelText: 'Bill Amount'),
//               keyboardType: TextInputType.number,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _payBill,
//               child: Text('Pay Bill'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }




//AFTER DATABASE INTEGRATION
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PayBillsScreen extends StatefulWidget {
  @override
  _PayBillsScreenState createState() => _PayBillsScreenState();
}

class _PayBillsScreenState extends State<PayBillsScreen> {
  final TextEditingController _billAmountController = TextEditingController();
  String? _selectedCategory;
  String? _selectedProvider;
  List<String> _providers = [];

  Future<void> _fetchProviders(String category) async {
    final providersSnapshot = await FirebaseFirestore.instance
        .collection('categories')
        .doc(category.toLowerCase())
        .collection('providers')
        .get();

    setState(() {
  _providers = providersSnapshot.docs.map((doc) => doc['name'] as String).toList();
  _selectedProvider = null;
});

  }

  void _payBill() {
    if (_selectedCategory == null || _selectedProvider == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a category and provider.')),
      );
      return;
    }
    print("Bill paid: ${_billAmountController.text} to $_selectedProvider in $_selectedCategory");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pay Bills'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Select Bill Category'),
              value: _selectedCategory,
              items: ['Electricity', 'Water', 'Mobile'].map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
                _fetchProviders(value!);
              },
            ),
            if (_providers.isNotEmpty)
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Select Service Provider'),
                value: _selectedProvider,
                items: _providers.map((String provider) {
                  return DropdownMenuItem<String>(
                    value: provider,
                    child: Text(provider),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedProvider = value;
                  });
                },
              ),
            TextField(
              controller: _billAmountController,
              decoration: InputDecoration(labelText: 'Bill Amount'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _payBill,
              child: Text('Pay Bill'),
            ),
          ],
        ),
      ),
    );
  }
}
