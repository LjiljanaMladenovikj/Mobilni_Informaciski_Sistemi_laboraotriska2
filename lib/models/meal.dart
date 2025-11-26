class Meal {
  final String id;
  final String name;
  final String image;
  final String instructions;
  final List<String> ingredients;
  final String? youtubeUrl;

  Meal({
    required this.id,
    required this.name,
    required this.image,
    required this.instructions,
    required this.ingredients,
    this.youtubeUrl,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    List<String> ingredients = [];
    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];
      if (ingredient != null && ingredient.isNotEmpty) {
        ingredients.add('$ingredient - $measure');
      }
    }

    return Meal(
      id: json['idMeal'],
      name: json['strMeal'],
      image: json['strMealThumb'],
      instructions: json['strInstructions'] ?? '',
      ingredients: ingredients,
      youtubeUrl: json['strYoutube'],
    );
  }
}
