import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:menu_framer/provider/UserProvider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String? errorMesage; // Almacena el mensaje de error devuelto por Firebase o Provider.
  bool isHover = false; // Controla si el ratón está sobre el enlace de registro.
  String correo = ""; // Variable del correo electrónico introducido por el usuario.
  String contrasenia = ""; //Variable de la contraseña introducida por el usuario.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(title: const Text('Menu framer'), backgroundColor: Colors.amber, centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              spacing: 40,
              children: [
                Center(child: SizedBox(width: 280, height: 280, child: Image.asset("assets/cocina.jpg"))),
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
                              hintText: "Correo",
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'El correo es obligatorio';
                              }
                              if (errorMesage != null) {
                                return errorMesage;
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                correo = value;
                                errorMesage = null;
                              });
                            },
                          ),
                        ),
                      ),
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
                              if (value == null || value.isEmpty) {
                                return "La contraseña es obligatorio";
                              }
                              if (errorMesage != null) {
                                return errorMesage;
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                contrasenia = value;
                                errorMesage = null;
                              });
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
                      final userProvider = Provider.of<UserProvider>(context, listen: false);
                      String? error = await userProvider.login(correo, contrasenia);
                      
                      if (error != null) {
                        setState(() {
                          errorMesage = error;
                        });
                        _formKey.currentState!.validate();
                      } else {
                        // Navegamos a la pantalla principal si el login es exitoso
                        if (mounted) {
                          Navigator.pushNamedAndRemoveUntil(context, '/principalScreen', (route) => false);
                        }
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  label: const Text("Aceptar", style: TextStyle(color: Colors.black, fontSize: 18)),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/registerScreen');
                  },
                  onHover: (val) {
                    setState(() {
                      isHover = val;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      "¿No tienes una cuenta? Regístrate",
                      style: TextStyle(
                        color: isHover ? Colors.blue : Colors.black,
                        decoration: isHover ? TextDecoration.underline : TextDecoration.none,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
