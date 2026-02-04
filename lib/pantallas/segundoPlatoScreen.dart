import 'package:flutter/material.dart';

class segundoPlatoScreen extends StatefulWidget{
  const segundoPlatoScreen({super.key});

  @override
  State<segundoPlatoScreen> createState() => _segudoScreentState();
}

class _segudoScreentState extends State<segundoPlatoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Segundo plato'),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
    );
  }
}