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

      final result = SpeechRecognitionResult(
        [SpeechRecognitionWords("asistente abrir menú", [], 0.95)],
        true,
      );

      controller.handleResult(result);

      expect(commandResult, equals("abrir menú"));
    });

    test('No debe activar nada si no se dice la palabra clave asistente', () {
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
  });
}
