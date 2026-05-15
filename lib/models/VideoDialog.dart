import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoDialog extends StatefulWidget {
  final String videoUrl;

  const VideoDialog({super.key, required this.videoUrl});

  @override
  State<VideoDialog> createState() => _VideoDialogState();
}

class _VideoDialogState extends State<VideoDialog> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();

    // Extraemos el ID del video de la URL
    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);

    _controller = YoutubePlayerController(
      initialVideoId: videoId ?? '',
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    );
  }

  @override
  void deactivate() {
    // Pausa el video cuando el diálogo se cierra o el widget deja de estar activo
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    // Liberamos los recursos del controlador
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // Añadimos un pequeño margen lateral para que no toque los bordes de la pantalla
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      child: YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.amber,
          progressColors: const ProgressBarColors(
            playedColor: Colors.amber,
            handleColor: Colors.amberAccent,
          ),
          onReady: () {
            debugPrint('El reproductor de YouTube está listo.');
          },
        ),
        builder: (context, player) {
          return Column(
            mainAxisSize: MainAxisSize.min, // El diálogo se ajusta al tamaño del video
            children: [
              player,
            ],
          );
        },
      ),
    );
  }
}