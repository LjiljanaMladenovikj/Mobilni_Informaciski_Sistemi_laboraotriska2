import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/meal.dart';

class ApiService {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/categories.php'));
    final data = json.decode(response.body);
    List categories = data['categories'];
    return categories.map((e) => Category.fromJson(e)).toList();
  }

  Future<List<Meal>> fetchMealsByCategory(String category) async {
    final response = await http.get(Uri.parse('$baseUrl/filter.php?c=$category'));
    final data = json.decode(response.body);
    List meals = data['meals'];
    return meals.map((e) => Meal(id: e['idMeal'], name: e['strMeal'], image: e['strMealThumb'], instructions: '', ingredients: [])).toList();
  }

  Future<Meal> fetchMealDetail(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/lookup.php?i=$id'));
    final data = json.decode(response.body);
    return Meal.fromJson(data['meals'][0]);
  }

  Future<Meal> fetchRandomMeal() async {
    final response = await http.get(Uri.parse('$baseUrl/random.php'));
    final data = json.decode(response.body);
    return Meal.fromJson(data['meals'][0]);
  }

  Future<List<Meal>> searchMeals(String query) async {
    final response = await http.get(Uri.parse('$baseUrl/search.php?s=$query'));
    final data = json.decode(response.body);
    if (data['meals'] == null) return [];
    List meals = data['meals'];
    return meals.map((e) => Meal.fromJson(e)).toList();
  }
}
