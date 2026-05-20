import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../models/plato.dart';
import '../provider/MenuProvider.dart';
import '../provider/UserProvider.dart';
import '../provider/VoiceControler.dart';

class PasosScreen extends StatefulWidget {
  const PasosScreen({super.key});

  @override
  State<PasosScreen> createState() => _PasosScreentState();
}

class _PasosScreentState extends State<PasosScreen> {
  final CarouselSliderController _controller = CarouselSliderController(); // Controlador del carrusel.
  late Future<Plato?> platoFuture; // Futuro que su utilizara para obtener las instrucciones del plato.
  int _currentSlide = 0; // Índice de la diapositiva en la cual inicia el carrusel.
  final Map<int, int> _pageTimes = {}; // Almacena los segundos acumulados por cada índice de página.
  Timer? _timer; // Referencia al temporizador periódico que actualiza el contador cada segundo.

  @override
  void initState() {
    super.initState();
    voiceController.addListener(_handleVoiceCommand);
  }

  @override
  void dispose() {
    voiceController.removeListener(_handleVoiceCommand);
    _timer?.cancel(); //Detenemos el temporizador.
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Obtenemos el objeto Plato pasado como argumento desde la pantalla de detalles.
    final Plato plato = ModalRoute.of(context)?.settings.arguments as Plato;
    // Iniciamos la petición para obtener el detalle completo del plato para posteriormente obtener las instrucciones.
    platoFuture = MenuProvider().getMealDetail(plato.id);
  }

  // Manejador de comandos de voz específicos para la fase de preparación.
  Future<void> _handleVoiceCommand(String texto) async {
    if (!mounted || !(ModalRoute.of(context)?.isCurrent ?? false)) return;
    texto = texto.toLowerCase().trim();

    print("PasosScreen recibió comando de voz: $texto");
    // Comando "terminar": Finaliza el proceso y vuelve a la pantalla inicial de tipos.
    if (texto.contains("terminar")) {
      await finalizarPLato();
      return;
    }
    // 3. Añadimos comandos para navegar por el carrusel
    if (texto.contains("siguiente")) {
      _controller.nextPage();
      return;
    }
    if (texto.contains("anterior")) {
      _controller.previousPage();
      return;
    }
    //Comandos de retroceso: Permiten volver a la pantalla de detalles del plato.
    if (texto.contains("volver") || texto.contains("atrás") || texto.contains("atras")) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      return;
    }
  }

  /**
   * Inicia o reinicia el temporizador de tiempo por paso.
   * Se ejecuta cada vez que el usuario cambia de diapositiva en el carrusel.
   */
  void _startTimer() {
    if (_timer != null && _timer!.isActive) return;

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        // Incrementamos el tiempo acumulado de la diapositiva que está activa en este momento
        _pageTimes[_currentSlide] = (_pageTimes[_currentSlide] ?? 0) + 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menu Framer'), backgroundColor: Colors.amber, centerTitle: true),

      body: SafeArea(
        child: FutureBuilder<Plato?>(
          future: platoFuture,
          builder: (context, snapshot) {
            // Mientras no haya datos, mostramos una animacion de carga.
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            /**
             * Una vez cargados los datos, iniciamos el temporizador para el primer paso. Y
             * usamos addPostFrameCallback para evitar llamar a setState durante la construcción.
             */
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_timer == null) {
                _startTimer();
              }
            });

            final plato = snapshot.data!;

            return Column(
              children: [
                const SizedBox(height: 20),

                // CARRUSEL PRINCIPAL
                Expanded(
                  child: CarouselSlider(
                    carouselController: _controller, // ASIGNAMOS EL CONTROLADOR
                    options: CarouselOptions(
                      height: double.infinity,
                      autoPlay: false,
                      autoPlayAnimationDuration: const Duration(seconds: 2),
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentSlide = index;
                        });
                        // Reiniciamos el tiempo al cambiar de paso
                        _startTimer();
                      },
                    ),

                    // Mapeamos la lista de instrucciones a una lista de diapositivas
                    items: plato.instructions.asMap().entries.map((entry) {
                      int index = entry.key;
                      String instruccion = entry.value;

                      return Builder(
                        builder: (BuildContext context) {
                          return Stack(
                            children: [
                              //Imagen de fondo y texto de la instrucción
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                                height: double.infinity,
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.amber, width: 9),
                                  image: DecorationImage(
                                    image: NetworkImage(plato.thumbnail),
                                    fit: BoxFit.cover,
                                    opacity: 0.7, // Opacidad para facilitar la lectura del texto
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    instruccion,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      shadows: [Shadow(blurRadius: 6, color: Colors.white, offset: Offset(2, 2))],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),

                              //Indicador del numero del paso en el que se encuentra la diapositiva en la esquina inferior derecha
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

                              //Temporizador en la esquina superior derecha.
                              if (_currentSlide == index)
                                Positioned(
                                  top: 10,
                                  right: 14,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                    color: Colors.black54,
                                    child: Text(
                                      "Tiempo: ${_pageTimes[index] ?? 0} s",
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

                // Boton que finalizara el intento de preparacion y regresara a la pantalla principal.
                Container(
                  padding: const EdgeInsets.all(50),
                  child: Center(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await finalizarPLato();
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                      label: const Text("Terminar", style: TextStyle(color: Colors.white, fontSize: 20)),
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

  Future<void> finalizarPLato() async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final String? uid = userProvider.user?.uid ?? FirebaseAuth.instance.currentUser?.uid;

      if (uid != null) {
        print("Intentando guardar progreso para: $uid");

        await FirebaseFirestore.instance.collection('usuarios').doc(uid).set({
          'platosPreparados': FieldValue.increment(1),
        }, SetOptions(merge: true));

        userProvider.incrementarPlatosHoy();

        print("Incremento realizado con éxito");
      } else {
        print("No se pudo realizar el incremento: Usuario no identificado");
      }
    } catch (e) {
      print("Error crítico en finalizarPLato: $e");
    }

    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/principalScreen', (route) => false);
    }
  }
}
