import 'package:agora/design/style/agora_colors.dart';
import 'package:chewie/chewie.dart';
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
  late ChewieController chewieController;

  final aspectRatio = 1080 / 1920;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoInitialize: true,
      autoPlay: false,
      allowedScreenSleep: false,
      allowFullScreen: true,
      aspectRatio: aspectRatio,
      showControls: true,
    );
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AgoraColors.potBlack,
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: Chewie(controller: chewieController),
      ),
    );
  }
}
