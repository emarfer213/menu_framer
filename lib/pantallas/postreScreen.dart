import 'package:flutter/material.dart';

import '../models/plato.dart';
import '../provider/plato_provider.dart';

class postreScreen extends StatefulWidget{
  const postreScreen({super.key});

  @override
  State<postreScreen> createState() => _postreScreentState();
}

class _postreScreentState extends State<postreScreen> {
  final MealProvider _service = MealProvider();
  late Future<List<Plato>> _meals;

  @override
  void initState() {
    super.initState();
    _meals = _service.getMealsByCategory('Dessert');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Postres")),
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