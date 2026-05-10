import 'package:flutter/material.dart';
import 'package:menu_framer/models/VideoDialog.dart';

import '../models/plato.dart';
import '../provider/MenuProvider.dart';
import '../provider/voiceControler.dart';

class DetailsScreen extends StatefulWidget {
  @override
  State<DetailsScreen> createState() => _detailsScreentState();
}

/// Gestiona la carga de datos desde la API y la interacción con el controlador de voz.
class _detailsScreentState extends State<DetailsScreen> {
  late Future<Plato?> platoFuture; // Almacena el futuro de la petición de detalles del plato.
  late Plato plato; // Objeto Plato recibido como argumento.

  @override
  void initState() {
    super.initState();

    // Registramos esta pantalla como escucha de los comandos de voz globales.
    voiceController.addListener(_handleVoiceCommand);
  }

  @override
  void dispose() {
    voiceController.removeListener(_handleVoiceCommand);

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Extraemos el objeto Plato que fue pasado a través del Navigator.
    plato = ModalRoute.of(context)?.settings.arguments as Plato;

    //extraemos los detalles del plato desde la API.
    platoFuture = MenuProvider().getMealDetail(plato.id);
  }

  /**
   * Procesa los comandos de voz capturados por el VoiceController.
   * Si el usuario dice "intentar", navega a la pantalla PasosScreen.
   * Si dice "volver" o "atrás", regresa a la pantalla anterior.
   */
  void _handleVoiceCommand(String texto) {
    if (!mounted) return;

    texto = texto.toLowerCase().trim();

    print("DetailsScreen recibió: $texto");

    // Si el usuario dice "intentar", pasamos a la siguiente fase de la receta.
    if (texto.contains("intentar")) {
      Navigator.pushNamed(context, '/pasosScreen', arguments: plato);
      return;
    }

    // Si el usuario dice "volver" o "atrás", regresamos a la pantalla previa.
    if (texto.contains("volver") || texto.contains("atrás") || texto.contains("atras")) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menu Framer'), backgroundColor: Colors.amber, centerTitle: true),

      body: SafeArea(
        child: FutureBuilder<Plato?>(
          future: platoFuture,

          builder: (context, snapshot) {
            // Animacion de carga mientras se obtienen los datos de la API.
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            // Extraemos los detalles completos del plato.
            final platoCompleto = snapshot.data!;

            return SingleChildScrollView(
              child: Column(
                spacing: 40,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                children: [
                  //Visualización de la imagen del plato.
                  Center(
                    child: Container(
                      padding: const EdgeInsets.only(top: 20),
                      child: Image.network(platoCompleto.thumbnail, height: 400, width: 400),
                    ),
                  ),

                  //Botón para abrir el video de preparación en un diálogo.
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => VideoDialog(videoUrl: platoCompleto.link),
                        );
                      },
                      icon: const Icon(Icons.play_arrow, color: Colors.white),
                      label: const Text("Ver preparación", style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                    ),
                  ),

                  //Listado detallado de ingredientes y sus medidas.
                  Column(
                    children: [
                      const Center(
                        child: Text(
                          'Los ingredientes necesarios para la preparacion seran:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),

                      ...platoCompleto.ingredientes.map(
                        (ingrediente) => Center(child: Text("• ${ingrediente.nombre}: ${ingrediente.medida}")),
                      ),
                    ],
                  ),

                  //Botón final para ir a la guía paso a paso.
                  Container(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(context, '/pasosScreen', arguments: platoCompleto);
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                        label: const Text("Intentar", style: TextStyle(color: Colors.white, fontSize: 20)),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
