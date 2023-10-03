import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/list_lesson_data_model.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/utils/text_utils.dart';

class LessonTabCubit extends Cubit<int> {
  LessonTabCubit() : super(0);

  ListLessonDataModel? data;

  ClassModel? classModel;
  List<String?>? listSpNote;
  List<String?>? listTeacherNote;
  List<Map<String, dynamic>?>? listDetailLesson;
  List<TeacherModel?>? listTeacher;
  List<double?>? listAttendance;
  List<double?>? listHw;
  List<bool?>? listHwStatus;
  List<String>? listStatus;
  List<Map<String, dynamic>>? listLessonInfo;

  load()async{
    data = await FireBaseProvider.instance.getDataForLessonTab(int.parse(TextUtils.getName()));
    classModel = data!.classModel;
    listSpNote = data!.listSpNote;
    listTeacherNote = data!.listTeacherNote;
    listDetailLesson = data!.listDetailLesson;
    listTeacher = data!.listTeacher;
    listAttendance = data!.listAttendance;
    listHw = data!.listHw;
    listHwStatus = data!.listHwStatus;
    listStatus = data!.listStatus;
    listLessonInfo = data!.listLessonInfo;
    emit(state+1);
  }
}
