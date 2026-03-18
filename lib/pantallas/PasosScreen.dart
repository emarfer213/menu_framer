import 'dart:async';

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
  int _currentSlide = 0;
  int _elapsedSeconds = 0;
  Timer? _timer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Plato plato = ModalRoute.of(context)?.settings.arguments as Plato;
    platoFuture = MenuProvider().getMealDetail(plato.id);
  }

  void _startTimer() {
    _timer?.cancel();
    _elapsedSeconds = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _elapsedSeconds++;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Menu Framer'), backgroundColor: Colors.amber, centerTitle: true),
      body: SafeArea(
        child: FutureBuilder(
          future: platoFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_timer == null) {
                _startTimer();
              }
            });

            final plato = snapshot.data!;

            return Column(
              children: [
                const SizedBox(height: 20),
                Expanded(
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: double.infinity,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 10),
                      autoPlayAnimationDuration: const Duration(seconds: 2),
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentSlide = index;
                        });
                        _startTimer();
                      },
                    ),
                    items: plato.instructions.asMap().entries.map((entry) {
                      int index = entry.key;
                      String i = entry.value;

                      return Builder(
                        builder: (BuildContext context) {
                          return Stack(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 100),
                                height: double.infinity,
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.amber, width: 9),
                                  image: DecorationImage(image: NetworkImage(plato.thumbnail), fit: BoxFit.cover, opacity: 0.7),
                                ),
                                child: Center(
                                  child: Text(
                                    i,
                                    style: const TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.pink,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),

                              Positioned(
                                bottom: 9,
                                right: 14,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                  color: Colors.black54,
                                  child: Text(
                                    "${index + 1} / ${plato.instructions.length}",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),

                              if (_currentSlide == index)
                                Positioned(
                                  top: 10,
                                  right: 14,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                    color: Colors.black54,
                                    child: Text(
                                      "Tiempo: $_elapsedSeconds s",
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
                Container(
                  padding: EdgeInsetsGeometry.all(50),
                  child: Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text(
                                "Estas apunto de finalizar la preparacion de un plato. ¿Deseas continuar?",
                              ),
                              content: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () async {
                                      Navigator.pushNamed(context, '/tipoScreen');
                                    },
                                    label: const Row(children: [Icon(Icons.check), Text("Confirmar")]),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    label: const Row(children: [Icon(Icons.cancel_outlined), Text("Cancelar")]),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                      label: Text("Terminar", style: TextStyle(color: Colors.white, fontSize: 20)),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
