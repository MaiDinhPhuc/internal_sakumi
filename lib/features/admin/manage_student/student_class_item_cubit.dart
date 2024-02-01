import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/admin/manage_student/student_info_cubit.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/providers/cache/cached_data_provider.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

class StudentClasItemCubit extends Cubit<int> {
  StudentClasItemCubit(this.classId, this.cubit, this.stdClass) : super(0);

  ClassModel? classModel;
  CourseModel? courseModel;
  final StudentClassModel stdClass;
  List<LessonModel>? lessons;
  List<LessonResultModel>? lessonResults;
  List<StudentLessonModel>? stdLessons;
  String? countTitle;
  bool isLoading = true;

  final int classId;
  final StudentInfoCubit cubit;
  loadData() async {
    classModel = cubit.classes!.firstWhere((e) => e.classId == classId);
    courseModel =
        cubit.courses.firstWhere((e) => e.courseId == classModel!.courseId);
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
    isLoading = false;
    emit(state+1);
  }

  String getIcon() {
    switch (stdClass.classStatus) {
      case 'Completed':
        return 'check';
      case 'Moved':
        return 'moved';
      case 'Retained':
        return 'retained';
      case 'Dropped':
      case 'Deposit':
      case 'Remove':
        return 'dropped';
      case 'Viewer':
        return 'viewer';
      case 'UpSale':
      case "Force":
        return 'up_sale';
      case 'ReNew':
        return 're_new';
      default:
        return 'in_progress';
    }
  }

  Color getColor() {
    switch (stdClass.classStatus) {
      case 'Completed':
      case 'Moved':
        return const Color(0xffF57F17);
      case 'Retained':
      case 'UpSale':
        return const Color(0xffE65100);
      case 'ReNew':
      case 'Dropped':
      case 'Remove':
        return const Color(0xffB71C1C);
      case 'Viewer':
        return const Color(0xff757575);
      case 'Deposit':
        return Colors.black;
      case 'Force':
        return Colors.blue;
      default:
        return const Color(0xff33691e);
    }
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
    bool isCustom =
        lessons!.firstWhere((e) => e.lessonId == lessonId).isCustom;
    StudentLessonModel stdLesson =
    stdLessons!.firstWhere((e) => e.lessonId == lessonId);
    if (isCustom) {
      return getHwCustomPoint(lessonId);
    }
    return stdLesson.hw;
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
}
