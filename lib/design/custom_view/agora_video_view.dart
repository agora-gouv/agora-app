import 'package:agora/design/agora_colors.dart';
import 'package:agora/design/agora_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class AgoraVideoView extends StatefulWidget {
  final String videoUrl;

  const AgoraVideoView({super.key, required this.videoUrl});

  @override
  State<AgoraVideoView> createState() => _AgoraVideoViewState();
}

class _AgoraVideoViewState extends State<AgoraVideoView> {
  late VideoPlayerController videoPlayerController;
  late Future<void> initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    initializeVideoPlayerFuture = videoPlayerController.initialize().then((value) {
      videoPlayerController.addListener(_videoListener);
      videoPlayerController.play();
    });
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return AspectRatio(
            aspectRatio: videoPlayerController.value.aspectRatio,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                VideoPlayer(videoPlayerController),
                _ControlsOverlay(controller: videoPlayerController),
                VideoProgressIndicator(videoPlayerController, allowScrubbing: true),
              ],
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  void _videoListener() {
    if (videoPlayerController.value.position == videoPlayerController.value.duration) {
      setState(() {});
    }
  }
}

class _ControlsOverlay extends StatefulWidget {
  const _ControlsOverlay({required this.controller});

  static const List<double> _playbackRates = <double>[0.25, 0.5, 1.0, 1.5, 2.0, 3.0, 5.0, 10.0];

  final VideoPlayerController controller;

  @override
  State<_ControlsOverlay> createState() => _ControlsOverlayState();
}

class _ControlsOverlayState extends State<_ControlsOverlay> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child: widget.controller.value.isPlaying
              ? Container()
              : Container(
                  color: AgoraColors.potBlack,
                  child: const Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: AgoraColors.white,
                      size: 50.0,
                      semanticLabel: "Commencer la vidéo",
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            if (widget.controller.value.isPlaying) {
              widget.controller.pause();
            } else {
              widget.controller.play();
            }
            setState(() {});
          },
        ),
        Align(
          alignment: Alignment.topRight,
          child: PopupMenuButton<double>(
            tooltip: "Changer la vitesse de la vidéo",
            initialValue: widget.controller.value.playbackSpeed,
            onSelected: (double speed) {
              widget.controller.setPlaybackSpeed(speed);
              setState(() {});
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<double>>[
                for (final double speed in _ControlsOverlay._playbackRates)
                  PopupMenuItem<double>(
                    value: speed,
                    child: Text("${speed}x"),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Text(
                '${widget.controller.value.playbackSpeed}x',
                style: AgoraTextStyles.light14.copyWith(color: AgoraColors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
