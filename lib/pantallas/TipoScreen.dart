import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../provider/voiceControler.dart';

/** Pantalla que permite al usuario seleccionar el tipo de plato (Entrante, Primer plato, etc.).
 * Esta pantalla integra control por voz para facilitar la navegación mediante comandos por voz.
 */
class TipoScreen extends StatefulWidget {
  const TipoScreen({super.key});

  @override
  State<TipoScreen> createState() => _TipoScreenState();
}

class _TipoScreenState extends State<TipoScreen> {
  final _formKey = GlobalKey<FormState>();

  // Lista de categorías de platos disponibles para mostrar en la interfaz.
  List opciones = ["Entrante", "Primer plato", "Segundo plato", "Postre"];

  @override
  void initState() {
    super.initState();

    // Inicializamos el motor de voz al entrar en la pantalla.
    voiceController.init();

    // Registramos el manejador de comandos de voz específico para esta pantalla.
    voiceController.addListener(_handleVoiceCommand);
  }

  @override
  void dispose() {
    /** Es fundamental eliminar el listener para evitar fugas de memoria y
     * ejecuciones de comandos en pantallas que ya no están visibles.
     */
    voiceController.removeListener(_handleVoiceCommand);
    super.dispose();
  }

  /**
   * Procesa los comandos de voz recibidos del VoiceController. Ademas,
   * filtra el texto reconocido buscando palabras clave relacionadas con las
   * categorías de platos y navega a la pantalla correspondiente.
   */
  void _handleVoiceCommand(String texto) {
    if (!mounted) return;

    texto = texto.toLowerCase().trim();

    print("TipoScreen recibió: $texto");

    // Navegación basada en palabras clave detectadas en el comando de voz.
    if (texto.contains("entrante")) {
      Navigator.pushNamed(context, '/platoScreen', arguments: 'Starter');
      return;
    } else if (texto.contains("primer")) {
      Navigator.pushNamed(context, '/platoScreen', arguments: 'Pork');
      return;
    } else if (texto.contains("segundo")) {
      Navigator.pushNamed(context, '/platoScreen', arguments: 'Miscellaneous');
      return;
    } else if (texto.contains("postre")) {
      Navigator.pushNamed(context, '/platoScreen', arguments: 'Dessert');
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: "Cerrar sesión",
          onPressed: () async {
            _cerrarSesion();
          },
          icon: const Icon(Icons.person_off, color: Colors.black),
        ),
        title: const Text('Menu framer'),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 20),
              width: 354.4,
              height: 43,
              child: const Align(
                alignment: AlignmentDirectional(0, 0),
                child: Text('Selecciona el tipo de plato', style: TextStyle(fontSize: 20, letterSpacing: 0.0)),
              ),
            ),
            // Lista de opciones basada en la lista 'opciones'.
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 20),
                itemCount: opciones.length,
                itemBuilder: (context, index) {
                  return tipos(opciones[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /**
   * damos formato a las opciones de los tipos de plato.
   */
  Widget tipos(String nombre) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: ListTile(
        title: Text(nombre, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18)),
        onTap: () {
          // Navegación táctil manual hacia la pantalla de platos con los respectivos argumentos.
          switch (nombre) {
            case 'Entrante':
              Navigator.pushNamed(context, '/platoScreen', arguments: 'Starter');
              break;
            case 'Primer plato':
              Navigator.pushNamed(context, '/platoScreen', arguments: 'Pork');
              break;
            case 'Segundo plato':
              Navigator.pushNamed(context, '/platoScreen', arguments: 'Miscellaneous');
              break;
            case 'Postre':
              Navigator.pushNamed(context, '/platoScreen', arguments: 'Dessert');
              break;
          }
        },
      ),
    );
  }

  /**
   * Muestra un diálogo de confirmación antes de cerrar la sesión del usuario.
   * Si el usuario acepta, se invoca el funcion signOut de Firebase Auth.
   */
  void _cerrarSesion() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const SingleChildScrollView(
          child: ListBody(children: [Text('Estás a punto de cerrar sesión ¿estás seguro?')]),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pop();
            },
            child: const Text('Aceptar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }
}
