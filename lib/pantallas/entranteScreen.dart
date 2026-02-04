import 'package:flutter/material.dart';

class entranteScreen extends StatefulWidget{
  const entranteScreen({super.key});

  @override
  State<entranteScreen> createState() => _entranteScreentState();
}

class _entranteScreentState extends State<entranteScreen> {
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Entrantes'),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
    );
  }
}