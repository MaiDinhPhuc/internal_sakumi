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
      _player!.dispose();
    }
  }

  seek(Duration position, String sound)async{
    if (_player != null) {
      await _player!.seek(position);
    }
  }



  playSound(String sound, SoundCubit soundCubit, String type) async {
    var player = newPlayer();

    await soundCubit.loading();
    await soundCubit.changeActive(type, sound);

    if(type == "network"){
      player.open(Audio.network(sound), volume: 1).whenComplete(() {
        debugPrint("=============>open complete $sound");
      });
    }
    else{
      player.open(Audio.file(sound), volume: 1).whenComplete(() {
        debugPrint("=============>open complete $sound");
      });
    }
    player.current.listen((playingAudio) {
      soundCubit.duration = player.current.value!.audio.duration.inMilliseconds.toDouble();
      debugPrint("===========>voice duration : ${soundCubit.duration}");
    });
    int count = 0;
    player.currentPosition.listen((currentPosition){
        soundCubit.change(currentPosition.inMilliseconds.toDouble());
        if (currentPosition.inMilliseconds == 0) {
            count++;
        }
        if(count == 3){
          soundCubit.change(soundCubit.duration);
          soundCubit.reStart();
          debugPrint("===========>completed");
        }
    });
  }

  pause(SoundCubit soundCubit) async {
    await _player!.pause();
    soundCubit.currentPosition = _player!.currentPosition.value.inMilliseconds.toDouble();
    await soundCubit.pause();
  }

  resume(SoundCubit soundCubit) async {
    await _player!.play();
    await soundCubit.change(soundCubit.currentPosition);
  }

}
