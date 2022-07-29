// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_player.controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AudioPlayerController on _AudioPlayerControllerBase, Store {
  final _$positionAtom = Atom(name: '_AudioPlayerControllerBase.position');

  @override
  int get position {
    _$positionAtom.reportRead();
    return super.position;
  }

  @override
  set position(int value) {
    _$positionAtom.reportWrite(value, super.position, () {
      super.position = value;
    });
  }

  final _$durationAtom = Atom(name: '_AudioPlayerControllerBase.duration');

  @override
  Duration? get duration {
    _$durationAtom.reportRead();
    return super.duration;
  }

  @override
  set duration(Duration? value) {
    _$durationAtom.reportWrite(value, super.duration, () {
      super.duration = value;
    });
  }

  final _$_mPlayerIsInitedAtom =
      Atom(name: '_AudioPlayerControllerBase._mPlayerIsInited');

  @override
  bool get _mPlayerIsInited {
    _$_mPlayerIsInitedAtom.reportRead();
    return super._mPlayerIsInited;
  }

  @override
  set _mPlayerIsInited(bool value) {
    _$_mPlayerIsInitedAtom.reportWrite(value, super._mPlayerIsInited, () {
      super._mPlayerIsInited = value;
    });
  }

  final _$isPlayingAtom = Atom(name: '_AudioPlayerControllerBase.isPlaying');

  @override
  bool get isPlaying {
    _$isPlayingAtom.reportRead();
    return super.isPlaying;
  }

  @override
  set isPlaying(bool value) {
    _$isPlayingAtom.reportWrite(value, super.isPlaying, () {
      super.isPlaying = value;
    });
  }

  final _$isPausedAtom = Atom(name: '_AudioPlayerControllerBase.isPaused');

  @override
  bool get isPaused {
    _$isPausedAtom.reportRead();
    return super.isPaused;
  }

  @override
  set isPaused(bool value) {
    _$isPausedAtom.reportWrite(value, super.isPaused, () {
      super.isPaused = value;
    });
  }

  final _$setFilePlayerAsyncAction =
      AsyncAction('_AudioPlayerControllerBase.setFilePlayer');

  @override
  Future setFilePlayer(String? filePath) {
    return _$setFilePlayerAsyncAction.run(() => super.setFilePlayer(filePath));
  }

  final _$setBytePlayerAsyncAction =
      AsyncAction('_AudioPlayerControllerBase.setBytePlayer');

  @override
  Future setBytePlayer(Uint8List? fileByte) {
    return _$setBytePlayerAsyncAction.run(() => super.setBytePlayer(fileByte));
  }

  final _$stopPlayerAsyncAction =
      AsyncAction('_AudioPlayerControllerBase.stopPlayer');

  @override
  Future<void> stopPlayer() {
    return _$stopPlayerAsyncAction.run(() => super.stopPlayer());
  }

  final _$pausePlayerAsyncAction =
      AsyncAction('_AudioPlayerControllerBase.pausePlayer');

  @override
  Future<void> pausePlayer() {
    return _$pausePlayerAsyncAction.run(() => super.pausePlayer());
  }

  final _$resumePlayerAsyncAction =
      AsyncAction('_AudioPlayerControllerBase.resumePlayer');

  @override
  Future<void> resumePlayer() {
    return _$resumePlayerAsyncAction.run(() => super.resumePlayer());
  }

  final _$playFileAsyncAction =
      AsyncAction('_AudioPlayerControllerBase.playFile');

  @override
  Future playFile() {
    return _$playFileAsyncAction.run(() => super.playFile());
  }

  final _$_AudioPlayerControllerBaseActionController =
      ActionController(name: '_AudioPlayerControllerBase');

  @override
  dynamic setPos(int d) {
    final _$actionInfo = _$_AudioPlayerControllerBaseActionController
        .startAction(name: '_AudioPlayerControllerBase.setPos');
    try {
      return super.setPos(d);
    } finally {
      _$_AudioPlayerControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
position: ${position},
duration: ${duration},
isPlaying: ${isPlaying},
isPaused: ${isPaused}
    ''';
  }
}
