import 'package:flutter/material.dart';

import '../../models/plato.dart';
import '../../provider/MenuProvider.dart';

class PostreScreen extends StatefulWidget{
  const PostreScreen({super.key});

  @override
  State<PostreScreen> createState() => _postreScreentState();
}

class _postreScreentState extends State<PostreScreen> {
  final MenuProvider _service = MenuProvider();
  late Future<List<Plato>> _meals;

  @override
  void initState() {
    super.initState();
    _meals = _service.getMealsByCategory('Dessert');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Postre"),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
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