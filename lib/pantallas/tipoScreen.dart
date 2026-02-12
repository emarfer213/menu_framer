import 'package:flutter/material.dart';

class tipoScreen extends StatefulWidget {
  const tipoScreen({super.key});

  @override
  State<tipoScreen> createState() => _tipoScreenState();
}

class _tipoScreenState extends State<tipoScreen> {
  final _formKey = GlobalKey<FormState>();
  List opciones = ["Entrante", "Primer plato", "Segundo plato", "Postre"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                child: Text(
                  'Selecciona el tipo de plato',
                  style: TextStyle(fontSize: 20, letterSpacing: 0.0),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(top: 20),
                itemCount: opciones.length,
                itemBuilder: (context, index) {
                  return opcion(opciones[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget opcion(String nombre) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: ListTile(
        title: Text(
          nombre,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18),
        ),
        onTap: () {
          switch (nombre) {
            case 'Entrante':
              Navigator.pushNamed(context, '/entranteScreen');
              break;
            case 'Primer plato':
              Navigator.pushNamed(context, '/primerPlatoScreen');
              break;
            case 'Segundo plato':
              Navigator.pushNamed(context, '/segundoPlatoScreen');
              break;
            case 'Postre':
              Navigator.pushNamed(context, '/postreScreen');
              break;
          }
        },
      ),
    );
  }
}
