// ignore_for_file: unused_element

import 'dart:async';
import 'dart:typed_data';

import 'package:appserap/utils/tema.util.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class PlayerAudioWidget extends StatefulWidget {
  final String? audioPath;
  final Uint8List? audioBytes;

  PlayerAudioWidget({
    Key? key,
    this.audioPath,
    this.audioBytes,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PlayerAudioWidgetState();
  }
}

class _PlayerAudioWidgetState extends State<PlayerAudioWidget> {
  PlayerState? _playerState;
  Duration? _duration;
  Duration? _position;

  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerCompleteSubscription;
  StreamSubscription? _playerStateChangeSubscription;

  bool get _isPlaying => _playerState == PlayerState.playing;

  bool get _isPaused => _playerState == PlayerState.paused;

  String get _durationText => _duration?.toString().split('.').first ?? '';

  String get _positionText => _position?.toString().split('.').first ?? '';

  late AudioPlayer player;

  @override
  void initState() {
    _preparePlayerHandle();
    _initStreams();
    super.initState();
  }

  _preparePlayerHandle() {
    player = AudioPlayer();

    var path = _prepareAudioPathHandle();

    var source =
        path != null ? UrlSource(path) : BytesSource(widget.audioBytes!);

    player.setSource(source);

    // Use initial values from player
    _playerState = player.state;
    player.getDuration().then(
          (value) => setState(() {
            _duration = value;
          }),
        );
    player.getCurrentPosition().then(
          (value) => setState(() {
            _position = value;
          }),
        );
  }

  String? _prepareAudioPathHandle() {
    if (widget.audioPath != null) {
      return widget.audioPath!.contains('http:')
          ? widget.audioPath?.replaceAll('http:', 'https:')
          : widget.audioPath;
    }
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerStateChangeSubscription?.cancel();
    player.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
      height: 76,
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
              ),
            ),
            width: 72,
            height: 75,
            child: _buildControlButtons(),
          ),
          Expanded(
            child: Slider(
              activeColor: TemaUtil.appBar,
              thumbColor: TemaUtil.appBar,
              inactiveColor: Colors.black.withOpacity(0.1),
              onChanged: (v) {
                final duration = _duration;
                if (duration == null) {
                  return;
                }
                final position = v * duration.inMilliseconds;
                player.seek(Duration(milliseconds: position.round()));
              },
              value: (_position != null &&
                      _duration != null &&
                      _position!.inMilliseconds > 0 &&
                      _position!.inMilliseconds < _duration!.inMilliseconds)
                  ? _position!.inMilliseconds / _duration!.inMilliseconds
                  : 0.0,
            ),
          ),
        ],
      ),
    );
  }

  _buildControlButtons() {
    if (_isPlaying) {
      return IconButton(
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        iconSize: 50,
        icon: Icon(
          Icons.pause_rounded,
          color: TemaUtil.appBar,
        ),
        onPressed: _isPlaying ? _pause : null,
      );
    }

    return IconButton(
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      iconSize: 50,
      icon: Icon(
        Icons.play_arrow_rounded,
        color: TemaUtil.appBar,
      ),
      onPressed: _isPlaying ? null : _play,
    );
  }

  void _initStreams() {
    _durationSubscription = player.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);
    });

    _positionSubscription = player.onPositionChanged.listen(
      (p) => setState(() => _position = p),
    );

    _playerCompleteSubscription = player.onPlayerComplete.listen((event) {
      setState(() {
        _playerState = PlayerState.stopped;
        _position = Duration.zero;
      });
    });

    _playerStateChangeSubscription =
        player.onPlayerStateChanged.listen((state) {
      setState(() {
        _playerState = state;
      });
    });
  }

  Future<void> _play() async {
    final position = _position;
    if (position != null && position.inMilliseconds > 0) {
      await player.seek(position);
    }
    await player.resume();
    setState(() => _playerState = PlayerState.playing);
  }

  Future<void> _pause() async {
    await player.pause();
    setState(() => _playerState = PlayerState.paused);
  }

  Future<void> _stop() async {
    await player.stop();
    setState(() {
      _playerState = PlayerState.stopped;
      _position = Duration.zero;
    });
  }
}
