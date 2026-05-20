import 'package:flutter/material.dart';
import 'package:menu_framer/screens/TipoScreen.dart';
import 'package:menu_framer/screens/UsuarioScreen.dart';

class PrincipalScreen extends StatefulWidget {
  const PrincipalScreen({super.key});

  @override
  State<PrincipalScreen> createState() => _PrincipalScreenState();
}

class _PrincipalScreenState extends State<PrincipalScreen> {
  List<Widget> listaPantallas = [TipoScreen(), UsuarioScreen()];
  int indicePantallaActual = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: listaPantallas[indicePantallaActual],

      bottomNavigationBar: NavigationBar(
          backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,

          destinations: [
            NavigationDestination(icon: Icon(Icons.list), label: "Menu"),
            NavigationDestination(icon: Icon(Icons.person), label: "Usuario"),
          ],

          selectedIndex: indicePantallaActual,
          onDestinationSelected: (nuevoIndicePantalla) {
            setState(() {
              indicePantallaActual = nuevoIndicePantalla;
            });
          }
      ),
    );
  }
}
