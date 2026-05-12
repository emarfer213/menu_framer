import 'package:flutter_test/flutter_test.dart';
import 'package:menu_framer/provider/voiceControler.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

void main() {
  group('VoiceController Logic Tests', () {
    late VoiceController controller;

    setUp(() {
      controller = VoiceController();
    });

    test('Debe extraer el comando correctamente después de la palabra clave', () {
      String? commandResult;
      controller.addListener((cmd) => commandResult = cmd);

      // Corregido: Agregamos una lista vacía como segundo argumento y el confidence como tercero
      final result = SpeechRecognitionResult(
        [SpeechRecognitionWords("asistente abrir menú", [], 0.95)],
        true,
      );

      controller.handleResult(result);

      expect(commandResult, equals("abrir menú"));
    });

    test('No debe disparar nada si no se dice la palabra clave "asistente"', () {
      String? commandResult;
      controller.addListener((cmd) => commandResult = cmd);

      final result = SpeechRecognitionResult(
        [SpeechRecognitionWords("abrir menú", [], 0.95)],
        true,
      );

      controller.handleResult(result);

      expect(commandResult, isNull);
    });

    test('No debe disparar si solo se dice "asistente" sin comando', () {
      bool called = false;
      controller.addListener((cmd) => called = true);

      final result = SpeechRecognitionResult(
        [SpeechRecognitionWords("asistente", [], 0.95)],
        true,
      );

      controller.handleResult(result);

      expect(called, isFalse);
    });

    test('No debe procesar el mismo resultado final dos veces (Control de duplicados)', () {
      int callCount = 0;
      controller.addListener((cmd) => callCount++);

      final result = SpeechRecognitionResult(
        [SpeechRecognitionWords("asistente ir a inicio", [], 0.95)],
        true,
      );

      controller.handleResult(result);
      controller.handleResult(result);

      expect(callCount, equals(1));
    });

    test('Debe permitir múltiples suscriptores', () {
      int calls = 0;
      controller.addListener((cmd) => calls++);
      controller.addListener((cmd) => calls++);

      final result = SpeechRecognitionResult(
        [SpeechRecognitionWords("asistente hola", [], 0.95)],
        true,
      );

      controller.handleResult(result);

      expect(calls, equals(2));
    });
  });
}
