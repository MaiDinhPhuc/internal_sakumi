import 'package:internal_sakumi/features/teacher/grading/sound/sound_cubit.dart';
import 'package:flutter_sound/flutter_sound.dart';
class SoundService {
  SoundService._privateConstructor();

  static final SoundService _instance = SoundService._privateConstructor();

  static SoundService get instance => _instance;

  FlutterSoundPlayer? _player;

  bool checkExist() {
    if (_player != null) {
      return true;
    }
    return false;
  }

  Future<FlutterSoundPlayer> newPlayer(String url, String type) async {

    if (_player != null) {
      if (_player!.isPlaying) {
        await _player!.pausePlayer();
        await _player!.closePlayer();
      }
    }
    _player = null;
    _player = FlutterSoundPlayer();
    return _player!;
  }

  FlutterSoundPlayer? getPlayer() {
    return _player;
  }

  dispose() {
    if (_player != null) {
      _player!.closePlayer();
    }
  }

  seek(Duration position) async {
    if (_player != null) {
      await _player!.seekToPlayer(position);
    }
  }

  bool isPause() {
    return !_player!.isPlaying;
  }

  resume(SoundCubit soundCubit) async {
    await _player!.resumePlayer();
    await soundCubit.change(soundCubit.currentPosition);
  }

  pause(SoundCubit soundCubit) async {
    if (_player != null) {
      _player!.pausePlayer();
    }
    soundCubit.currentPosition = soundCubit.state;

    await soundCubit.pause();
  }

  playSound(String sound, SoundCubit soundCubit, String type) async {
    var player = await newPlayer(sound, type);

    await soundCubit.loading();

    await soundCubit.changeActive(type, sound);

    await player.openPlayer();

    player.startPlayer(fromURI: sound,codec: Codec.defaultCodec, whenFinished: (){
      soundCubit.reStart();
      player.closePlayer();
      _player = null;
    }).whenComplete(()async{
      await player.setSubscriptionDuration(const Duration(milliseconds: 100));
      player.onProgress!.listen((e) {
        soundCubit.duration = e.duration.inMilliseconds.toDouble();
        soundCubit.change(e.position.inMilliseconds.toDouble());
      });
    });

  }
}
