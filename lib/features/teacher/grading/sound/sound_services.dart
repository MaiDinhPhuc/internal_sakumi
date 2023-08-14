import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/Material.dart';
import 'package:internal_sakumi/features/teacher/grading/sound/sound_cubit.dart';


class SoundService {
  SoundService._privateConstructor();

  static final SoundService _instance = SoundService._privateConstructor();

  static SoundService get instance => _instance;

  AssetsAudioPlayer? _player;

  AssetsAudioPlayer newPlayer() {
    if (_player != null) {
      if(_player!.isPlaying.value){
        _player!.stop();
        _player!.dispose();
      }
    }
    _player = AssetsAudioPlayer();

    return _player!;
  }

  AssetsAudioPlayer getPlayer(){
    return _player!;
  }


  stop(){
    if(_player != null){
      _player!.stop();
    }
  }

  seek(Duration position)async{
    await _player?.seek(position);
    if (_player != null) {
      if (_player!.playerState.value == PlayerState.pause) {
        _player!.play();
      }
    }
  }



  playSound(String sound, SoundCubit soundCubit, String type) async {
    var player = newPlayer();

    await soundCubit.loading();
    await soundCubit.changeActive(type, sound);

    player.open(Audio.file(sound), volume: 1).whenComplete(() {
      debugPrint("=============>open complete $sound");
    });
    player.current.listen((playingAudio) {
      soundCubit.duration = player.current.value!.audio.duration.inMilliseconds.toDouble();
      debugPrint("===========>voice duration : ${soundCubit.duration}");
    });
    player.currentPosition.listen((currentPosition){
        soundCubit.change(currentPosition.inMilliseconds.toDouble());
        final audioDuration = player.current.value?.audio.duration;
        if (currentPosition >= audioDuration!) {
            soundCubit.change(soundCubit.duration);
            soundCubit.reStart();
            debugPrint("===========>completed");
        }
    });

    // player.onPlayerComplete.listen((event) {

    // });
  }

  pause(SoundCubit soundCubit) async {
    await _player?.pause();
    soundCubit.currentPosition = _player!.currentPosition.value.inMilliseconds.toDouble();
    await soundCubit.pause();
  }

  resume(SoundCubit soundCubit) async {
    await _player?.play();
    await soundCubit.change(soundCubit.currentPosition);
  }

}
