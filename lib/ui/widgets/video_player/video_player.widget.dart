import 'package:appserap/ui/widgets/video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';

import 'chewie_player.dart';


enum PlayerType {
  chewie,
  appinio_video_player,
}

class VideoPlayer extends StatefulWidget {
  const VideoPlayer({
    super.key,
    this.videoPath,
    this.videoUrl,
    this.playerType = PlayerType.chewie,
  });

  final String? videoPath;
  final String? videoUrl;
  final PlayerType playerType;

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  @override
  Widget build(BuildContext context) {
    switch (widget.playerType) {
      case PlayerType.chewie:
        return ChewiePlayer(
          videoPath: widget.videoPath,
          videoUrl: widget.videoUrl,
        );

      case PlayerType.appinio_video_player:
        return AppinioVideoPlayer(
          videoPath: widget.videoPath,
          videoUrl: widget.videoUrl,
        );
    }
  }
}
