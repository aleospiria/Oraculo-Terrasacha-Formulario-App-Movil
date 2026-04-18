// lib/Utils/GrabadorAudio.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

class grabadorAudio extends StatefulWidget {
  final ValueChanged<String>? onGrabacionCompleta;
  final Duration duracionMaxima;

  const grabadorAudio({
    super.key,
    this.onGrabacionCompleta,
    this.duracionMaxima = const Duration(minutes: 3),
  });

  @override
  State<grabadorAudio> createState() => _grabadorAudioState();
}

class _grabadorAudioState extends State<grabadorAudio> {
  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _player = AudioPlayer();

  bool _grabando = false;
  bool _grabacionTerminada = false;
  bool _reproduciendo = false;
  String? _rutaArchivo;

  Duration _tiempoGrabado = Duration.zero;
  Duration _posicionReproduccion = Duration.zero;
  Duration _duracionAudio = Duration.zero;
  Timer? _timer;

  static const Color primaryColor = Color(0xFF4A5C24);

  @override
  void initState() {
    super.initState();

    _player.positionStream.listen((p) {
      if (!mounted) return;
      setState(() => _posicionReproduccion = p);
    });

    _player.durationStream.listen((d) {
      if (!mounted) return;
      setState(() => _duracionAudio = d ?? Duration.zero);
    });

    _player.playerStateStream.listen((state) {
      if (!mounted) return;
      if (state.processingState == ProcessingState.completed) {
        setState(() => _reproduciendo = false);
        _player.seek(Duration.zero);
        _player.pause();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _recorder.dispose();
    _player.dispose();
    super.dispose();
  }

  Future<void> _iniciarGrabacion() async {
    final hasPermission = await _recorder.hasPermission();
    if (!hasPermission) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permiso de micrófono denegado')),
        );
      }
      return;
    }

    await _player.stop();

    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/grabacion_${DateTime.now().millisecondsSinceEpoch}.m4a';

    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        sampleRate: 44100,
      ),
      path: path,
    );

    setState(() {
      _grabando = true;
      _grabacionTerminada = false;
      _reproduciendo = false;
      _tiempoGrabado = Duration.zero;
      _rutaArchivo = null;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      final nuevo = _tiempoGrabado + const Duration(seconds: 1);
      if (nuevo >= widget.duracionMaxima) {
        _detenerGrabacion();
        return;
      }
      setState(() => _tiempoGrabado = nuevo);
    });
  }

  Future<void> _detenerGrabacion() async {
    _timer?.cancel();
    final path = await _recorder.stop();

    if (!mounted) return;
    setState(() {
      _grabando = false;
      _grabacionTerminada = true;
      _rutaArchivo = path;
    });

    if (path != null) {
      try {
        await _player.setFilePath(path);
        debugPrint('Audio listo para reproducir: $path');
      } catch (e) {
        debugPrint('Error cargando audio: $e');
      }

      if (widget.onGrabacionCompleta != null) {
        widget.onGrabacionCompleta!(path);
      }
    }
  }

  Future<void> _toggleReproduccion() async {
    if (_rutaArchivo == null) return;

    if (_reproduciendo) {
      await _player.pause();
      setState(() => _reproduciendo = false);
    } else {
      await _player.play();
      setState(() => _reproduciendo = true);
    }
  }

  Future<void> _reiniciarGrabacion() async {
    await _player.stop();
    setState(() {
      _grabando = false;
      _grabacionTerminada = false;
      _reproduciendo = false;
      _rutaArchivo = null;
      _tiempoGrabado = Duration.zero;
      _posicionReproduccion = Duration.zero;
      _duracionAudio = Duration.zero;
    });
  }

  String _fmt(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    return '${two(m)}:${two(s)}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F3EB),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Registro de Audio',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 16),

          // === Sin grabar aún ===
          if (!_grabando && !_grabacionTerminada) ...[
            Row(
              children: [
                GestureDetector(
                  onTap: _iniciarGrabacion,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.12),
                      shape: BoxShape.circle,
                      border: Border.all(color: primaryColor.withOpacity(0.3), width: 2),
                    ),
                    child: const Icon(Icons.mic_none, color: primaryColor, size: 30),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Toca el micrófono para grabar',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                  ),
                ),
                Text(
                  '00:00 / ${_fmt(widget.duracionMaxima)}',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black54),
                ),
              ],
            ),
          ],

          // === Grabando ===
          if (_grabando) ...[
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.15),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.red.withOpacity(0.3), width: 2),
                  ),
                  child: const Icon(Icons.mic, color: Colors.red, size: 30),
                ),
                const SizedBox(width: 16),
                Expanded(child: _buildOndasAnimadas()),
                const SizedBox(width: 12),
                Text(
                  '${_fmt(_tiempoGrabado)} / ${_fmt(widget.duracionMaxima)}',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Center(
              child: IconButton(
                onPressed: _detenerGrabacion,
                icon: const Icon(Icons.stop_circle, size: 40),
                color: Colors.red,
                tooltip: 'Detener grabación',
              ),
            ),
          ],

          // === Grabación terminada (CON REPRODUCTOR) ===
          if (_grabacionTerminada && _rutaArchivo != null) ...[
            Row(
              children: [
                // Botón play/pause
                GestureDetector(
                  onTap: _toggleReproduccion,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.12),
                      shape: BoxShape.circle,
                      border: Border.all(color: primaryColor.withOpacity(0.3), width: 2),
                    ),
                    child: Icon(
                      _reproduciendo ? Icons.pause : Icons.play_arrow,
                      color: primaryColor,
                      size: 30,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(child: _buildOndasEstaticas()),
                const SizedBox(width: 12),
                Text(
                  '${_fmt(_reproduciendo ? _posicionReproduccion : _tiempoGrabado)} / ${_fmt(_duracionAudio > Duration.zero ? _duracionAudio : _tiempoGrabado)}',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Barra de progreso
            if (_duracionAudio > Duration.zero)
              SliderTheme(
                data: SliderThemeData(
                  trackHeight: 3,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                  activeTrackColor: primaryColor,
                  inactiveTrackColor: primaryColor.withOpacity(0.2),
                  thumbColor: primaryColor,
                ),
                child: Slider(
                  min: 0,
                  max: _duracionAudio.inMilliseconds.toDouble(),
                  value: _posicionReproduccion.inMilliseconds
                      .clamp(0, _duracionAudio.inMilliseconds)
                      .toDouble(),
                  onChanged: (v) async {
                    await _player.seek(Duration(milliseconds: v.toInt()));
                  },
                ),
              ),

            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle, color: primaryColor, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        'Audio grabado',
                        style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                TextButton.icon(
                  onPressed: _reiniciarGrabacion,
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Grabar de nuevo', style: TextStyle(fontSize: 12)),
                  style: TextButton.styleFrom(foregroundColor: Colors.grey.shade600),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOndasAnimadas() {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(20, (i) => _BarraAnimada(index: i)),
      ),
    );
  }

  Widget _buildOndasEstaticas() {
    return SizedBox(
      height: 40,
      child: CustomPaint(
        size: const Size(double.infinity, 40),
        painter: _OndasEstaticasPainter(),
      ),
    );
  }
}

class _BarraAnimada extends StatefulWidget {
  final int index;
  const _BarraAnimada({required this.index});

  @override
  State<_BarraAnimada> createState() => _BarraAnimadaState();
}

class _BarraAnimadaState extends State<_BarraAnimada>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300 + (widget.index * 50 % 400)),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 4, end: 30 + (widget.index % 5) * 4.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        width: 3,
        height: _anim.value,
        decoration: BoxDecoration(
          color: const Color(0xFF4A5C24).withOpacity(0.7),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

class _OndasEstaticasPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF4A5C24).withOpacity(0.6)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    const barCount = 25;
    final spacing = size.width / barCount;
    final centerY = size.height / 2;
    final heights = [0.3, 0.5, 0.7, 0.9, 0.6, 0.8, 1.0, 0.7, 0.5, 0.9, 0.4, 0.8, 0.6, 0.95, 0.5, 0.7, 0.85, 0.4, 0.6, 0.9, 0.5, 0.75, 0.6, 0.8, 0.3];

    for (int i = 0; i < barCount; i++) {
      final x = i * spacing + spacing / 2;
      final h = heights[i % heights.length] * size.height * 0.8;
      canvas.drawLine(Offset(x, centerY - h / 2), Offset(x, centerY + h / 2), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}