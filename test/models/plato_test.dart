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
      expect(plato.ingredientes[1].nombre, 'Tomate');
      expect(plato.ingredientes[1].medida, '100ml');
      expect(plato.instructions, ['Cocer pasta', 'Añadir salsa']);
      expect(plato.thumbnail, 'url_imagen');
      expect(plato.link, 'url_video');
      expect(plato.category, 'Italian');
    });
  });
}
