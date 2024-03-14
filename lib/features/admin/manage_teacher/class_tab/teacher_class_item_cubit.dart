import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/admin/manage_teacher/teacher_info/teacher_info_cubit.dart';
import 'package:internal_sakumi/features/calculator/calculator.dart';
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

    attendancePercent = Calculator.classAttendancePercent(stdClasses!, stdLessons!, lessons!);

    hwPercent = Calculator.classHwPercent(stdClasses!, stdLessons!, lessons!);

    emit(state + 1);
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
        if (Calculator.getPoint(i.lessonId, i.studentId,lessons!,stdLessons!) != -2 && i.timekeeping != 0) {
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