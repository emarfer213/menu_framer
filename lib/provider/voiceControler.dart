import 'package:speech_to_text/speech_recognition_result.dart' as stt;
import 'package:speech_to_text/speech_to_text.dart' as stt;

/** Creamos un controlador encargado de gestionar el reconocimiento por voz en la aplicación.
 * Utilizamos el paquete `speech_to_text` para convertir voz en texto, que nos permitira
 * interactuar con la aplicación mediante comandos de voz.
 */
class VoiceController {
  final stt.SpeechToText _speech = stt.SpeechToText(); // Creamos una variable para el reconocimiento por voz
  bool _initialized = false; // Establecemos que el reconocimiento por voz no esta inicializado aun.
  bool _listening = false; // Indicamos si el micrófono está actualmente escuchando.
  final List<Function(String)> _listeners = []; // Lista de funciones de callback que se ejecutan cuando se reconoce un comando.
  String _lastProcessed = ""; // Para evitar duplicados

  //Funcion que registra un nuevo [listener] que será notificado al reconocer un comando.
  void addListener(Function(String) listener) {
    if (!_listeners.contains(listener)) {
      _listeners.add(listener);
    }
  }

  // Funion que elimina un [listener] previamente registrado de la lista de notificaciones.
  void removeListener(Function(String) listener) {
    _listeners.remove(listener);
  }

  /**
   * Inicializa el servicio de reconocimiento de voz y comienza la escucha continua.
   * En caso de ya estar inicializado no hara nada. Ademas si falla la inicializacion reinicia la escucha.
   */
  Future<void> init() async {
    if (_initialized) return;

    _initialized = await _speech.initialize(
      onStatus: _onStatus,
      onError: (error) {
        print("Error: $error");
        _restartListening();
      },
    );

    print("Inicializado: $_initialized");

    if (_initialized) {
      _startListening();
    }
  }

  /**
   * Inicia una sesión de escucha activa si no se está escuchando ya.
   * Ademas lo hemos configurado para el idioma Español de españa.
   */
  void _startListening() async {
    if (_listening) return;

    _listening = true;

    await _speech.listen(
      onResult: _onResult,
      listenMode: stt.ListenMode.dictation,
      partialResults: true,
      localeId: "es_ES",
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 5),
    );

    print("Escuchando...");
  }

  /**
   * Maneja los cambios de estado del control por voz.
   * En caso de que haya terminado (estaado: done) o haya dejado de escuchar (estado: notListening)
   * se reinicia el servicio.
   */
  void _onStatus(String status) {
    print("Status: $status");

    if (status == "done" || status == "notListening") {
      _restartListening();
    }
  }

  /**
   * Detiene y reinicia el motor de escucha tras un breve periodo de espera.
   */
  void _restartListening() async {
    if (!_initialized) return;
    _listening = false;

    await _speech.stop();
    await Future.delayed(const Duration(milliseconds: 300));

    _startListening();
  }

  /**
   * Maneja los resultados del reconocimiento de voz. Ademas,
   * filtra el texto buscando la palabra clave "asistente".
   * Si el resultado es final, extrae el comando y notifica a todos los suscriptores registrados.
   */
  void _onResult(stt.SpeechRecognitionResult result) {
    final texto = result.recognizedWords.toLowerCase().trim();

    //Evitamos el procesamiento si el texto está vacío o si es un duplicado del último comando procesado
    if (texto.isEmpty || (result.finalResult && texto == _lastProcessed)) return;

    if (result.finalResult) {
      _lastProcessed = texto;
      print("Texto final: $texto (Confianza: ${result.confidence.toStringAsFixed(2)})");
    }

    const String trigger = "asistente";

    //Buscamos la palabra clave
    if (texto.contains(trigger)) {
      //Extraemos el comando de forma más precisa (solo lo que sigue al trigger)
      final index = texto.indexOf(trigger);
      final comando = texto.substring(index + trigger.length).trim();

      //Solo ejecutamos si es el resultado final y hay un comando real
      if (result.finalResult && comando.isNotEmpty) {
        print("Ejecutando comando: $comando");

        // Clonamos la lista para evitar errores si un listener se elimina  accidentalmente durante la ejecución
        final targets = List<Function(String)>.from(_listeners);
        for (final listener in targets) {
          listener(comando);
        }
      }
    }
  }

  // Detiene el motor de voz y libera los recursos asociados.
  void dispose() {
    _speech.stop();
  }
}

// Instancia única global para facilitar su acceso en la aplicación.
final voiceController = VoiceController();
