import 'package:flutter_test/flutter_test.dart';
import 'package:menu_framer/provider/voiceControler.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

void main() {
  group('VoiceController Logic Tests', () {
    late VoiceController controller;

    setUp(() {
      controller = VoiceController();
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
  });
}
