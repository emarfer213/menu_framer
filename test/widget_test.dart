import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:menu_framer/pantallas/LoginScreen.dart';
import 'package:menu_framer/provider/UserProvider.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('Validación de campos en Login', (WidgetTester tester) async {
    // Cargamos el widget necesario para el test
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider(
          create: (_) => UserProvider(), // Nota: Esto fallará si el Provider inicializa Firebase
          child: const LoginScreen(),
        ),
      ),
    );

    // Buscamos el botón de aceptar y lo pulsamos
    final botonAceptar = find.byType(ElevatedButton);
    await tester.tap(botonAceptar);
    await tester.pump(); // Re-renderizar para mostrar errores de validación

    // Verificamos que los mensajes de error de los campos obligatorios aparecen
    expect(find.text('El correo es obligatorio'), findsOneWidget);
    expect(find.text('La contraseña es obligatorio'), findsOneWidget);
  });
}