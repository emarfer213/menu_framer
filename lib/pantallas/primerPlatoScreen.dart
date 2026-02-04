import 'package:flutter/material.dart';

class primerPlatoScreen extends StatefulWidget{
  const primerPlatoScreen({super.key});

  @override
  State<primerPlatoScreen> createState() => _primerScreentState();
}

class _primerScreentState extends State<primerPlatoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Primer plato'),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
    );
  }
}