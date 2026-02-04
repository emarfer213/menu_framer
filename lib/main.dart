import 'package:flutter/material.dart';
import 'package:menu_framer/pantallas/entranteScreen.dart';
import 'package:menu_framer/pantallas/home.dart';
import 'package:menu_framer/pantallas/postreScreen.dart';
import 'package:menu_framer/pantallas/primerPlatoScreen.dart';
import 'package:menu_framer/pantallas/registerScreen.dart';
import 'package:menu_framer/pantallas/segundoPlatoScreen.dart';
import 'package:menu_framer/pantallas/tipoScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => homeScreen(),
        '/registerScreen': (context) => registerScreen(),
        '/tipoScreen': (context) => tipoScreen(),
        '/entranteScreen': (context) => entranteScreen(),
        '/primerPlatoScreen': (context) => primerPlatoScreen(),
        '/segundoPlatoScreen': (context) => segundoPlatoScreen(),
        '/postreScreen': (context) => postreScreen(),
      },
    );
  }
}
