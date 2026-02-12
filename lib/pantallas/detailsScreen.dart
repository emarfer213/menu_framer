import 'package:flutter/material.dart';

import '../models/plato.dart';

class detailsScreen extends StatefulWidget{

  @override
  State<detailsScreen> createState() => _detailsScreentState();
}

class _detailsScreentState extends State<detailsScreen> {
  @override
  Widget build(BuildContext context) {
    Plato plato = ModalRoute.of(context)?.settings.arguments as Plato;

    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Framer'),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
    );
  }
}