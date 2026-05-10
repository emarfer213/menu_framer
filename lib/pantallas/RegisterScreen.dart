import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Pantalla que permite a los nuevos usuarios registrarse en la aplicación.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String correo = ""; // variable del correo electrónico.
  String contrasenia = ""; //Contraseña introducida por el usuario.
  String? errorMesage = ""; // Variable que almacena mensajes de error devueltos por la lógica de validación o Firebase.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menu framer'), backgroundColor: Colors.amber, centerTitle: true),
      body: SafeArea(
        child: Container(
          color: Colors.grey[300],
          child: Column(
            spacing: 25,
            children: [
              // Imagen decorativa.
              Center(child: SizedBox(width: 300, height: 300, child: Image.asset("assets/cocina2.jpg"))),
              Container(
                padding: const EdgeInsets.only(top: 20),
                child: const Text('Introduzca sus datos', textAlign: TextAlign.center),
              ),
              Form(
                key: _formKey,
                child: Column(
                  spacing: 10,
                  children: [
                    // Campo de entrada para el correo electrónico.
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: TextFormField(
                          decoration: const InputDecoration(hintText: "Correo", border: OutlineInputBorder()),
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
                          decoration: const InputDecoration(hintText: "Contraseña", border: OutlineInputBorder()),
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
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      // Usamos createUserWithEmailAndPassword para registrar nuevos usuarios.
                      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: correo, password: contrasenia);
                      // Una vez registrado, Firebase suele loguear al usuario automáticamente.
                    } on FirebaseAuthException catch (e) {
                      setState(() {
                        // Manejo de errores diversos que puede dar firebase.
                        if (e.code == 'email-already-in-use') {
                          errorMesage = "El correo ya está en uso";
                        } else if (e.code == 'weak-password') {
                          errorMesage = "La contraseña es muy débil";
                        } else {
                          errorMesage = "Error en el registro";
                        }
                      });
                      _formKey.currentState!.validate();
                    }
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                label: const Text("Aceptar", style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
