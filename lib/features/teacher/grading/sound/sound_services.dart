import 'package:flutter/Material.dart';
import 'package:internal_sakumi/features/teacher/grading/sound/sound_cubit.dart';
import 'package:video_player/video_player.dart';



class SoundService {
  SoundService._privateConstructor();

  static final SoundService _instance = SoundService._privateConstructor();

  static SoundService get instance => _instance;

  VideoPlayerController? _player;

  Future<VideoPlayerController> newPlayer(String url, String type) async {

    if (_player != null) {
      if (_player!.value.isPlaying) {
        _player!.pause();
      }
      _player!.dispose();
    }

    if(type == "network"){
      _player = VideoPlayerController.network(
        url,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );
      await _player!.initialize();
    }else{
      _player = VideoPlayerController.asset(
        url,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );
      await _player!.initialize();
    }

    return _player!;
  }

  VideoPlayerController getPlayer(){
    return _player!;
  }

  dispose(){
    if(_player != null){
      _player!.dispose();
    }
  }

  play(){
    if(_player != null){
      _player!.play();
    }
  }

  seek(Duration position){
    if(_player != null){
      debugPrint("========>seek to ${position.inMilliseconds.toDouble()} ");
      _player!.seekTo(position);
    }
  }

  bool isPause(){
    if(_player!.value.isPlaying == false){
      return true;
    }
    return false;
  }

  pause(SoundCubit soundCubit) async {
    if(_player != null){
      _player!.pause();
    }
    soundCubit.currentPosition = soundCubit.state;

    await soundCubit.pause();
  }



  playSound(String sound, SoundCubit soundCubit, String type) async {
    debugPrint("=======>$sound");
    var player = await newPlayer(sound, type);

    await soundCubit.loading();
    await soundCubit.changeActive(type, sound);

    player.play();



    player.addListener(() {
      soundCubit.change(player.value.position.inMilliseconds.toDouble());
      if(player.value.duration == player.value.position && player.value.position.inMilliseconds.toDouble() != 0){
        soundCubit.change(soundCubit.duration);
        soundCubit.reStart();
        debugPrint("===========>completed");
        player.dispose();
      }
    });
  }

}
