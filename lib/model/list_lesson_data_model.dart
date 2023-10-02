import 'package:internal_sakumi/model/teacher_model.dart';

import 'class_model.dart';

class ListLessonDataModel {
  ClassModel classModel;
  List<String?> listSpNote;
  List<String?> listTeacherNote;
  List<Map<String, dynamic>?> listDetailLesson;
  List<TeacherModel?> listTeacher;
  List<double?> listAttendance;
  List<double?> listHw;
  List<bool?> listHwStatus;
  List<String> listStatus;
  List<Map<String, dynamic>> listLessonInfo;

  ListLessonDataModel(
      {required this.classModel,
      required this.listAttendance,
      required this.listHw,
      required this.listTeacher,
      required this.listDetailLesson,
      required this.listSpNote,
      required this.listHwStatus,
      required this.listTeacherNote,
      required this.listLessonInfo, required this.listStatus});

  factory ListLessonDataModel.fromData(
      ClassModel classModel,
      List<String?> listSpNote,
      List<String?> listTeacherNote,
      List<Map<String, dynamic>?> listDetailLesson,
      List<TeacherModel?> listTeacher,
      List<double?> listAttendance,
      List<double?> listHw,
      List<bool?> listHwStatus, List<String> listStatus, List<Map<String, dynamic>> listLessonInfo) {
    return ListLessonDataModel(
        classModel: classModel,
        listLessonInfo: listLessonInfo,
        listSpNote: listSpNote,
        listTeacherNote: listTeacherNote,
        listDetailLesson: listDetailLesson,
        listTeacher: listTeacher,
        listAttendance: listAttendance,
        listHw: listHw,
        listHwStatus: listHwStatus,
        listStatus:listStatus);
  }
}
