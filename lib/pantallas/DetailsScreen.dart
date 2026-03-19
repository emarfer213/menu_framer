import 'package:flutter/material.dart';
import 'package:menu_framer/models/VideoDialog.dart';
import '../models/plato.dart';
import '../provider/MenuProvider.dart';

class DetailsScreen extends StatefulWidget {
  @override
  State<DetailsScreen> createState() => _detailsScreentState();
}

class _detailsScreentState extends State<DetailsScreen> {
  late Future<Plato?> platoFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Plato plato = ModalRoute.of(context)?.settings.arguments as Plato;

    platoFuture = MenuProvider().getMealDetail(plato.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Menu Framer'), backgroundColor: Colors.amber, centerTitle: true),
      body: SafeArea(
        child: FutureBuilder<Plato?>(
          future: platoFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            final plato = snapshot.data!;

            return SingleChildScrollView(
              child: Column(
                spacing: 40,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(
                    child: Container(
                      padding: EdgeInsets.only(top: 20),
                      child: Image.network(plato.thumbnail, height: 400, width: 400),
                    ),
                  ),

                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => VideoDialog(
                            videoUrl: plato.link,
                          ),
                        );
                      },
                      icon: Icon(Icons.play_arrow, color: Colors.white,),
                      label: Text("Ver preparación", style: TextStyle(color: Colors.white),),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                    ),
                  ),

                  Column(
                    children: [
                      Center(child: Text('Los ingredientes necesarios para la preparacion seran:')),
                      ...plato.ingredientes.map(
                        (ingrediente) => Center(child: Text("• ${ingrediente.nombre}: ${ingrediente.medida}")),
                      ),
                    ],
                  ),

                  Container(
                    padding: EdgeInsetsGeometry.only(bottom: 20),
                    child: Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(context, '/pasosScreen', arguments: plato);
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                        label: Text("Intentar", style: TextStyle(color: Colors.white, fontSize: 20)),
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
