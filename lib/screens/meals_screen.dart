import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/meal_card.dart';
import '../models/meal.dart';
import 'meal_detail_screen.dart';

class MealsScreen extends StatefulWidget {
  final String category;
  const MealsScreen({required this.category, super.key});

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  final ApiService api = ApiService();
  List<Meal> meals = [];
  List<Meal> filteredMeals = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadMeals();
  }

  void loadMeals() async {
    meals = await api.fetchMealsByCategory(widget.category);
    setState(() {
      filteredMeals = meals;
      isLoading = false;
    });
  }

  void searchMeals(String query) {
    if (query.isEmpty) {
      setState(() => filteredMeals = meals);
      return;
    }

    setState(() {
      filteredMeals = meals
          .where((meal) => meal.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.category)),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(labelText: 'Search Meals'),
              onChanged: searchMeals,
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: filteredMeals.length,
              itemBuilder: (context, index) {
                final meal = filteredMeals[index];
                return MealCard(
                  meal: meal,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => MealDetailScreen(mealId: meal.id)));
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
