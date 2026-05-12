import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:menu_framer/pantallas/PricipalScreen.dart';
import 'package:menu_framer/pantallas/UsuarioScreen.dart';
import 'package:menu_framer/pantallas/PasosScreen.dart';
import 'package:menu_framer/pantallas/PlatosScreen.dart';
import 'package:provider/provider.dart';
import 'package:menu_framer/pantallas/DetailsScreen.dart';
import 'package:menu_framer/pantallas/LoginScreen.dart';
import 'package:menu_framer/pantallas/RegisterScreen.dart';
import 'package:menu_framer/pantallas/TipoScreen.dart';
import 'package:menu_framer/provider/MenuProvider.dart';
import 'package:menu_framer/provider/UserProvider.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Bloquear la orientación a vertical únicamente
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MenuProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/loginScreen': (context) => LoginScreen(),
        '/registerScreen': (context) => RegisterScreen(),
        '/tipoScreen': (context) => TipoScreen(),
        '/platoScreen': (context) => PlatoScreen(),
        '/detailsScreen': (context) => DetailsScreen(),
        '/pasosScreen': (context) => PasosScreen(),
        '/userScreen': (context) => UsuarioScreen(),
        '/principalScreen': (context) => const PrincipalScreen(),
      },
      home: Consumer<UserProvider>(
        builder: (context, userProv, _) {
          if (userProv.user == null) {
            return const LoginScreen();
          }
          if (userProv.isLoading) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          return const PrincipalScreen();
        },
      ),
    );
  }
}
