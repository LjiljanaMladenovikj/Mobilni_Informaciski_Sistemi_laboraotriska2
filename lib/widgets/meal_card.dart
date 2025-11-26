import 'package:flutter/material.dart';
import '../models/meal.dart';

class MealCard extends StatelessWidget {
  final Meal meal;
  final VoidCallback onTap;

  const MealCard({required this.meal, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Column(
          children: [
            Image.network(meal.image, height: 100, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(meal.name, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
