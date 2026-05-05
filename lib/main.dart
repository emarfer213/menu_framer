import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:menu_framer/pantallas/PasosScreen.dart';
import 'package:menu_framer/pantallas/PlatosScreen.dart';
import 'package:provider/provider.dart';
import 'package:menu_framer/pantallas/DetailsScreen.dart';
import 'package:menu_framer/pantallas/tiposScreen/EntranteScreen.dart';
import 'package:menu_framer/pantallas/LoginScreen.dart';
import 'package:menu_framer/pantallas/tiposScreen/PostreScreen.dart';
import 'package:menu_framer/pantallas/tiposScreen/PrimerPlatoScreen.dart';
import 'package:menu_framer/pantallas/RegisterScreen.dart';
import 'package:menu_framer/pantallas/tiposScreen/SegundoPlatoScreen.dart';
import 'package:menu_framer/pantallas/TipoScreen.dart';
import 'package:menu_framer/provider/MenuProvider.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ChangeNotifierProvider(create: (_) => MenuProvider(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/registerScreen': (context) => RegisterScreen(),
        '/tipoScreen': (context) => TipoScreen(),
        '/entranteScreen': (context) => EntranteScreen(),
        '/platoScreen': (context) => PlatoScreen(),
        '/primerPlatoScreen': (context) => PrimerPlatoScreen(),
        '/segundoPlatoScreen': (context) => SegundoPlatoScreen(),
        '/postreScreen': (context) => PostreScreen(),
        '/detailsScreen': (context) => DetailsScreen(),
        '/pasosScreen': (context) => PasosScreen(),
      },
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          if (snapshot.hasData) {
            return const TipoScreen();
          }
          return const LoginScreen();
        },
      ),
    );
  }
}
