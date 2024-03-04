import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/admin/manage_teacher/teacher_info_cubit.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/providers/cache/cached_data_provider.dart';

class TeacherClassItemCubit extends Cubit<int>{
  TeacherClassItemCubit( this.cubit, this.classModel):super(0){
    loadData();
  }


  final TeacherInfoCubit cubit;
  final ClassModel classModel;

  List<LessonModel>? lessons;
  List<LessonResultModel>? lessonResults;
  List<StudentLessonModel>? stdLessons;
  List<StudentClassModel>? stdClasses;

  String? title;
  int? lessonCount;
  String? lessonCountTitle;
  double? hwPercent, attendancePercent;

  onCourseLoaded(Object course) {
    title =
    "${(course as CourseModel).name} ${(course).level} ${(course).termName}";
    lessonCount = course.lessonCount + classModel.customLessons.length;
    emit(state + 1);
  }

  loadLessonResult(Object lessonResults) {
    this.lessonResults = lessonResults as List<LessonResultModel>;
    lessonCountTitle = "${this.lessonResults!.length}/$lessonCount";
    emit(state + 1);
  }

  loadStudentClass(Object studentClass) {
    stdClasses = studentClass as List<StudentClassModel>;
  }

  loadLessonInClass(Object lessons) {
    this.lessons = lessons as List<LessonModel>;
  }

  loadStdLesson(Object stdLessons) {
    this.stdLessons = stdLessons as List<StudentLessonModel>;
    emit(state + 1);
  }



  loadData()async{
    DataProvider.courseById(classModel.courseId, onCourseLoaded);

    await DataProvider.stdClassByClassId(classModel.classId, loadStudentClass);

    if(classModel.customLessons.isEmpty){
      await DataProvider.lessonByCourseId(classModel.courseId, loadLessonInClass);
    }else{
      await DataProvider.lessonByCourseAndClassId(classModel.courseId,classModel.classId, loadLessonInClass);

      var lessonId = lessons!.map((e) => e.lessonId).toList();

      if(classModel.customLessons.isNotEmpty){
        for(var i in classModel.customLessons){
          if(!lessonId.contains(i['custom_lesson_id'])){
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
    }
    emit(state+1);
    await DataProvider.stdLessonByClassId(classModel.classId, loadStdLesson);

    await DataProvider.lessonResultByClassId(
        classModel.classId, loadLessonResult);
    await loadPercent();
  }

  loadPercent() async {
    await Future.delayed(const Duration(milliseconds: 500));
    List<int> listStdIdsEnable = [];

    for (var element in stdClasses!) {
      if (element.classStatus != "Remove" &&
          element.classStatus != "Viewer") {
        listStdIdsEnable.add(element.userId);
      }
    }


    var stdLessons = this.stdLessons!
        .where(
            (e) => listStdIdsEnable.contains(e.studentId) && e.timekeeping != 0)
        .toList();

    double attendancePercent = 0;
    double hwPercent = 0;
    List<LessonModel> lessonTemp =
    lessons!.where((element) => element.btvn == 0).toList();
    List<int> lessonExceptionIds = [];
    for (var i in lessonTemp) {
      lessonExceptionIds.add(i.lessonId);
    }
    int count = stdLessons
        .where((element) => element.timekeeping != 0)
        .toList()
        .length;
    int countHw = 0;
    double attendanceTemp = 0;
    double hwPercentTemp = 0;
    for (var i in stdLessons) {
      if (i.timekeeping < 5) {
        attendanceTemp++;
      }
      if (lessonExceptionIds.contains(i.lessonId) == false) {
        countHw++;
        if (getPoint(i.lessonId, i.studentId) != -2) {
          hwPercentTemp++;
        }
      }
    }
    attendancePercent = attendanceTemp / (count == 0 ? 1 : count);
    hwPercent = hwPercentTemp / (countHw == 0 ? 1 : countHw);
    this.attendancePercent = attendancePercent;
    this.hwPercent = hwPercent;

    emit(state + 1);
  }

  double getPoint(int lessonId, int stdId) {
    bool isCustom =
        lessons!.firstWhere((e) => e.lessonId == lessonId).isCustom;

    List<StudentLessonModel> stdLesson =
    stdLessons!.where((e) => e.lessonId == lessonId && e.studentId == stdId).toList();
    if (isCustom) {
      return getHwCustomPoint(lessonId, stdId);
    }
    if(stdLesson.isEmpty) return -2;
    return stdLesson.first.hw;
  }

  double getHwCustomPoint(int lessonId, int stdId) {
    List<StudentLessonModel> stdLesson =
    stdLessons!.where((e) => e.lessonId == lessonId && e.studentId == stdId).toList();

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
        if (getPoint(i.lessonId, i.studentId) != -2 && i.timekeeping != 0) {
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