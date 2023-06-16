import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class AgoraVideoView extends StatefulWidget {
  final String qagId;
  final String videoUrl;
  final int? videoWidth;
  final int? videoHeight;

  const AgoraVideoView({
    super.key,
    required this.qagId,
    required this.videoUrl,
    required this.videoWidth,
    required this.videoHeight,
  });

  @override
  State<AgoraVideoView> createState() => _AgoraVideoViewState();
}

class _AgoraVideoViewState extends State<AgoraVideoView> {
  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;
  bool isFirstTimeTrack = true;

  late double aspectRatio;

  @override
  void initState() {
    super.initState();

    final videoWidth = widget.videoWidth;
    final videoHeight = widget.videoHeight;
    if (videoWidth != null && videoHeight != null) {
      aspectRatio = videoWidth.toDouble() / videoHeight.toDouble();
    } else {
      aspectRatio = 1080 / 1920;
    }

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
    videoPlayerController.addListener(_listener);
  }

  void _listener() {
    if (isFirstTimeTrack && videoPlayerController.value.position >= Duration(seconds: 5)) {
      isFirstTimeTrack = false;
      videoPlayerController.removeListener(_listener);
      TrackerHelper.trackEvent(
        eventName: "${AnalyticsEventNames.qagVideo} ${widget.qagId}",
        widgetName: AnalyticsScreenNames.qagDetailsPage,
      );
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
    return Container(
      color: AgoraColors.potBlack,
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: Chewie(controller: chewieController),
      ),
    );
  }
}
