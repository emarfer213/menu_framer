import 'package:speech_to_text/speech_recognition_result.dart' as stt;
import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceController {
  final stt.SpeechToText _speech = stt.SpeechToText();

  bool _initialized = false;
  bool _listening = false;

  Function(String texto)? onCommand;

  Future<void> init() async {
    if (_initialized) return;

    _initialized = await _speech.initialize(
      onStatus: _onStatus,
      onError: (error) {
        print("❌ Error: $error");
        _restartListening();
      },
    );

    print("🎤 Inicializado: $_initialized");

    if (_initialized) {
      _startListening();
    }
  }

  void _startListening() async {
    if (_listening) return;

    _listening = true;

    await _speech.listen(
      onResult: _onResult,
      listenMode: stt.ListenMode.dictation,
      partialResults: true,
      localeId: "es_ES",
      listenFor: const Duration(seconds: 30), // ⏱ máximo permitido
      pauseFor: const Duration(seconds: 5),   // ⏸ silencio antes de cortar
    );

    print("👂 Escuchando...");
  }

  void _onStatus(String status) {
    print("📊 Status: $status");

    if (status == "done" || status == "notListening") {
      _restartListening();
    }
  }

  void _restartListening() async {
    if (!_initialized) return;

    _listening = false;

    await _speech.stop();

    // 🔥 reinicio rápido (clave)
    await Future.delayed(const Duration(milliseconds: 300));

    _startListening();
  }

  void _onResult(stt.SpeechRecognitionResult result) {
    final texto = result.recognizedWords.toLowerCase();

    if (texto.isEmpty) return;

    print("📝 $texto");

    if (texto.contains("asistente")) {
      final comando = texto.replaceAll("asistente", "").trim();

      if (result.finalResult && comando.isNotEmpty) {
        print("🧠 Ejecutando: $comando");

        onCommand?.call(comando);
      }
    }
  }

  void dispose() {
    _speech.stop();
  }
}

final voiceController = VoiceController();