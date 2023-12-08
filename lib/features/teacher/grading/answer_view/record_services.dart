import 'package:firebase_storage/firebase_storage.dart';
import 'package:microphone/microphone.dart';
import 'package:http/http.dart' as http;
class RecordService {
  RecordService._privateConstructor();

  static final RecordService _instance = RecordService._privateConstructor();

  static RecordService get instance => _instance;

  MicrophoneRecorder? _recorder;

  Future<MicrophoneRecorder> newRecorder()  async {
    // if (_recorder != null) {
    //   if (_recorder!.value.recording != null) {
    //     await _recorder!.stop();
    //   }
    //   _recorder!.dispose();
    // }


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
    await recorder.start();
  }

  Future<String> stop()async {
     await _recorder!.stop();
     final recordingUrl = _recorder!.value.recording!.url;
     http.Response response = await http.get(
         Uri.parse(recordingUrl)
     );
     final now = DateTime.now().microsecondsSinceEpoch;
     final ref = FirebaseStorage.instance.ref().child('grading_result_record/$now');
     await ref.putData(response.bodyBytes, SettableMetadata(contentType: 'video/mp4'));
     var link = await ref.getDownloadURL();
     return link;
  }


}