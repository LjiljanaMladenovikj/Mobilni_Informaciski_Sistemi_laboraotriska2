import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/category_card.dart';
import '../screens/meals_screen.dart';
import '../models/category.dart';
import 'meal_detail_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final ApiService api = ApiService();
  List<Category> categories = [];
  List<Category> filteredCategories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  void loadCategories() async {
    categories = await api.fetchCategories();
    setState(() {
      filteredCategories = categories;
      isLoading = false;
    });
  }

  void searchCategory(String query) {
    setState(() {
      filteredCategories = categories
          .where((c) => c.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void openRandomMeal() async {
    final meal = await api.fetchRandomMeal();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MealDetailScreen(mealId: meal.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        actions: [
          GestureDetector(
            onTap: openRandomMeal,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.auto_awesome,
                    color: Colors.orange,
                    size: 24,
                  ),
                  SizedBox(height: 2),
                  Text(
                    "Random",
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration:
              const InputDecoration(labelText: 'Search Categories'),
              onChanged: searchCategory,
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: filteredCategories.length,
              itemBuilder: (context, index) {
                final category = filteredCategories[index];
                return CategoryCard(
                  category: category,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            MealsScreen(category: category.name),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
