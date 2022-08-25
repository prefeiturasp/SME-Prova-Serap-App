import 'dart:async';

import 'package:appserap/utils/universal/universal.util.dart';
import 'package:drift/drift.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:mobx/mobx.dart';

part 'audio_player.controller.g.dart';

class AudioPlayerController = _AudioPlayerControllerBase with _$AudioPlayerController;

abstract class _AudioPlayerControllerBase with Store, Disposable {
  final FlutterSoundPlayer _audioPlayer = FlutterSoundPlayer(logLevel: Level.info);

  StreamSubscription? _mPlayerSubscription;

  @observable
  int position = 0;

  @observable
  Duration? duration = Duration();

  @observable
  bool _mPlayerIsInited = false;

  @observable
  bool isPlaying = false;

  @observable
  bool isPaused = false;

  String? filePath;
  Uint8List? fileByte;

  Future<void> init() async {
    await _audioPlayer.openPlayer();
    await _audioPlayer.setSubscriptionDuration(Duration(milliseconds: 50));
    _mPlayerSubscription = _audioPlayer.onProgress!.listen((e) {
      setPos(e.position.inMilliseconds);
    });
  }

  @action
  setFilePlayer(String? filePath) async {
    this.filePath = await buildPath(filePath);
    // duration = await flutterSoundHelper.duration(filePath) ?? Duration.zero;
  }

  @action
  setBytePlayer(Uint8List? fileByte) async {
    this.fileByte = fileByte;
    // duration = await flutterSoundHelper.duration(filePath) ?? Duration.zero;
  }

  @action
  Future<void> stopPlayer() async {
    await _audioPlayer.stopPlayer();
    isPlaying = false;
    isPaused = false;
  }

  @action
  Future<void> pausePlayer() async {
    await _audioPlayer.pausePlayer();
    isPlaying = false;
    isPaused = true;
  }

  @action
  Future<void> resumePlayer() async {
    await _audioPlayer.resumePlayer();
    isPlaying = true;
    isPaused = false;
  }

  @action
  playFile() async {
    if (isPaused) {
      resumePlayer();
    } else {
      duration = await _audioPlayer.startPlayer(
        fromURI: filePath,
        fromDataBuffer: fileByte,
        whenFinished: () {
          isPlaying = false;
        },
      );
      isPlaying = true;
      isPaused = false;
    }
  }

  void cancelPlayerSubscriptions() {
    if (_mPlayerSubscription != null) {
      _mPlayerSubscription!.cancel();
      _mPlayerSubscription = null;
    }
  }

  Future<void> seek(double d) async {
    await _audioPlayer.seekToPlayer(Duration(milliseconds: d.floor()));
    await setPos(d.floor());
  }

  @action
  setPos(int d) {
    if (d > duration!.inMilliseconds) {
      d = duration!.inMilliseconds;
    }
    position = d;
  }

  @override
  void onDispose() {
    stopPlayer();
    cancelPlayerSubscriptions();

    _audioPlayer.closePlayer();
  }
}
