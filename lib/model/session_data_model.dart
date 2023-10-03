import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/model/student_model.dart';

class SessionDataModel {
  List<StudentModel> listStudent;
  List<StudentLessonModel> listStudentLesson;
  List<StudentClassModel> listStudentClass;

  SessionDataModel({
    required this.listStudent,
    required this.listStudentLesson,
    required this.listStudentClass,
  });

  factory SessionDataModel.fromData(
    List<StudentModel> listStudent,
    List<StudentLessonModel> listStudentLesson,
    List<StudentClassModel> listStudentClass,
  ) {
    return SessionDataModel(
        listStudent: listStudent,
        listStudentLesson: listStudentLesson,
        listStudentClass: listStudentClass);
  }
}
