import 'package:flutter/material.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                hintText: "First Name",
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
                hintText: "Second Name",
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
