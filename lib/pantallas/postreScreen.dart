import 'package:flutter/material.dart';

class postreScreen extends StatefulWidget{
  const postreScreen({super.key});

  @override
  State<postreScreen> createState() => _postreScreentState();
}

class _postreScreentState extends State<postreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Postre'),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
    );
  }
}