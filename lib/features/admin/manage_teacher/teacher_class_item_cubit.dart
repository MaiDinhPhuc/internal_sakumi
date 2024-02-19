import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/admin/manage_teacher/teacher_info_cubit.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/model/teacher_class_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

class TeacherClassItemCubit extends Cubit<int>{
  TeacherClassItemCubit(this.classId, this.cubit, this.teacherClass):super(0);

  final TeacherClassModel teacherClass;
  final int classId;
  final TeacherInfoCubit cubit;
  List<LessonModel>? lessons;
  List<LessonResultModel>? lessonResults;
  List<StudentLessonModel>? stdLessons;
  List<StudentClassModel>? stdClasses;
  String? countTitle;
  CourseModel? courseModel;
  ClassModel? classModel;

  loadData()async{
    classModel = cubit.classes!.firstWhere((e) => e.classId == classId);
    courseModel = cubit.courses.firstWhere((e) => e.courseId == classModel!.courseId);
    stdClasses = cubit.stdClasses!.where((e) => e.classId == classId).toList();
    lessonResults =
        cubit.lessonResults!.where((e) => e.classId == classId).toList();
    countTitle =
    "${lessonResults!.length}/${courseModel!.lessonCount + classModel!.customLessons.length}";
    stdLessons = cubit.stdLessons!.where((e) => e.classId == classId).toList();
    lessons = await FireBaseProvider.instance.getLessonsByCourseId(courseModel!.courseId);
    var lessonId = lessons!.map((e) => e.lessonId).toList();

    if (classModel!.customLessons.isNotEmpty) {
      for (var i in classModel!.customLessons) {
        if (!lessonId.contains(i['custom_lesson_id'])) {
          lessons!.add(LessonModel(
              lessonId: i['custom_lesson_id'],
              courseId: -1,
              description: i['description'],
              content: "",
              title: i['title'],
              btvn: -1,
              vocabulary: 0,
              listening: 0,
              kanji: 0,
              grammar: 0,
              flashcard: 0,
              alphabet: 0,
              order: 0,
              reading: 0,
              enable: true,
              customLessonInfo: i['lessons_info'],
              isCustom: true));
        }
      }
    }
    emit(state+1);
  }
  double getLessonPercent() {
    return cubit.lessonResults == null
        ? 0
        : lessonResults!.length /
        (courseModel!.lessonCount + classModel!.customLessons.length);
  }
  double getAttendancePercent() {
    if (stdLessons == null || stdLessons!.isEmpty) {
      return 0;
    }

    int temp1 = 0;
    int temp2 = 0;
    for (var i in stdLessons!) {
      if (i.timekeeping != 0 && i.timekeeping != 5 && i.timekeeping != 6) {
        temp1++;
      }
      if (i.timekeeping != 0) {
        temp2++;
      }
    }
    if (temp2 == 0) {
      return 0;
    }
    double attendancePercent = temp1 / temp2;

    return attendancePercent;
  }

  double getHwPercent() {
    if (stdLessons == null || stdLessons!.isEmpty) {
      return 0;
    }

    int temp1 = 0;
    int temp2 = 0;
    for (var i in stdLessons!) {
      if (getPoint(i.lessonId) != -2 && i.timekeeping != 0) {
        temp1++;
      }
      if (i.timekeeping != 0) {
        temp2++;
      }
    }
    if (temp2 == 0) {
      return 0;
    }
    double attendancePercent = temp1 / temp2;

    return attendancePercent;
  }

  double getPoint(int lessonId) {

    if(lessons == null) return -2;

    var lesson = lessons!.where((e) => e.lessonId == lessonId).toList();
    bool isCustom = false;
    if(lesson.isNotEmpty){
      isCustom = lesson.first.isCustom;
    }
    List<StudentLessonModel> stdLesson =
    stdLessons!.where((e) => e.lessonId == lessonId).toList();
    if (isCustom) {
      return getHwCustomPoint(lessonId);
    }
    if(stdLesson.isEmpty) return -2;
    return stdLesson.first.hw;
  }

  double getHwCustomPoint(int lessonId) {
    List<StudentLessonModel> stdLesson =
    stdLessons!.where((e) => e.lessonId == lessonId).toList();

    if (stdLesson.isEmpty) {
      return -2;
    }
    List<dynamic> listHws = stdLesson.first.hws.map((e) => e['hw']).toList();

    if (listHws.every((e) => e == -2)) {
      return -2;
    } else if (listHws.every((e) => e > 0)) {
      return listHws.reduce((value, element) => value + element) /
          listHws.length;
    }
    return -1;
  }

  String getTitle(int lessonId){

    if(lessons == null) return "";

    var lesson = lessons!.where((e) => e.lessonId == lessonId).toList();
    if(lesson.isEmpty) return "";

    return lesson.first.title;
  }

  double getAttendanceForLesson(int lessonId){
    if (stdLessons == null || stdLessons!.isEmpty) {
      return 0;
    }
    var listStdId = stdClasses!.map((e) => e.userId).toList();

    if(listStdId.isEmpty){
      return 0;
    }

    var listStdLesson = stdLessons!.where((e) => e.lessonId == lessonId).toList();

    int temp1 = 0;
    int temp2 = 0;
    for (var i in listStdLesson) {
      if(listStdId.contains(i.studentId)){
        if (i.timekeeping != 0 && i.timekeeping != 5 && i.timekeeping != 6) {
          temp1++;
        }
        if (i.timekeeping != 0) {
          temp2++;
        }
      }
    }

    if (temp2 == 0) {
      return 0;
    }

    double attendancePercent = temp1 / temp2;

    return attendancePercent;
  }

  double getHwForLesson(int lessonId){
    if (stdLessons == null || stdLessons!.isEmpty) {
      return 0;
    }
    var listStdId = stdClasses!.map((e) => e.userId).toList();

    if(listStdId.isEmpty){
      return 0;
    }

    var listStdLesson = stdLessons!.where((e) => e.lessonId == lessonId).toList();
    int temp1 = 0;
    int temp2 = 0;
    for (var i in listStdLesson) {
      if(listStdId.contains(i.studentId)){
        if (getPoint(i.lessonId) != -2 && i.timekeeping != 0) {
          temp1++;
        }
        if (i.timekeeping != 0) {
          temp2++;
        }
      }
    }
    if (temp2 == 0) {
      return 0;
    }

    double hwPercent = temp1 / temp2;

    return hwPercent;
  }
}