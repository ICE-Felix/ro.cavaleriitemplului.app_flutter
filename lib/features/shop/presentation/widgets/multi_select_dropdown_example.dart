import 'package:flutter/material.dart';
import 'package:app/features/shop/presentation/widgets/multi_select_dropdown.dart';

// Example model for demonstration
class Category {
  final int id;
  final String name;
  final String description;

  Category({required this.id, required this.name, required this.description});
}

class User {
  final String email;
  final String name;

  User({required this.email, required this.name});
}

class MultiSelectDropdownExample extends StatefulWidget {
  const MultiSelectDropdownExample({super.key});

  @override
  State<MultiSelectDropdownExample> createState() =>
      _MultiSelectDropdownExampleState();
}

class _MultiSelectDropdownExampleState
    extends State<MultiSelectDropdownExample> {
  // Example 1: Category dropdown where ValueType is Category and ReturnType is int
  List<int> selectedCategoryIds = [];
  final List<Category> categories = [
    Category(id: 1, name: 'Electronics', description: 'Gadgets and devices'),
    Category(id: 2, name: 'Clothing', description: 'Fashion and apparel'),
    Category(id: 3, name: 'Books', description: 'Literature and educational'),
    Category(id: 4, name: 'Home & Garden', description: 'Home improvement'),
  ];

  // Example 2: User dropdown where ValueType is User and ReturnType is String
  List<String> selectedUserEmails = [];
  final List<User> users = [
    User(email: 'john@example.com', name: 'John Doe'),
    User(email: 'jane@example.com', name: 'Jane Smith'),
    User(email: 'bob@example.com', name: 'Bob Johnson'),
  ];

  // Example 3: String dropdown where both ValueType and ReturnType are String
  List<String> selectedColors = [];
  final List<String> colors = ['Red', 'Green', 'Blue', 'Yellow', 'Purple'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MultiSelect Dropdown Examples')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Example 1: Category selection
            const Text(
              'Select Categories:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            MultiSelectDropdown<Category, int>(
              items: categories,
              selectedValues: selectedCategoryIds,
              hintText: 'Choose categories',
              builderFunction: (Category category) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      category.description,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                );
              },
              valueExtractor: (Category category) => category.id,
              onChanged: (List<int> selectedIds) {
                setState(() {
                  selectedCategoryIds = selectedIds;
                });
              },
            ),

            const SizedBox(height: 24),

            // Example 2: User selection
            const Text(
              'Select Users:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            MultiSelectDropdown<User, String>(
              items: users,
              selectedValues: selectedUserEmails,
              hintText: 'Choose users',
              prefixIcon: const Icon(Icons.person, size: 20),
              builderFunction: (User user) {
                return Row(
                  children: [
                    CircleAvatar(radius: 16, child: Text(user.name[0])),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            user.email,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
              valueExtractor: (User user) => user.email,
              onChanged: (List<String> selectedEmails) {
                setState(() {
                  selectedUserEmails = selectedEmails;
                });
              },
            ),

            const SizedBox(height: 24),

            // Example 3: Simple string selection
            const Text(
              'Select Colors:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            MultiSelectDropdown<String, String>(
              items: colors,
              selectedValues: selectedColors,
              hintText: 'Pick colors',
              builderFunction: (String color) {
                return Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: _getColorFromName(color),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(color),
                  ],
                );
              },
              valueExtractor: (String color) => color,
              onChanged: (List<String> selectedColorList) {
                setState(() {
                  selectedColors = selectedColorList;
                });
              },
              maxHeight: 200.0,
            ),

            const SizedBox(height: 32),

            // Display selected values
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Selected Values:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('Categories: $selectedCategoryIds'),
                  Text('Users: $selectedUserEmails'),
                  Text('Colors: $selectedColors'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorFromName(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'green':
        return Colors.green;
      case 'blue':
        return Colors.blue;
      case 'yellow':
        return Colors.yellow;
      case 'purple':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
