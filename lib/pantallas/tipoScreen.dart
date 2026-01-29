import 'package:flutter/material.dart';

class tipoScreen extends StatefulWidget {
  const tipoScreen({super.key});

  @override
  State<tipoScreen> createState() => _tipoScreenState();
}

class _tipoScreenState extends State<tipoScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu framer'),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsetsGeometry.only(top: 80),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 20,
              children: [
                Center(
                  child: Container(
                    width: 300,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        "Selecciona el tipo de plato",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),

                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    spacing: 150,
                    children: [
                      Text("Entrantes"),
                      Text("Primer plato"),
                      Text("Segundo plato"),
                      Text("Postre"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
