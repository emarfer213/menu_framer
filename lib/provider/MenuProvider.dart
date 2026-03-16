import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:menu_framer/models/plato.dart';

class MenuProvider extends ChangeNotifier {
  static const String baseUrl = "https://69b69520583f543fbd9e0c5e.mockapi.io/api/menu/platos";

  Future<List<Plato>> getMealsByCategory(String category) async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);

      final filteredMeals = data
          .where(
            (meal) =>
                meal['strCategory'] != null && meal['strCategory'].toString().toLowerCase() == category.toLowerCase(),
          )
          .toList();

      return filteredMeals.map((json) => Plato.fromJson(json)).toList();
    } else {
      throw Exception("Error al cargar comidas");
    }
  }

  Future<List<Plato>> searchMeals(String query) async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);

      // Filtrar por query (ignora mayúsculas/minúsculas)
      final filteredMeals = data
          .where(
            (meal) => meal['strMeal'] != null && meal['strMeal'].toString().toLowerCase().contains(query.toLowerCase()),
          )
          .toList();

      return filteredMeals.map((json) => Plato.fromJson(json)).toList();
    } else {
      throw Exception("Error al buscar comidas");
    }
  }

  Future<Plato?> getMealDetail(String id) async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      final mealJson = data.firstWhere((meal) => meal['id'] == id, orElse: () => null);

      if (mealJson == null) return null;

      return Plato.fromJson(mealJson);
    } else {
      throw Exception("Error al cargar detalle del plato");
    }
  }
}
