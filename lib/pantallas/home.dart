import 'package:flutter/material.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isHover=false;

  @override
  Widget build(BuildContext context) {
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
            spacing: 50,
            children: [
              Center(
                child: SizedBox(
                  width: 300,
                  height: 300,
                  child: Image.asset("cocina.jpg"),
                ),
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
              InkWell(
                onTap: (){
                  Navigator.pushNamed(context, '/registerScreen');
                },
                onHover: (val){
                  setState(() {
                    print(Text("¿No tienes una cuenta? Regístrate", style: TextStyle(color: Colors.blue),));
                    isHover = val;
                  });
                },
                child: Text("¿No tienes una cuenta? Regístrate"),
              )
            ],
          ),
        ),
      ),
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
