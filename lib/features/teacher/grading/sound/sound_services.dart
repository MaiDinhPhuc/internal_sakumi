// import 'package:flutter/Material.dart';
// import 'package:internal_sakumi/features/teacher/grading/sound/sound_cubit.dart';
// import 'package:video_player/video_player.dart';
//
//
//
// class SoundService {
//   SoundService._privateConstructor();
//
//   static final SoundService _instance = SoundService._privateConstructor();
//
//   static SoundService get instance => _instance;
//
//   VideoPlayerController? _player;
//
//   Future<VideoPlayerController> newPlayer(String url, String type) async {
//
//     if (_player != null) {
//       if (_player!.value.isPlaying) {
//         _player!.pause();
//       }
//       _player!.dispose();
//     }
//
//     debugPrint("========>init");
//
//     if(type == "network"){
//       _player = VideoPlayerController.networkUrl(
//         Uri.parse(url),
//         videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
//       );
//       debugPrint("========>init before");
//       await _player!.initialize();
//       debugPrint("========>init after");
//     }else{
//       _player = VideoPlayerController.asset(
//         url,
//         videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
//       );
//       await _player!.initialize();
//     }
//
//     return _player!;
//   }
//
//   VideoPlayerController getPlayer(){
//     return _player!;
//   }
//
//   dispose(){
//     if(_player != null){
//       _player!.dispose();
//     }
//   }
//
//   play(){
//     if(_player != null){
//       _player!.play();
//     }
//   }
//
//   seek(Duration position){
//     if(_player != null){
//       debugPrint("========>seek to ${position.inMilliseconds.toDouble()} ");
//       _player!.seekTo(position);
//     }
//   }
//
//   bool isPause(){
//     if(_player!.value.isPlaying == false){
//       return true;
//     }
//     return false;
//   }
//
//   pause(SoundCubit soundCubit) async {
//     if(_player != null){
//       _player!.pause();
//     }
//     soundCubit.currentPosition = soundCubit.state;
//
//     await soundCubit.pause();
//   }
//
//
//
//   playSound(String sound, SoundCubit soundCubit, String type) async {
//     debugPrint("=======>$sound");
//     var player = await newPlayer(sound, type);
//
//     await soundCubit.loading();
//     await soundCubit.changeActive(type, sound);
//
//     player.play();
//
//
//
//     player.addListener(() {
//       soundCubit.change(player.value.position.inMilliseconds.toDouble());
//       if(player.value.duration == player.value.position && player.value.position.inMilliseconds.toDouble() != 0){
//         soundCubit.change(soundCubit.duration);
//         soundCubit.reStart();
//         debugPrint("===========>completed");
//         player.dispose();
//       }
//     });
//   }
//
// }
import 'package:flutter/Material.dart';
import 'package:internal_sakumi/features/teacher/grading/sound/sound_cubit.dart';
import 'package:video_player/video_player.dart';



class SoundService {
  SoundService._privateConstructor();

  static final SoundService _instance = SoundService._privateConstructor();

  static SoundService get instance => _instance;

  VideoPlayerController? _player;
  //AssetsAudioPlayer? _player;

    VideoPlayerController newPlayer(String url, String type) {

      if (_player != null) {
        // if (_player!.state == PlayerState.playing) {
        //   _player!.stop();
        // }
        _player!.pause();
        if (_player!.value.isPlaying) {
          _player!.pause();
        }
        _player!.dispose();
      }

      _player = VideoPlayerController.network(
        url,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      )..initialize();
      // if(type == "network"){
      //   _player = VideoPlayerController.network(
      //     url,
      //     videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      //   )..initialize();
      // }else{
      //   _player = VideoPlayerController.asset(
      //     url,
      //     videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      //   )..initialize();
      // }

      return _player!;
    }
    // AssetsAudioPlayer newPlayer() {
    //   if (_player != null) {
    //     if(_player!.isPlaying.value){
    //       _player!.stop();
    //       _player!.dispose();
    //     }
    //   }
    //   _player = AssetsAudioPlayer();
    //
    //   return _player!;
    // }

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

    // AudioPlayer getPlayer(){
    //   return _player!;
    // }
    // AssetsAudioPlayer getPlayer(){
    //   return _player!;
    // }
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

    // stop(){
    //   if(_player != null){
    //     _player!.stop();
    //     _player!.dispose();
    //   }
    // }
    //
    // seek(Duration position, String sound)async{
    //   if (_player != null) {
    //     await _player!.seek(position);
    //   }
    // }
    pause(SoundCubit soundCubit) async {
      if(_player != null){
        _player!.pause();
      }
      soundCubit.currentPosition = soundCubit.state;

      await soundCubit.pause();
    }



    playSound(String sound, SoundCubit soundCubit, String type) async {
      var player = newPlayer(sound, type);

      await soundCubit.loading();
      await soundCubit.changeActive(type, sound);

      // if(type == "network"){
      //   player.open(Audio.network(sound), volume: 1).whenComplete(() {
      //     debugPrint("=============>open complete $sound");
      //   });
      // }
      // else{
      //   player.open(Audio.file(sound), volume: 1).whenComplete(() {
      //     debugPrint("=============>open complete $sound");
      //   });
      // }
      //player.setUrl('https://firebasestorage.googleapis.com/v0/b/sakumi-student.appspot.com/o/question_voice_records%2Faudio_0_question_23_lesson_110501_student_3_class_1?alt=media&token=8f79d46b-1677-4ec1-b2d3-ba6de6f00cd8');
      player.play();
      //player.play(UrlSource('https://firebasestorage.googleapis.com/v0/b/sakumi-student.appspot.com/o/question_voice_records%2Faudio_0_question_23_lesson_110501_student_3_class_1?alt=media&token=8f79d46b-1677-4ec1-b2d3-ba6de6f00cd8'));
      // player.current.listen((playingAudio) {
      //   soundCubit.duration = player.current.value!.audio.duration.inMilliseconds.toDouble();
      //   debugPrint("===========>voice duration : ${soundCubit.duration}");
      // });
      // int count = 0;
      // player.currentPosition.listen((currentPosition){
      //     soundCubit.change(currentPosition.inMilliseconds.toDouble());
      //     if (currentPosition.inMilliseconds == 0) {
      //         count++;
      //     }
      //     if(count == 3){
      //       soundCubit.change(soundCubit.duration);
      //       soundCubit.reStart();
      //       debugPrint("===========>completed");
      //     }
      // });
    }

    // pause(SoundCubit soundCubit) async {
    //   await _player!.pause();
    //   //soundCubit.currentPosition = _player!.currentPosition.value.inMilliseconds.toDouble();
    //   await soundCubit.pause();
    // }


    // resume(SoundCubit soundCubit) async {
    //   // await _player!.play();
    //   await soundCubit.change(soundCubit.currentPosition);
    //   player.addListener(() {
    //     soundCubit.change(player.value.position.inMilliseconds.toDouble());
    //     if(player.value.duration == player.value.position && player.value.position.inMilliseconds.toDouble() != 0){
    //       soundCubit.change(soundCubit.duration);
    //       soundCubit.reStart();
    //       debugPrint("===========>completed");
    //       player.dispose();
    //     }
    //   });
    // }

  }


