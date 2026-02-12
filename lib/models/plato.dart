import 'dart:convert';

import 'package:flutter/material.dart';

class Plato {
  final String id;
  final String name;
  final String category;
  final Text instructions;
  final String thumbnail;
  final Map ingredientes;

  Plato({
    required this.id,
    required this.name,
    required this.category,
    required this.instructions,
    required this.thumbnail,
    required this.ingredientes,
  });

  factory Plato.fromJson(Map<String, dynamic> json) {
    Map<String, String> ingredientesTemp = {};


    for (int i = 1; i <= 20; i++) {
      if (json['strIngredient$i'] != '') {
        ingredientesTemp[json['strIngredient$i']]=json['strMeasure$i'];
      } else {
        break;
      }
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
