import 'dart:io';

import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';

class AppinioVideoPlayer extends StatefulWidget {
  final String? videoPath;
  final String? videoUrl;

  AppinioVideoPlayer({
    super.key,
    this.videoPath,
    this.videoUrl,
  });

  @override
  State<AppinioVideoPlayer> createState() => _AppinioVideoPlayerState();
}

class _AppinioVideoPlayerState extends State<AppinioVideoPlayer> {
  late VideoPlayerController videoPlayerController;
  late CustomVideoPlayerController _customVideoPlayerController;

  @override
  void initState() {
    super.initState();

    _initVideoController();


    videoPlayerController.initialize().then((value) {
      setState(() {});
      videoPlayerController.play();
    });

    _customVideoPlayerController = CustomVideoPlayerController(
      context: context,
      videoPlayerController: videoPlayerController,
    );
  }

  @override
  void dispose() {
    videoPlayerController.pause();
    _customVideoPlayerController.dispose();

    super.dispose();
  }

  _initVideoController(){
    if (widget.videoUrl != null) {
      videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl!));
    } else {
      videoPlayerController = VideoPlayerController.file(File(widget.videoPath!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomVideoPlayer(
          customVideoPlayerController: _customVideoPlayerController
      ),
    );
  }
}
