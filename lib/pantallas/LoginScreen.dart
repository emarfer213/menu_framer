import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String? errorMensage;
  bool isHover = false;
  String correo = "";
  String contrasenia = "";

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
            spacing: 50,
            children: [
              Center(
                child: SizedBox(
                  width: 300,
                  height: 300,
                  child: Image.asset("cocina.jpg"),
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

                            if (errorMensage != null) {
                              return errorMensage;
                            }
                            return null;
                          },
                          onChanged: (value) => {
                            setState(() {
                              correo = value;
                              errorMensage = null; // limpia error al escribir
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

                            if (errorMensage != null) {
                              return errorMensage;
                            }
                            return null;
                          },
                          onChanged: (value) => {
                            setState(() {
                              contrasenia = value;
                              errorMensage = null; // limpia error al escribir
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
                        errorMensage = "Valores introducidos incorrectos";
                      });
                      _formKey.currentState!.validate();
                    }
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                label: Text("Aceptar", style: TextStyle(color: Colors.black)),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/registerScreen');
                },
                onHover: (val) {
                  setState(() {
                    print(
                      Text(
                        "¿No tienes una cuenta? Regístrate",
                        style: TextStyle(color: Colors.blue),
                      ),
                    );
                    isHover = val;
                  });
                },
                child: Text("¿No tienes una cuenta? Regístrate"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
