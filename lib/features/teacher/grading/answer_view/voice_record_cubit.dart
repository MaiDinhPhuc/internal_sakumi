import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/teacher/grading/answer_view/record_services.dart';

class VoiceRecordCubit extends Cubit<List<dynamic>>{
  VoiceRecordCubit() : super([]);

  init(List<dynamic> list){
    emit(list);
  }

  startRecord(){
    RecordService.instance.start();
  }

  stopRecord(){
    RecordService.instance.stop();
  }

}