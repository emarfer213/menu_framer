import 'package:speech_to_text/speech_recognition_result.dart' as stt;
import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceController {
  final stt.SpeechToText _speech = stt.SpeechToText();

  bool _initialized = false;
  bool _listening = false;

  Function(String texto)? onCommand;

  // 🚀 INIT
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

  // 🎤 escucha continua simulada
  void _startListening() async {
    if (_listening) return;

    _listening = true;

    await _speech.listen(
      onResult: _onResult,
      listenMode: stt.ListenMode.dictation,
      partialResults: true,
      localeId: "es_ES",
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
    _listening = false;

    await _speech.stop();
    await Future.delayed(const Duration(milliseconds: 500));

    _startListening();
  }

  // 🧠 AQUÍ ESTÁ LA CLAVE
  void _onResult(stt.SpeechRecognitionResult result) {
    final texto = result.recognizedWords.toLowerCase();

    if (texto.isEmpty) return;

    print("📝 $texto");

    // 🔥 Detectar wake word + comando juntos
    if (texto.contains("asistente")) {
      final comando = texto.replaceAll("asistente", "").trim();

      // solo ejecutar cuando la frase esté finalizada
      if (result.finalResult && comando.isNotEmpty) {
        print("🧠 Ejecutando: $comando");

        if (onCommand != null) {
          onCommand!(comando);
        }
      }
    }
  }

  void dispose() {
    _speech.stop();
  }
}

final voiceController = VoiceController();
