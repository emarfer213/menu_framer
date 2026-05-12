import 'package:speech_to_text/speech_recognition_result.dart' as stt;
import 'package:speech_to_text/speech_to_text.dart' as stt;

/** Creamos un controlador encargado de gestionar el reconocimiento por voz en la aplicación. */
class VoiceController {
  final stt.SpeechToText _speech;
  bool _initialized = false;
  bool _listening = false;
  final List<Function(String)> _listeners = [];
  String _lastProcessed = "";

  // Constructor que permite inyectar un motor de voz (útil para tests)
  VoiceController({stt.SpeechToText? speechEngine})
      : _speech = speechEngine ?? stt.SpeechToText();

  void addListener(Function(String) listener) {
    if (!_listeners.contains(listener)) {
      _listeners.add(listener);
    }
  }

  void removeListener(Function(String) listener) {
    _listeners.remove(listener);
  }

  Future<void> init() async {
    if (_initialized) return;

    _initialized = await _speech.initialize(
      onStatus: _onStatus,
      onError: (error) {
        print("Error: $error");
        _restartListening();
      },
    );

    if (_initialized) {
      _startListening();
    }
  }

  void _startListening() async {
    if (_listening || !_initialized) return;
    _listening = true;

    await _speech.listen(
      onResult: handleResult, // Ahora llamamos a un método visible para tests
      listenMode: stt.ListenMode.dictation,
      partialResults: true,
      localeId: "es_ES",
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 5),
    );
  }

  void _onStatus(String status) {
    if (status == "done" || status == "notListening") {
      _restartListening();
    }
  }

  void _restartListening() async {
    if (!_initialized) return;
    _listening = false;
    _lastProcessed = "";
    await _speech.stop();
    await Future.delayed(const Duration(milliseconds: 300));
    _startListening();
  }

  // Este método procesa el texto. Lo testearemos directamente.
  void handleResult(stt.SpeechRecognitionResult result) {
    final texto = result.recognizedWords.toLowerCase().trim();

    if (texto.isEmpty || (result.finalResult && texto == _lastProcessed)) return;

    if (result.finalResult) {
      _lastProcessed = texto;
    }

    const String trigger = "asistente";

    if (texto.contains(trigger)) {
      final index = texto.indexOf(trigger);
      final comando = texto.substring(index + trigger.length).trim();

      if (result.finalResult && comando.isNotEmpty) {
        final targets = List<Function(String)>.from(_listeners);
        for (final listener in targets) {
          listener(comando);
        }
      }
    }
  }

  void stopService() {
    _initialized = false;
    _listening = false;
    _speech.stop();
  }

  void dispose() {
    stopService();
  }
}

final voiceController = VoiceController();
