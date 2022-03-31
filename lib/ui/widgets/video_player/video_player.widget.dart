import 'dart:io';

import 'package:appserap/interfaces/loggable.interface.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String? videoPath;
  final String? videoUrl;

  VideoPlayerWidget({
    Key? key,
    this.videoPath,
    this.videoUrl,
  }) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> with Loggable {
  // BetterPlayerController _betterPlayerController;

  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  double _aspectRatio = 16 / 9;

  @override
  initState() {
    super.initState();
    info(widget.videoPath);

    if (widget.videoUrl != null) {
      _videoPlayerController = VideoPlayerController.network(widget.videoUrl!);
    } else {
      _videoPlayerController = VideoPlayerController.file(File(widget.videoPath!));
    }

    _chewieController = ChewieController(
      allowedScreenSleep: false,
      allowFullScreen: true,

      videoPlayerController: _videoPlayerController,
      aspectRatio: _aspectRatio,
      autoInitialize: true,
      autoPlay: true,
      showControls: true,
      // materialProgressColors: ChewieProgressColors(
      //   playedColor: TemaUtil.,
      //   bufferedColor: kTextColorVariant,
      // ),
    );
  }

  @override
  void dispose() {
    _videoPlayerController.pause();
    _chewieController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Chewie(
      controller: _chewieController,
    );
  }
}
