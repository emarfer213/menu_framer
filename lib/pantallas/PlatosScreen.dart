import 'package:flutter/material.dart';

import '../models/plato.dart';
import '../provider/MenuProvider.dart';
import '../provider/voiceControler.dart';

/**
 * Pantalla que muestra un listado de platos filtrados por una categoría específica.
 * Permite la navegación táctil y mediante comandos de voz para seleccionar platos.
 */
class PlatoScreen extends StatefulWidget {
  const PlatoScreen({super.key});

  @override
  State<PlatoScreen> createState() => _PlatoScreenState();
}

class _PlatoScreenState extends State<PlatoScreen> {
  final MenuProvider _service = MenuProvider();// Instancia del proveedor de datos del menú.
  late Future<List<Plato>> _meals;// Futuro que contendrá la lista de platos cargados desde la API.
  late final String tipo; // Categoría de platos a mostrar (ej. "Starter", "Pork").
  bool _isInit = true;
  List<Plato> _platosCargados = [];// Cache local de los platos cargados para facilitar la búsqueda por voz.

  @override
  void initState() {
    super.initState();

    // Registramos el listener para capturar comandos de voz.
    voiceController.addListener(_handleVoiceCommand);
  }

  @override
  void dispose() {
    // Eliminamos el listener para evitar errores si la pantalla se destruye.
    voiceController.removeListener(_handleVoiceCommand);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Recuperamos la categoría pasada como argumento y disparamos la petición.
    if (_isInit) {
      tipo = ModalRoute.of(context)?.settings.arguments as String;
      _meals = _service.getMealsByCategory(tipo);
      _isInit = false;
    }
  }

  /**
   * Manejador de eventos de voz.
   * Recibe el texto reconocido por el VoiceController y lo delega a la lógica de búsqueda.
    */
  void _handleVoiceCommand(String texto) {
    if (!mounted) return;
    _buscarPlatoPorVoz(texto);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tipo.toUpperCase()), 
        centerTitle: true, 
        backgroundColor: Colors.amber
      ),

      body: FutureBuilder<List<Plato>>(
        future: _meals,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No se encontraron platos"));
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Error al cargar datos"));
          }

          final meals = snapshot.data ?? [];

          _platosCargados = meals;// Guardamos los platos en local para que el buscador por voz pueda acceder a ellos.

          // Renderizado de la lista de platos.
          return ListView.separated(
            separatorBuilder: (BuildContext context, int index) => const Divider(height: 1),
            itemCount: meals.length,
            itemBuilder: (context, index) {
              final meal = meals[index];

              return ListTile(
                leading: Image.network(meal.thumbnail),
                title: Text(meal.name),
                subtitle: Text(meal.category),
                onTap: () {
                  // Navegación a la pantalla de detalles del plato seleccionado.
                  Navigator.pushNamed(context, '/detailsScreen', arguments: meal);
                },
              );
            },
          );
        },
      ),
    );
  }

  /**
   * Analiza el texto recibido por voz para realizar acciones.
    */
  void _buscarPlatoPorVoz(String texto) {
    if (_platosCargados.isEmpty) return;

    // Formateamos el texto para facilitar la comparación.
    final textoLimpio = texto.toLowerCase().trim();

    //Permite regresar a la selección de categorías.
    if (textoLimpio.contains("atrás") || textoLimpio.contains("atras") || textoLimpio.contains("regresar")) {
      print("Retrocediendo pantalla");
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      return;
    }

    //Comparamos el texto hablado con los nombres de los platos.
    final palabras = textoLimpio.split(" ");

    for (var plato in _platosCargados) {
      final nombre = plato.name.toLowerCase();
      // Coincidencia exacta o contenida.
      if (nombre.contains(textoLimpio) || textoLimpio.contains(nombre)) {
        _abrirPlato(plato);
        return;
      }
      // Búsqueda por palabras individuales, mínimo 3 caracteres para evitar falsos positivos.
      for (var palabra in palabras) {
        if (palabra.length < 3) continue;
        if (nombre.contains(palabra)) {
          _abrirPlato(plato);
          return;
        }
      }
    }

    print("No se encontró ningún plato que coincida con: $textoLimpio");
  }

  // Realiza la navegación hacia la pantalla de detalles del plato.
  void _abrirPlato(Plato plato) {
    print("🍽️ Abriendo: ${plato.name}");
    Navigator.pushNamed(context, '/detailsScreen', arguments: plato);
  }
}
