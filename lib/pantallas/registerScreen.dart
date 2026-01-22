import 'package:flutter/material.dart';

class registerScreen extends StatefulWidget{
  const registerScreen({super.key});

  @override
  State<registerScreen> createState() => _registerScreenState();
}

class _registerScreenState extends State<registerScreen>{
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          title: Text(
              'Menu framer'
          ),
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
                Center(
                  child: Text('Introduzca sus datos'),
                ),
                camposTextHomeScreen(),
                ElevatedButton.icon(
                  onPressed: () {
                    //Navigator.pushNamed(context, '/terms_conditions.dart');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(239, 56, 103, 1),
                  ),
                  label: Text("Aceptar", style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
          ),
        )
    );
  }
}

class camposTextHomeScreen extends StatelessWidget {
  const camposTextHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
            ),
          ),
        ),
      ],
    );
  }
}

