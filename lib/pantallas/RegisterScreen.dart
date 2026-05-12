import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/UserProvider.dart';

// Pantalla que permite a los nuevos usuarios registrarse en la aplicación.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String nombre = ""; // variable del nombre de usuario.
  String correo = ""; // variable del correo electrónico.
  String contrasenia = ""; //Contraseña introducida por el usuario.
  String? errorMesage = ""; // Variable que almacena mensajes de error devueltos por la lógica de validación o Firebase.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300], // Fondo fuera del scroll para que no se corte
      appBar: AppBar(title: const Text('Menu framer'), backgroundColor: Colors.amber, centerTitle: true),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            // El scroll permite que el contenido suba cuando aparece el teclado
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 25,
                children: [
                  // Imagen decorativa ajustada a un tamaño más seguro.
                  Center(child: SizedBox(width: 250, height: 250, child: Image.asset("assets/cocina2.jpg"))),
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: const Text(
                      'Introduzca sus datos',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      spacing: 15,
                      children: [
                        Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                hintText: "Nombre",
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              validator: (String? value) {
                                // mensaje de error pesonalizados dependiendo del fallo cometido por el usario
                                if (value == null || value.isEmpty) {
                                  return 'El nombre de usuario es obligatorio';
                                }
                                if (errorMesage != null && errorMesage!.isNotEmpty) {
                                  return errorMesage;
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  nombre = value;
                                  errorMesage = null; // Limpia error al escribir.
                                });
                              },
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                hintText: "Correo",
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              validator: (String? value) {
                                // mensaje de error pesonalizados dependiendo del fallo cometido por el usario
                                if (value == null || value.isEmpty) {
                                  return 'El correo es obligatorio';
                                }
                                if (!value.contains("@")) {
                                  return "Correo no válido";
                                }
                                if (errorMesage != null && errorMesage!.isNotEmpty) {
                                  return errorMesage;
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  correo = value;
                                  errorMesage = null; // Limpia error al escribir.
                                });
                              },
                            ),
                          ),
                        ),
                        // Campo de entrada para la contraseña.
                        Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            child: TextFormField(
                              obscureText: true,
                              decoration: const InputDecoration(
                                hintText: "Contraseña",
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              validator: (value) {
                                // mensaje de error al dejar la contraseña en blanco
                                if (value == null || value.isEmpty) {
                                  return "La contraseña es obligatorio";
                                }
                                if (errorMesage != null && errorMesage!.isNotEmpty) {
                                  return errorMesage;
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  contrasenia = value;
                                  errorMesage = null; // Limpia error al escribir.
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Botón de acción para realizar el registro.
                  ElevatedButton.icon(
                    // lib/pantallas/RegisterScreen.dart
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Obtenemos el provider sin escuchar cambios (listen: false)
                        final userProvider = Provider.of<UserProvider>(context, listen: false);
                        // Llamamos al método register que centraliza FirebaseAuth y Firestore
                        String? error = await userProvider.register(correo, contrasenia, nombre);

                        if (error != null) {
                          setState(() {
                            errorMesage = error;
                          });
                          _formKey.currentState!.validate();
                        } else {
                          if (mounted) Navigator.pop(context);
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                    label: const Text("Aceptar", style: TextStyle(color: Colors.black, fontSize: 18)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
