import 'package:microphone/microphone.dart';

class RecordService {
  RecordService._privateConstructor();

  static final RecordService _instance = RecordService._privateConstructor();

  static RecordService get instance => _instance;

  MicrophoneRecorder? _recorder;

  Future<MicrophoneRecorder> newRecorder()  async {
    if (_recorder != null) {
      if (_recorder!.value.recording != null) {
        _recorder!.stop();
      }
      _recorder!.dispose();
    }

    _recorder = MicrophoneRecorder();

    await _recorder!.init();

    return _recorder!;
  }

  dispose(){
    if(_recorder != null){
      _recorder!.dispose();
    }
  }

  start()async{
    var recorder = await newRecorder();
    recorder.start();
  }

  stop() {
     _recorder!.stop();
     print("========>${_recorder!.value.recording!.url}");
  }

}