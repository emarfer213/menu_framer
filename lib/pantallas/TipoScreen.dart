import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../provider/voiceControler.dart';

class TipoScreen extends StatefulWidget {
  const TipoScreen({super.key});

  @override
  State<TipoScreen> createState() => _TipoScreenState();
}

class _TipoScreenState extends State<TipoScreen> {
  final _formKey = GlobalKey<FormState>();
  List opciones = ["Entrante", "Primer plato", "Segundo plato", "Postre"];
  bool _esperandoConfirmacionLogout = false;

  bool _esCerrarSesion(String texto) {
    return (texto.contains("cerrar") && texto.contains("sesion")) || texto.contains("salir");
  }

  @override
  void initState() {
    super.initState();
    voiceController.init();

    voiceController.onCommand = (texto) {
      if (texto.contains("entrante")) {
        Navigator.pushNamed(context, '/platoScreen', arguments: 'Starter');
      } else if (texto.contains("primer")) {
        Navigator.pushNamed(context, '/platoScreen', arguments: 'Pork');
      } else if (texto.contains("segundo")) {
        Navigator.pushNamed(context, '/platoScreen', arguments: 'Miscellaneous');
      } else if (texto.contains("postre")) {
        Navigator.pushNamed(context, '/platoScreen', arguments: 'Dessert');
      } else if (_esCerrarSesion(texto)) {
        _cerrarSesion();
      }
    };
  }

  @override
  void dispose() {
    super.dispose();
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
          icon: Icon(Icons.person_off, color: Colors.black),
        ),
        title: Text('Menu framer'),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(top: 20),
              width: 354.4,
              height: 43,
              child: Align(
                alignment: AlignmentDirectional(0, 0),
                child: Text('Selecciona el tipo de plato', style: TextStyle(fontSize: 20, letterSpacing: 0.0)),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(top: 20),
                itemCount: opciones.length,
                itemBuilder: (context, index) {
                  return comandos(opciones[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget comandos(String nombre) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: ListTile(
        title: Text(nombre, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18)),
        onTap: () {
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

  void _cerrarSesion() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro?'),
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
