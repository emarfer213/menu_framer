import 'package:flutter/material.dart';
import 'package:menu_framer/models/plato.dart';
import 'package:menu_framer/provider/MenuProvider.dart';

class PrimerPlatoScreen extends StatefulWidget {
  const PrimerPlatoScreen({super.key});

  @override
  State<PrimerPlatoScreen> createState() => _primerScreentState();
}

class _primerScreentState extends State<PrimerPlatoScreen> {
  final MenuProvider _service = MenuProvider();
  late Future<List<Plato>> _meals;

  @override
  void initState() {
    super.initState();
    _meals = _service.getMealsByCategory('Pork');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Primer plato"), centerTitle: true, backgroundColor: Colors.amber),
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
                  Navigator.pushNamed(context, '/detailsScreen', arguments: meal);
                },
              );
            },
          );
        },
      ),
    );
  }
}
