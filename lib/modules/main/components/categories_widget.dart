import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api/main_api_service.dart';

class GetCelebsCategories extends StatefulWidget {
  final MainModuleApiService moduleApiService;

  const GetCelebsCategories({
    Key? key,
    required this.moduleApiService,
  }) : super(key: key);

  @override
  _GetCelebsCategoriesState createState() => _GetCelebsCategoriesState();
}

class _GetCelebsCategoriesState extends State<GetCelebsCategories> {
  List<String> categories = [];
  bool isLoadingCategories = false;
  String? selectedCategory;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchCategories(); // Fetch categories when widget initializes
    loadSelectedCategory(); // Load the saved category from SharedPreferences
  }

  Future<void> fetchCategories() async {
    setState(() {
      isLoadingCategories = true;
    });

    try {
      final fetchedCategories = await widget.moduleApiService.getCategories();
      setState(() {
        categories = fetchedCategories;
        isLoadingCategories = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load categories: $e';
        isLoadingCategories = false;
      });
    }
  }

  // Save the selected category to SharedPreferences
  Future<void> saveSelectedCategory(String? category) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedCategory', category ?? '');
  }

  // Load the selected category from SharedPreferences
  Future<void> loadSelectedCategory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedCategory = prefs.getString('selectedCategory') ?? null;
    });
  }

  void _onCategorySelected(String? category) {
    setState(() {
      selectedCategory = category;
    });
    saveSelectedCategory(category); // Save to SharedPreferences
    Navigator.pop(context); // Close the bottom sheet after selection
  }

  void _showCategoriesModal() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: isLoadingCategories
              ? const Center(child: CircularProgressIndicator())
              : categories.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        return RadioListTile<String>(
                          title: Text(categories[index]),
                          value: categories[index],
                          groupValue: selectedCategory,
                          onChanged: _onCategorySelected,
                        );
                      },
                    )
                  : const Center(child: Text('No Categories found')),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: _showCategoriesModal,
            child: Text(
              selectedCategory != null
                  ? 'Category: $selectedCategory'
                  : 'Select a Category',
            ),
          ),
          const SizedBox(height: 20),
          if (errorMessage != null)
            Text(
              errorMessage!,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}
