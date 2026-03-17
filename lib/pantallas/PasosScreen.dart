import 'package:flutter/material.dart';
import '../models/plato.dart';
import '../provider/MenuProvider.dart';
import 'package:carousel_slider/carousel_slider.dart';

class PasosScreen extends StatefulWidget {
  @override
  State<PasosScreen> createState() => _pasosScreentState();
}

class _pasosScreentState extends State<PasosScreen> {
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
      appBar: AppBar(
        title: Text('Menu Framer'),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: SafeArea(
          child: FutureBuilder(
            future: platoFuture,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              final plato = snapshot.data!;

              return CarouselSlider(
                options: CarouselOptions(
                    height: 400.0,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 5),
                  autoPlayAnimationDuration: const Duration(seconds: 2)
                ),
                items: plato.instructions.map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        padding: EdgeInsetsGeometry.only(top: 50),
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                              color: Colors.amber
                          ),
                          child: Text(i, style: TextStyle(fontSize: 16.0),)
                      );
                    },
                  );
                }).toList(),
              );
            }
          )
      ),
    );
  }
}
