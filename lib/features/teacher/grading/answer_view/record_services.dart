import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/Material.dart';

import 'package:http/http.dart' as http;
import 'package:record/record.dart';

class RecordService {
  RecordService._privateConstructor();

  static final RecordService _instance = RecordService._privateConstructor();

  static RecordService get instance => _instance;

  AudioRecorder? _recorder;

  AudioRecorder newRecorder() {
    if (_recorder != null) {
      _recorder!.cancel();
      _recorder = null;
    }

    _recorder = AudioRecorder();

    return _recorder!;
  }

  dispose() {
    if (_recorder != null) {
      _recorder!.dispose();
    }
  }

  start() async {
    var recorder = newRecorder();
    if (await recorder.hasPermission()) {
      await recorder
          .start(const RecordConfig(encoder: AudioEncoder.wav),
          path: "record_file.wav")
          .onError((_, __) {
        debugPrint('error when record');
      }).whenComplete(() {
        debugPrint('success');
      });
    }

  }

  Future<String> stop() async {
    String? recordingUrl =
        await _recorder!.stop();
    http.Response response = await http.get(Uri.parse(recordingUrl!));
    final now = DateTime.now().microsecondsSinceEpoch;
    final ref =
        FirebaseStorage.instance.ref().child('grading_result_record/$now');
    await ref.putData(
        response.bodyBytes, SettableMetadata(contentType: 'audio/mpeg'));
    var link = await ref.getDownloadURL();
    return link;
  }
}
