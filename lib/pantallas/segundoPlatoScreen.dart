import 'package:flutter/material.dart';

import '../models/plato.dart';
import '../provider/plato_provider.dart';

class segundoPlatoScreen extends StatefulWidget{
  const segundoPlatoScreen({super.key});

  @override
  State<segundoPlatoScreen> createState() => _segudoScreentState();
}

class _segudoScreentState extends State<segundoPlatoScreen> {
  final MealProvider _service = MealProvider();
  late Future<List<Plato>> _meals;

  @override
  void initState() {
    super.initState();
    _meals = _service.getMealsByCategory('Miscellaneous');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Segundo plato")),
      body: FutureBuilder<List<Plato>>(
        future: _meals,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Error al cargar datos"));
          }

          final meals = snapshot.data ?? [];

          return ListView.builder(
            itemCount: meals.length,
            itemBuilder: (context, index) {
              final meal = meals[index];

              return ListTile(
                leading: Image.network(meal.thumbnail),
                title: Text(meal.name),
                subtitle: Text(meal.category),
                onTap: () {
                  Navigator.pushNamed(
                      context, '/detailsScreen', arguments: meal);
                },
              );
            },
          );
        },
      ),
    );
  }
}