import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:vosk_flutter_service/vosk_flutter_service.dart';

/// Transcripción de voz a texto 100% offline con Vosk.
///
/// El modelo de español se descarga una sola vez desde el origen oficial de
/// Vosk y queda cacheado en el dispositivo (requiere internet solo la
/// primera vez); después de esa descarga, la transcripción funciona sin
/// conexión. El audio de entrada debe ser PCM16 mono a [sampleRate] (usar
/// `grabadorAudio` con `RecordConfig(encoder: AudioEncoder.wav, sampleRate:
/// ServicioTranscripcionVoz.sampleRate, numChannels: 1)`).
class ServicioTranscripcionVoz {
  ServicioTranscripcionVoz._();

  static const String _modelName = 'vosk-model-small-es-0.42';
  static const String _modelUrl =
      'https://alphacephei.com/vosk/models/$_modelName.zip';

  /// Sample rate esperado del audio de entrada.
  static const int sampleRate = 16000;

  static const int _tamanoBloque = 8192;

  static final ModelLoader _modelLoader = ModelLoader();
  static Model? _modelo;
  static Future<void>? _cargaEnCurso;

  /// true si el modelo ya está descargado y descomprimido en el
  /// dispositivo (no implica que ya esté cargado en memoria).
  static Future<bool> modeloDisponibleLocalmente() {
    return _modelLoader.isModelAlreadyLoaded(_modelName);
  }

  /// Descarga (si falta) y carga en memoria el modelo de español. La
  /// primera vez puede tardar uno o varios minutos según la conexión;
  /// llamadas posteriores son instantáneas porque el modelo queda cacheado
  /// en disco y cargado en memoria.
  static Future<void> asegurarModeloDisponible() {
    if (_modelo != null) return Future.value();
    // Evita descargar/cargar el modelo dos veces si dos pantallas lo piden
    // casi al mismo tiempo.
    return _cargaEnCurso ??= _cargarModelo().whenComplete(() {
      _cargaEnCurso = null;
    });
  }

  static Future<void> _cargarModelo() async {
    final path = await _modelLoader.loadFromNetwork(_modelUrl);
    _modelo = await VoskFlutterPlugin.instance().createModel(path);
  }

  /// Transcribe un archivo de audio WAV (PCM16 mono, [sampleRate]) grabado
  /// localmente. Requiere haber llamado antes a [asegurarModeloDisponible].
  /// Devuelve una cadena vacía si no se detectó voz reconocible.
  static Future<String> transcribir(String rutaAudioWav) async {
    final modelo = _modelo;
    if (modelo == null) {
      throw StateError(
        'El modelo de transcripción no está listo: llama a '
        'ServicioTranscripcionVoz.asegurarModeloDisponible() antes de '
        'transcribir.',
      );
    }

    final recognizer = await VoskFlutterPlugin.instance().createRecognizer(
      model: modelo,
      sampleRate: sampleRate,
    );

    try {
      final muestras = _muestrasPcm16DesdeWav(
        await File(rutaAudioWav).readAsBytes(),
      );

      var posicion = 0;
      while (posicion + _tamanoBloque < muestras.length) {
        await recognizer.acceptWaveformBytes(
          muestras.sublist(posicion, posicion + _tamanoBloque),
        );
        posicion += _tamanoBloque;
      }
      await recognizer.acceptWaveformBytes(
        muestras.sublist(posicion, muestras.length),
      );

      return _textoDesdeResultado(await recognizer.getFinalResult());
    } finally {
      await recognizer.dispose();
    }
  }

  static String _textoDesdeResultado(String resultadoJson) {
    try {
      final data = jsonDecode(resultadoJson) as Map<String, dynamic>;
      return (data['text'] as String?)?.trim() ?? '';
    } catch (_) {
      return '';
    }
  }

  /// Extrae las muestras PCM16 de un archivo WAV, saltando la cabecera
  /// RIFF/WAVE y cualquier subchunk previo al de datos ("data"). Si el
  /// archivo no tiene cabecera WAV reconocible, se asume que ya son
  /// muestras PCM16 crudas.
  static Uint8List _muestrasPcm16DesdeWav(Uint8List bytes) {
    const cabeceraMinima = 12; // "RIFF" + tamaño(4) + "WAVE"
    if (bytes.length < cabeceraMinima ||
        String.fromCharCodes(bytes.sublist(0, 4)) != 'RIFF') {
      return bytes;
    }

    var offset = cabeceraMinima;
    while (offset + 8 <= bytes.length) {
      final idChunk = String.fromCharCodes(bytes.sublist(offset, offset + 4));
      final tamanoChunk = ByteData.sublistView(
        bytes,
        offset + 4,
        offset + 8,
      ).getUint32(0, Endian.little);
      final inicioDatos = offset + 8;

      if (idChunk == 'data') {
        final finDatos = (inicioDatos + tamanoChunk).clamp(
          inicioDatos,
          bytes.length,
        );
        return bytes.sublist(inicioDatos, finDatos);
      }

      // Los subchunks RIFF se alinean a bytes pares.
      offset = inicioDatos + tamanoChunk + (tamanoChunk.isOdd ? 1 : 0);
    }

    return bytes;
  }
}
