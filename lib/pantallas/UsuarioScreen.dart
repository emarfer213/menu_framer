import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/UserProvider.dart';

class UsuarioScreen extends StatefulWidget {
  const UsuarioScreen({super.key});

  @override
  State<UsuarioScreen> createState() => _UsuarioScreenState();
}

class _UsuarioScreenState extends State<UsuarioScreen> {
  final _formKey = GlobalKey<FormState>();
  String? errorMesage;
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    // Obtenemos los datos del usuario global
    final userProvider = Provider.of<UserProvider>(context);
    final datos = userProvider.userData;

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text("Hola, ${datos?['correo'] ?? 'Cargando...'}"),
            Text("Platos terminados: ${datos?['platosPreparados'] ?? 0}"),
          ],
        ),
      ),
    );
  }
}
