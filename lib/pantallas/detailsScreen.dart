import 'package:flutter/material.dart';

import '../models/plato.dart';
import '../services/primer_plato_service.dart';

class detailsScreen extends StatefulWidget {
  @override
  State<detailsScreen> createState() => _detailsScreentState();
}

class _detailsScreentState extends State<detailsScreen> {
  late Future<Plato> platoFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Plato plato = ModalRoute.of(context)?.settings.arguments as Plato;

    platoFuture = MealService().getMealDetail(plato.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Framer'),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: SafeArea(
        child: FutureBuilder<Plato>(
          future: platoFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            final plato = snapshot.data!;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Center(
                    child: Container(
                      padding: EdgeInsets.only(top: 20),
                      child: Image.network(
                        plato.thumbnail,
                        height: 400,
                        width: 400,
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  Center(child: Text(plato.instructions)),

                  SizedBox(height: 20),

                  ...plato.ingredientes.map(
                    (ingrediente) =>
                        Center(child: Text("• ${ingrediente.nombre}: ${ingrediente.medida}")),
                  ),

                  SizedBox(height: 20),

                  Container(
                    padding: EdgeInsetsGeometry.only(bottom: 20),
                    child: Center(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                        ),
                        label: Text(
                          "Intentar",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
