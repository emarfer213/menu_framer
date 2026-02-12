class Plato {
  final String id;
  final String name;
  final String category;
  final String instructions;
  final String thumbnail;

  Plato({
    required this.id,
    required this.name,
    required this.category,
    required this.instructions,
    required this.thumbnail,
  });

  factory Plato.fromJson(Map<String, dynamic> json) {
    return Plato(
      id: json['idMeal'],
      name: json['strMeal'],
      category: json['strCategory'],
      instructions: json['strInstructions'],
      thumbnail: json['strMealThumb'],
    );
  }
}