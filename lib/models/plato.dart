import 'dart:convert';

class Plato {
  final String id;
  final String name;
  final String category;
  final String instructions;
  final String thumbnail;
  final Map<String, String> ingredientes;

  Plato({
    required this.id,
    required this.name,
    required this.category,
    required this.instructions,
    required this.thumbnail,
    required this.ingredientes,
  });

  factory Plato.fromJson(Map<String, dynamic> json) {
    final Map<String, String> ingredientesTemp = {};

    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i']?.toString().trim();

      // Si es null, vacío o solo espacios → terminamos
      if (ingredient == null || ingredient.isEmpty) {
        break;
      }

      final measure = json['strMeasure$i']?.toString().trim() ?? '';

      ingredientesTemp[ingredient] = measure;
    }

    return Plato(
      id: json['idMeal'],
      name: json['strMeal'],
      category: json['strCategory'],
      instructions: json['strInstructions'],
      thumbnail: json['strMealThumb'],
      ingredientes: ingredientesTemp,
    );
  }
}
