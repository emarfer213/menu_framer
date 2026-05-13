import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:menu_framer/provider/MenuProvider.dart';

void main() {
  group('MenuProvider API Tests', () {

    test('getMealsByCategory devuelve una lista de platos si el server responde 200', () async {
      // 1. Creamos un MockClient que simula la respuesta de tu API
      final mockClient = MockClient((request) async {
        final responseData = [
          {"idMeal": "1", "strMeal": "Pizza", "strCategory": "Italian"},
          {"idMeal": "2", "strMeal": "Pasta", "strCategory": "Italian"},
        ];
        return http.Response(json.encode(responseData), 200);
      });

      final menuProvider = MenuProvider(httpClient: mockClient);

      // 2. Ejecutamos el método
      final platos = await menuProvider.getMealsByCategory('Italian');

      // 3. Verificamos los resultados
      expect(platos.length, 2);
      expect(platos[0].name, 'Pizza');
      expect(platos[1].name, 'Pasta');
    });

    test('getMealsByCategory lanza una excepción si el server responde 404', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Not Found', 404);
      });

      final menuProvider = MenuProvider(httpClient: mockClient);

      // Verificamos que el error se maneje correctamente
      expect(menuProvider.getMealsByCategory('Italian'), throwsException);
    });
  });
}