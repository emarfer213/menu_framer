class Plato {
  final String id;
  final String name;
  final String category;
  final List<String> instructions;
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
    final List<dynamic> ingredientesJson = json['strIngredients'] ?? [];
    final List<dynamic> medidasJson = json['strMeasures'] ?? [];

    List<Ingrediente> listaIngredientes = [];

    for (int i = 0; i < ingredientesJson.length; i++) {
      final nombre = (ingredientesJson[i] ?? '').toString().trim();
      if (nombre.isEmpty) continue;

      final medida = i < medidasJson.length ? (medidasJson[i] ?? '').toString().trim() : '';

      listaIngredientes.add(Ingrediente(nombre: nombre, medida: medida));
    }

    return Plato(
      id: json['idMeal'] ?? '',
      name: json['strMeal'] ?? '',
      category: json['strCategory'] ?? '',
      instructions: (json['strInstructions'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      thumbnail: json['strMealThumb'] ?? '',
      ingredientes: listaIngredientes,
    );
  }
}

class Ingrediente {
  final String nombre;
  final String medida;

  Ingrediente({required this.nombre, required this.medida});
}
