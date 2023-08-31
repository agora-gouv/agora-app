import 'package:agora/common/strings/semantics_strings.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class AgoraVideoView extends StatefulWidget {
  final String videoUrl;
  final int? videoWidth;
  final int? videoHeight;
  final VoidCallback onVideoStartMoreThan5Sec;

  const AgoraVideoView({
    super.key,
    required this.videoUrl,
    required this.videoWidth,
    required this.videoHeight,
    required this.onVideoStartMoreThan5Sec,
  });

  @override
  State<AgoraVideoView> createState() => _AgoraVideoViewState();
}

class _AgoraVideoViewState extends State<AgoraVideoView> {
  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;
  bool isFirstTimeTrack = true;

  late double videoAspectRatio;

  @override
  void initState() {
    super.initState();

    final videoWidth = widget.videoWidth;
    final videoHeight = widget.videoHeight;
    if (videoWidth != null && videoHeight != null) {
      videoAspectRatio = videoWidth.toDouble() / videoHeight.toDouble();
    } else {
      videoAspectRatio = 1080.0 / 1920.0;
    }

    videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoInitialize: true,
      autoPlay: false,
      allowedScreenSleep: false,
      allowFullScreen: true,
      aspectRatio: videoAspectRatio,
      showControls: true,
    );
    videoPlayerController.addListener(_listener);
  }

  void _listener() {
    if (isFirstTimeTrack && videoPlayerController.value.position >= Duration(seconds: 5)) {
      isFirstTimeTrack = false;
      videoPlayerController.removeListener(_listener);
      widget.onVideoStartMoreThan5Sec();
    }
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Semantics(
      label: SemanticsStrings.video,
      button: true,
      onTap: () {
        if (chewieController.isPlaying) {
          chewieController.pause();
        } else {
          chewieController.play();
        }
      },
      onTapHint: SemanticsStrings.onVideoTap,
      child: Container(
        color: AgoraColors.potBlack,
        width: screenWidth,
        height: screenWidth * 0.5625,
        child: AspectRatio(
          aspectRatio: videoAspectRatio,
          child: Chewie(controller: chewieController),
        ),
      ),
    );
  }
}
