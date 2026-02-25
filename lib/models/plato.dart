import 'dart:convert';

class Plato {
  final String id;
  final String name;
  final String category;
  final String instructions;
  final String thumbnail;
  final List<Ingrediente> ingredientes;

  Plato({
    required this.id,
    required this.name,
    required this.category,
    required this.instructions,
    required this.thumbnail,
    required this.ingredientes,
  });

  factory Plato.fromJson(Map<String, dynamic> json) {
    List<Ingrediente> listaIngredientes = [];

    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i']?.toString().trim();

      // Si es null, vacío o solo espacios → terminamos
      if (ingredient == null || ingredient.isEmpty) {
        break;
      }

      listaIngredientes.add(
        Ingrediente(
          nombre: ingredient,
          medida: json['strMeasure$i']?.toString().trim() ?? '',
        ),
      );
    }

    return Plato(
      id: json['idMeal'],
      name: json['strMeal'],
      category: json['strCategory'],
      instructions: json['strInstructions'],
      thumbnail: json['strMealThumb'],
      ingredientes: listaIngredientes,
    );
  }
}

class Ingrediente {
  final String nombre;
  final String medida;

  Ingrediente({
    required this.nombre,
    required this.medida,
  });

  factory Ingrediente.fromJson(Map<String, dynamic> json, int index) {
    final nombre = json['strIngredient$index']?.toString().trim();
    final medida = json['strMeasure$index']?.toString().trim();

    return Ingrediente(
      nombre: nombre ?? '',
      medida: medida ?? '',
    );
  }
}
