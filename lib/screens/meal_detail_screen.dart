import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/meal.dart';
import 'package:url_launcher/url_launcher.dart';

class MealDetailScreen extends StatefulWidget {
  final String mealId;
  const MealDetailScreen({required this.mealId, super.key});

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  final ApiService api = ApiService();
  Meal? meal;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadMeal();
  }

  void loadMeal() async {
    meal = await api.fetchMealDetail(widget.mealId);
    setState(() {
      isLoading = false;
    });
  }

  void openYoutube(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // Порака ако не може да се отвори
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot open URL')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(meal?.name ?? 'Loading...')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(meal!.image),
            const SizedBox(height: 8),
            Text(meal!.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text('Instructions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(meal!.instructions),
            const SizedBox(height: 16),
            const Text('Ingredients', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...meal!.ingredients.map((i) => Text(i)).toList(),
            const SizedBox(height: 16),
            if (meal!.youtubeUrl != null && meal!.youtubeUrl!.isNotEmpty)
              ElevatedButton(
                onPressed: () => openYoutube(meal!.youtubeUrl!),
                child: const Text('Watch on YouTube'),
              ),
          ],
        ),
      ),
    );
  }
}
