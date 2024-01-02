import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/providers/cache/cached_data_provider.dart';

class ClassDetailCubit extends Cubit<int> {
  ClassDetailCubit(this.classModel) : super(0) {
    loadData();
  }

  final ClassModel classModel;
  List<LessonResultModel>? lessonResults;
  List<StudentLessonModel>? stdLessons;
  List<StudentClassModel>? stdClasses;
  List<LessonModel>? lessons;

  String? title;
  int? lessonCount;
  String? lessonCountTitle;
  double? hwPercent, attendancePercent;
  String? lastLesson;

  loadData() async {
    await DataProvider.courseById(classModel.courseId, onCourseLoaded);

    await DataProvider.stdLessonByClassId(classModel.classId, loadStdLesson);

    await DataProvider.lessonResultByClassId(classModel.classId, loadLessonResult);

    await DataProvider.stdClassByClassId(classModel.classId, loadStudentClass);

    await DataProvider.lessonByCourseId(classModel.courseId, loadLessonInClass);

    await loadPercent();

  }

  onCourseLoaded(Object course) {
    title =
        "${(course as CourseModel).name} ${(course).level} ${(course).termName}";
    lessonCount = course.lessonCount;
    emit(state + 1);
  }

  loadLessonResult(Object lessonResults)  {
    this.lessonResults = lessonResults as List<LessonResultModel>;
    lessonCountTitle = "${this.lessonResults!.length}/$lessonCount";
    emit(state + 1);
  }

  loadStudentClass(Object studentClass)  {
    stdClasses = studentClass as List<StudentClassModel>;
  }

  loadLessonInClass(Object lessons) {
    this.lessons = lessons as List<LessonModel>;
    emit(state + 1);
  }

  loadStdLesson(Object stdLessons){
    this.stdLessons = stdLessons as List<StudentLessonModel>;
    emit(state+1);
  }

  loadPercent()async {
    await Future.delayed(const Duration(milliseconds: 500));
    List<int> listStdIdsEnable = [];

    for (var element in stdClasses!) {
      if (element.classStatus != "Remove" &&
          element.classStatus != "Moved" &&
          element.classStatus != "Retained" &&
          element.classStatus != "Dropped" &&
          element.classStatus != "Deposit" &&
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
        if (i.hw != -2) {
          hwPercentTemp++;
        }
      }
    }
    attendancePercent = attendanceTemp / (count == 0 ? 1 : count);
    hwPercent = hwPercentTemp / (countHw == 0 ? 1 : countHw);
    this.attendancePercent = attendancePercent;
    this.hwPercent = hwPercent;

    var lessonId = lessons!.map((e) => e.lessonId);
    var lessonResultId = lessonResults!.map((e) => e.lessonId);
    print(lessonResultId.length);
    print(lessonId);
    print(lessonId.contains(lessonResultId.last));
    var lastLesson = lessons!.firstWhere((e) => e.lessonId == lessonResults!.last.lessonId);
    this.lastLesson = lastLesson.title;
    emit(state + 1);
  }
}
