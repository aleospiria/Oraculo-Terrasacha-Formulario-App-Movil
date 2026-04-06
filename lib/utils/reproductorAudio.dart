import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';

class AudioPlayerTile extends StatefulWidget {
  final String url;
  final String? title;
  final bool dense;

  const AudioPlayerTile({
    super.key,
    required this.url,
    this.title,
    this.dense = false,
  });

  @override
  State<AudioPlayerTile> createState() => _AudioPlayerTileState();
}

class _AudioPlayerTileState extends State<AudioPlayerTile> {
  final AudioPlayer _player = AudioPlayer();
  bool _isLoading = true;
  String? _error;

  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _init();
    _player.positionStream.listen((p) {
      if (!mounted) return;
      setState(() => _position = p);
    });
    _player.durationStream.listen((d) {
      if (!mounted) return;
      setState(() => _duration = d ?? Duration.zero);
    });
  }

  Future<void> _init() async {
    try {
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration.speech());

      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Carga desde URL remota
      await _player.setUrl(widget.url);

      if (!mounted) return;
      setState(() => _isLoading = false);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _error = 'No se pudo cargar el audio: $e';
      });
    }
  }

  @override
  void didUpdateWidget(covariant AudioPlayerTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _player.stop();
      _init();
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  String _fmt(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    final h = d.inHours;
    return h > 0 ? '${two(h)}:${two(m)}:${two(s)}' : '${two(m)}:${two(s)}';
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.title ?? 'Audio';

    return Card(
      child: Padding(
        padding: EdgeInsets.all(widget.dense ? 10 : 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),

            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),

            if (_isLoading) ...[
              const SizedBox(height: 6),
              const LinearProgressIndicator(),
              const SizedBox(height: 6),
              const Text('Cargando audio...'),
            ] else ...[
              StreamBuilder<PlayerState>(
                stream: _player.playerStateStream,
                builder: (context, snap) {
                  final state = snap.data;
                  final playing = state?.playing ?? false;
                  final processing = state?.processingState;

                  final buffering = processing == ProcessingState.buffering ||
                      processing == ProcessingState.loading;

                  return Row(
                    children: [
                      IconButton(
                        iconSize: 34,
                        onPressed: buffering
                            ? null
                            : () async {
                          if (playing) {
                            await _player.pause();
                          } else {
                            await _player.play();
                          }
                        },
                        icon: Icon(
                          playing ? Icons.pause_circle : Icons.play_circle,
                        ),
                      ),
                      if (buffering) ...[
                        const SizedBox(width: 8),
                        const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ],
                      const Spacer(),
                      Text('${_fmt(_position)} / ${_fmt(_duration)}'),
                    ],
                  );
                },
              ),

              Slider(
                min: 0,
                max: (_duration.inMilliseconds > 0)
                    ? _duration.inMilliseconds.toDouble()
                    : 1,
                value: _position.inMilliseconds
                    .clamp(0, _duration.inMilliseconds)
                    .toDouble(),
                onChanged: (_duration.inMilliseconds <= 0)
                    ? null
                    : (v) async {
                  await _player.seek(Duration(milliseconds: v.toInt()));
                },
              ),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () async {
                    await _player.seek(Duration.zero);
                    await _player.pause();
                  },
                  child: const Text('Reiniciar'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}