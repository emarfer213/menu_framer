import 'package:speech_to_text/speech_recognition_result.dart' as stt;
import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceController {
  final stt.SpeechToText _speech = stt.SpeechToText();

  bool _isInitialized = false;
  bool _isListening = false;
  bool _modoComando = false;

  Function(String texto)? onCommand;

  Future<void> init() async {
    if (_isInitialized) return;

    _isInitialized = await _speech.initialize(
      onStatus: _onStatus,
      onError: (error) {
        print("Error: $error");
        _restartListening();
      },
    );

    if (_isInitialized) {
      _startListening();
    }
  }

  void _startListening() async {
    if (_isListening) return;

    _isListening = true;

    await _speech.listen(
      onResult: _onResult,
      listenMode: stt.ListenMode.dictation,
      partialResults: true,
      localeId: "es_ES",
    );

    print("Escuchando...");
  }

  void _onStatus(String status) {
    if (status == "done" || status == "notListening") {
      _restartListening();
    }
  }

  void _restartListening() async {
    if (!_isInitialized) return;

    _isListening = false;

    await _speech.stop();
    await Future.delayed(const Duration(milliseconds: 500));

    _startListening();
  }

  void _onResult(stt.SpeechRecognitionResult result) {
    final texto = result.recognizedWords.toLowerCase();

    if (texto.isEmpty) return;

    print(texto);

    if (!_modoComando) {
      if (texto.contains("asistente")) {
        print("Wake word detectada");
        _modoComando = true;
      }
      return;
    }

    if (result.finalResult) {
      print("Ejecutando comando");

      if (onCommand != null) {
        onCommand!(texto);
      }

      _modoComando = false;
    }
  }

  void dispose() {
    _speech.stop();
  }
}

final voiceController = VoiceController();
