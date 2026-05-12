import 'package:flutter_test/flutter_test.dart';
import 'package:menu_framer/models/plato.dart';

void main() {
  group('Plato Model Tests', () {
    test('Debe crear un objeto Plato desde un JSON válido', () {
      final json = {
        'idMeal': '123',
        'strMeal': 'Pasta',
        'strCategory': 'Italian',
        'strInstructions': ['Cocer pasta', 'Añadir salsa'],
        'strMealThumb': 'url_imagen',
        'strIngredients': ['Pasta', 'Tomate'],
        'strMeasures': ['200g', '100ml'],
        'strLink': 'url_video'
      };

      final plato = Plato.fromJson(json);

      expect(plato.id, '123');
      expect(plato.name, 'Pasta');
      expect(plato.ingredientes.length, 2);
      expect(plato.ingredientes[0].nombre, 'Pasta');
      expect(plato.ingredientes[0].medida, '200g');
    });

    test('Debe manejar campos faltantes o nulos en el JSON', () {
      final json = {
        'idMeal': '456',
        'strMeal': 'Ensalada',
        // strCategory falta
        // strIngredients falta
      };

      final plato = Plato.fromJson(json);

      expect(plato.id, '456');
      expect(plato.category, ''); // Debería ser un string vacío por el null check
      expect(plato.ingredientes, isEmpty);
      expect(plato.instructions, isEmpty);
    });

    test('Debe saltar ingredientes vacíos', () {
      final json = {
        'strIngredients': ['Pollo', '', ' ', null],
        'strMeasures': ['1kg', '', '', ''],
      };

      final plato = Plato.fromJson(json);

      expect(plato.ingredientes.length, 1);
      expect(plato.ingredientes[0].nombre, 'Pollo');
    });
  });
}
