import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String correo = "";
  String contrasenia = "";
  String? errorMesage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu framer'),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          color: Colors.grey[300],
          child: Column(
            spacing: 25,
            children: [
              Center(
                child: SizedBox(
                  width: 300,
                  height: 300,
                  child: Image.asset("cocina2.jpg"),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  'Introduzca sus datos',
                  textAlign: TextAlign.center,
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  spacing: 10,
                  children: [
                    Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: "Correo",
                            border: OutlineInputBorder(),
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'El correo es obligatorio';
                            }


                            if (!value.contains("@")) {
                              return "Correo no válido";
                            }

                            if (errorMesage != null) {
                              return errorMesage;
                            }
                            return null;
                          },
                          onChanged: (value) => {
                            setState(() {
                              correo = value;
                              errorMesage = null; // limpia error al escribir
                            }),
                          },
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: "Contraseña",
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "La contraseña es obligatorio";
                            }

                            if (errorMesage != null) {
                              return errorMesage;
                            }
                            return null;
                          },
                          onChanged: (value) => {
                            setState(() {
                              contrasenia = value;
                              errorMesage = null; // limpia error al escribir
                            }),
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: correo,
                        password: contrasenia,
                      );
                    } on FirebaseAuthException catch (e) {
                      setState(() {
                        errorMesage = "Valores introducidos incorrectos";
                      });
                      _formKey.currentState!.validate();
                    }
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                label: Text("Aceptar", style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}