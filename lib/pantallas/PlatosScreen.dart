import 'package:flutter/material.dart';
import '../models/plato.dart';
import '../provider/MenuProvider.dart';
import '../provider/voiceControler.dart';


class PlatoScreen extends StatefulWidget {
  const PlatoScreen({super.key});

  @override
  State<PlatoScreen> createState() => _platoScreentState();
}

class _platoScreentState extends State<PlatoScreen> {
  final MenuProvider _service = MenuProvider();
  late Future<List<Plato>> _meals;
  late final String tipo;

  bool _isInit = true;

  List<Plato> _platosCargados = [];

  @override
  void initState() {
    super.initState();
    voiceController.onCommand = (texto) {
      _buscarPlatoPorVoz(texto);
    };
  }

  @override
  void dispose() {
    voiceController.onCommand = null;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit) {
       tipo = ModalRoute.of(context)?.settings.arguments as String;
      _meals = _service.getMealsByCategory(tipo);
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tipo.toUpperCase()), centerTitle: true, backgroundColor: Colors.amber),
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
          _platosCargados = meals;

          return ListView.separated(
            separatorBuilder: (BuildContext context, int index) => Divider(height: 1),
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

  void _buscarPlatoPorVoz(String texto) {
    if (_platosCargados.isEmpty) return;

    texto = texto.replaceAll("asistente", "").trim();

    final textoLimpio = texto.toLowerCase().trim();
    final palabras = textoLimpio.split(" ");

    for (var plato in _platosCargados) {
      final nombre = plato.name.toLowerCase();

      // 🔥 match completo
      if (textoLimpio.contains(nombre)) {
        _abrirPlato(plato);
        return;
      }

      // 🔥 match por palabras
      for (var palabra in palabras) {
        if (palabra.length < 3) continue;

        if (nombre.contains(palabra)) {
          _abrirPlato(plato);
          return;
        }
      }
    }

    print("❌ No se encontró ningún plato");
  }

  void _abrirPlato(Plato plato) {
    print("🍽️ Abriendo: ${plato.name}");

    Navigator.pushNamed(
      context,
      '/detailsScreen',
      arguments: plato,
    );
  }
}
