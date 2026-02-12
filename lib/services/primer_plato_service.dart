import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:menu_framer/models/plato.dart';

class MealService {
  static const String baseUrl =
      "https://www.themealdb.com/api/json/v1/1/";

  Future<List<String>> getCategories() async {
    final response = await http.get(
      Uri.parse("${baseUrl}categories.php"),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List categories = data['categories'];

      return categories
          .map<String>((cat) => cat['strCategory'] as String)
          .toList();
    } else {
      throw Exception("Error al cargar categorías");
    }
  }

  Future<List<Plato>> getMealsByCategory(String category) async {
    final response = await http.get(
      Uri.parse("${baseUrl}filter.php?c=$category"),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List mealsJson = data['meals'];

      return mealsJson.map((json) => Plato(
        id: json['idMeal'],
        name: json['strMeal'],
        category: category,
        instructions: '',
        thumbnail: json['strMealThumb'],
        ingredientes: {},
      )).toList();
    } else {
      throw Exception("Error al cargar comidas");
    }
  }

  Future<List<Plato>> getThreeCategoriesThreeMealsEach() async {
    final categories = await getCategories();

    // Categorías a excluir
    const excludedCategories = [
      'Miscellaneous',
      'Side',
      'Dessert',
      'Starter',
      'Breakfast'
    ];

    final filteredCategories = categories
        .where((cat) => !excludedCategories.contains(cat))
        .toList();

    if (filteredCategories.length < 3) {
      throw Exception("No hay suficientes categorías disponibles");
    }

    filteredCategories.shuffle();
    final selectedCategories = filteredCategories.take(3).toList();

    final futures = selectedCategories.map((category) async {
      final meals = await getMealsByCategory(category);

      meals.shuffle();
      return meals.take(3).toList();
    });

    final results = await Future.wait(futures);

    return results.expand((mealList) => mealList).toList();
  }

  Future<List<Plato>> searchMeals(String query) async {
    final response = await http.get(
      Uri.parse("${baseUrl}search.php?s=$query"),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List mealsJson = data['meals'];

      if (mealsJson == null) return [];

      return mealsJson.map((json) => Plato.fromJson(json)).toList();
    } else {
      throw Exception("Error al cargar datos");
    }
  }
}