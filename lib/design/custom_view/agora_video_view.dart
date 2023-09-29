import 'package:agora/common/helper/responsive_helper.dart';
import 'package:agora/common/strings/semantics_strings.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class AgoraVideoView extends StatefulWidget {
  final String videoUrl;
  final int videoWidth;
  final int videoHeight;
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
    videoAspectRatio = widget.videoWidth.toDouble() / widget.videoHeight.toDouble();
    videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
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
    final (width, height) = _getContainerSize();
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
        width: width,
        height: height,
        child: AspectRatio(
          aspectRatio: videoAspectRatio,
          child: Chewie(controller: chewieController),
        ),
      ),
    );
  }

  (double width, double height) _getContainerSize() {
    final largerThanMobile = ResponsiveHelper.isLargerThanMobile(context);
    final screenWidth = MediaQuery.of(context).size.width - AgoraSpacings.horizontalPadding * 2;

    if (largerThanMobile || widget.videoWidth > widget.videoHeight) {
      return (screenWidth, screenWidth * 0.5625);
    } else {
      return (screenWidth, (screenWidth * 1920) / 1080);
    }
  }
}
