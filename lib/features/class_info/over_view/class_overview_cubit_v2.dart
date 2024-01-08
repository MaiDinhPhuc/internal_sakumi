import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/providers/cache/cached_data_provider.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

class ClassOverViewCubitV2 extends Cubit<int> {
  ClassOverViewCubitV2(this.classId) : super(0) {
    loadData();
  }
  final int classId;
  ClassModel? classModel;
  List<StudentModel>? students;
  List<double> listAttendance = [], listHomework = [];
  int countAvailable = 0;
  List<LessonResultModel>? lessonResults;
  List<StudentLessonModel>? stdLessons;
  List<LessonModel>? lessons;
  List<StudentClassModel>? listStdClass;
  List<Map<String, dynamic>> listStdDetail = [];
  double percentHw = 0;

  bool loaded = false;

  List<String> listStudentStatusMenu = [
    "Completed",
    "InProgress",
    "Viewer",
    "ReNew",
    "UpSale",
    "Moved",
    "Retained",
    "Dropped",
    "Deposit",
    "Force",
    "Remove"
  ];

  update() async {
    await DataProvider.stdClassByClassId(classId, loadStudentClass);

    await DataProvider.lessonByCourseId(
        classModel!.courseId, loadLessonInClass);

    await DataProvider.stdLessonByClassId(classId, loadStdLesson);

    await DataProvider.lessonResultByClassId(classId, loadLessonResult);

    var listStdId = listStdClass!.map((e) => e.userId).toList();
    students = [];
    for (var i in listStdId) {
      DataProvider.studentById(i, loadStudentInfo);
    }

    loadListPercent();

    loadDetail();
    emit(state + 1);
  }

  loadData() async {
    classModel = await FireBaseProvider.instance.getClassById(classId);

    emit(state + 1);

    DataProvider.stdClassByClassId(classId, loadStudentClass);

    DataProvider.stdLessonByClassId(classId, loadStdLesson);

    DataProvider.lessonByCourseId(classModel!.courseId, loadLessonInClass);

    DataProvider.lessonResultByClassId(classId, loadLessonResult);

    await Future.delayed(const Duration(milliseconds: 500));

    var listStdId = listStdClass!.map((e) => e.userId).toList();
    students = [];
    for (var i in listStdId) {
      DataProvider.studentById(i, loadStudentInfo);
    }

    loadListPercent();

    loadDetail();

    loaded = true;

    emit(state + 1);
  }

  loadDetail() async {
    List<int> listStdIdsEnable = [];
    for (var element in listStdClass!) {
      if (element.classStatus != "Remove" &&
          element.classStatus != "Moved" &&
          element.classStatus != "Retained" &&
          element.classStatus != "Dropped" &&
          element.classStatus != "Deposit" &&
          element.classStatus != "Viewer") {
        listStdIdsEnable.add(element.userId);
      }
    }
    List<LessonModel> lessonTemp =
        lessons!.where((element) => element.btvn == 0).toList();
    List<int> lessonExceptionIds = [];
    for (var i in lessonTemp) {
      lessonExceptionIds.add(i.lessonId);
    }
    for (var i in listStdClass!) {
      List<StudentLessonModel> stdLesson = stdLessons!
          .where((element) => element.studentId == i.userId)
          .toList();

      List<int> listAttendance = [];
      List<double?> listHw = [];
      List<String> title = [];
      List<String> senseiNote = [];
      List<String> spNote = [];
      for (var j in stdLesson) {
        listAttendance.add(j.timekeeping);
        if (lessonExceptionIds.contains(j.lessonId)) {
          listHw.add(null);
        } else {
          listHw.add(j.hw);
        }
        title.add(lessons!
            .where((element) => element.lessonId == j.lessonId)
            .single
            .title);

        senseiNote.add(j.teacherNote);
        spNote.add(j.supportNote);
      }
      int tempAttendance = 0;
      int tempHw = 0;
      int countHw = 0;
      for (int j = 0; j < listAttendance.length; j++) {
        if (listAttendance[j] != 6 &&
            listAttendance[j] != 5 &&
            listAttendance[j] != 0) {
          tempAttendance++;
        }
        if (listAttendance[j] != 0) {
          if (listHw[j] != -2 && listHw[j] != null) {
            tempHw++;
          }
          if (listHw[j] != null) {
            countHw++;
          }
        }
      }

      int count = listAttendance.where((element) => element != 0).length;

      if (stdLesson.isEmpty) {
        listStdDetail.add({
          'id': i.userId,
          'status': i.classStatus,
          'attendance': listAttendance,
          'title': title,
          'hw': listHw,
          'attendancePercent': 0,
          'hwPercent': 0,
          'teacherNote': senseiNote,
          'spNote': spNote,
          'doingTime': getTime(stdLesson, "time_btvn"),
          'ignore': getNumber(stdLesson, "skip_btvn"),
          'time_alphabet': getTime(stdLesson, "time_alphabet"),
          'time_flashcard': getTime(stdLesson, "time_flashcard"),
          'time_grammar': getTime(stdLesson, "time_grammar"),
          'time_kanji': getTime(stdLesson, "time_kanji"),
          'time_listening': getTime(stdLesson, "time_listening"),
          'time_reading': getTime(stdLesson, "time_reading"),
          'time_vocabulary': getTime(stdLesson, "time_vocabulary"),
          'flip_flashcard': getNumber(stdLesson, "flip_flashcard")
        });
      } else {
        listStdDetail.add({
          'id': i.userId,
          'status': i.classStatus,
          'attendance': listAttendance,
          'title': title,
          'hw': listHw,
          'attendancePercent': tempAttendance / (count == 0 ? 1 : count),
          'hwPercent': tempHw / (countHw == 0 ? 1 : countHw),
          'teacherNote': senseiNote,
          'spNote': spNote,
          'doingTime': getTime(stdLesson, "time_btvn"),
          'ignore': getNumber(stdLesson, "skip_btvn"),
          'time_alphabet': getTime(stdLesson, "time_alphabet"),
          'time_flashcard': getTime(stdLesson, "time_flashcard"),
          'time_grammar': getTime(stdLesson, "time_grammar"),
          'time_kanji': getTime(stdLesson, "time_kanji"),
          'time_listening': getTime(stdLesson, "time_listening"),
          'time_reading': getTime(stdLesson, "time_reading"),
          'time_vocabulary': getTime(stdLesson, "time_vocabulary"),
          'flip_flashcard': getNumber(stdLesson, "flip_flashcard")
        });
      }
      emit(state + 1);
    }
    double count1 = 0;
    double total1 = 0;
    for (var i in stdLessons!) {
      if (listStdIdsEnable.contains(i.studentId) && i.timekeeping != 0) {
        if (lessonExceptionIds.contains(i.lessonId) == false) {
          total1++;
          if (i.hw != -2) {
            count1++;
          }
        }
      }
    }
    percentHw = count1 / (total1 == 0 ? 1 : total1);
    emit(state + 1);
  }

  loadListPercent() async {
    listAttendance = [];
    listHomework = [];
    countAvailable = 0;
    for (var i in listStdClass!) {
      if (i.classStatus != "Remove" &&
          i.classStatus != "Dropped" &&
          i.classStatus != "Deposit" &&
          i.classStatus != "Retained" &&
          i.classStatus != "Moved") {
        countAvailable++;
      }
    }
    List<int> listLessonIds = [];
    for (var i in lessonResults!) {
      if (listLessonIds.contains(i.lessonId) == false) {
        listLessonIds.add(i.lessonId);
      }
    }
    List<int> listStdIdsEnable = [];
    for (var element in listStdClass!) {
      if (element.classStatus != "Remove" &&
          element.classStatus != "Moved" &&
          element.classStatus != "Retained" &&
          element.classStatus != "Dropped" &&
          element.classStatus != "Deposit" &&
          element.classStatus != "Viewer") {
        listStdIdsEnable.add(element.userId);
      }
    }

    for (var i in listLessonIds) {
      List<StudentLessonModel> listTemp = stdLessons!
          .where((e) =>
              e.lessonId == i &&
              e.timekeeping != 0 &&
              listStdIdsEnable.contains(e.studentId))
          .toList();
      double tempAtt = 0;
      double tempHw = 0;
      for (var j in listTemp) {
        if (j.timekeeping < 5) {
          tempAtt++;
        }
        if (j.hw != -2) {
          tempHw++;
        }
      }

      listAttendance.add(tempAtt);
      listHomework.add(tempHw);
    }
    emit(state + 1);
  }

  loadStudentClass(Object studentClass) {
    listStdClass = studentClass as List<StudentClassModel>;
  }

  List<String> getTime(List<StudentLessonModel> stdLessons, String field) {
    if (stdLessons.isEmpty) {
      return [];
    }
    List<String> listTime = [];
    for (var stdLesson in stdLessons) {
      if (stdLesson.time.isEmpty) {
        listTime.add("");
      } else if (stdLesson.time[field] == null) {
        listTime.add("");
      } else {
        int seconds = stdLesson.time[field];

        int hours = seconds ~/ 3600;
        int minutes = (seconds % 3600) ~/ 60;
        int remainingSeconds = seconds % 60;

        String formattedTime =
            '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
        listTime.add(formattedTime);
      }
    }
    return listTime;
  }

  List<String> getNumber(List<StudentLessonModel> stdLessons, String field) {
    if (stdLessons.isEmpty) {
      return [];
    }
    List<String> listTime = [];
    for (var stdLesson in stdLessons) {
      if (stdLesson.time.isEmpty) {
        listTime.add("");
      } else if (stdLesson.time[field] == null) {
        listTime.add("");
      } else {
        int skip = stdLesson.time[field];
        listTime.add(skip.toString());
      }
    }
    return listTime;
  }

  double getPercentUpSale() {
    if (listStdClass == null) {
      return 0;
    }

    double upNumber = 0;
    int temp = 0;
    for (var i in listStdClass!) {
      if (i.classStatus == "UpSale" || i.classStatus == "Force") {
        upNumber++;
      }
      if ((i.classStatus != "Remove" ||
          i.classStatus != "Moved" ||
          i.classStatus != "Viewer")) {
        temp++;
      }
    }
    return ((upNumber / temp) * 100).roundToDouble();
  }

  double? getGPAPoint(int index) {
    double temp = 0;
    double count = 0;
    for (int i = 0; i < listStdDetail[index]["hw"].length; i++) {
      if (listStdDetail[index]["hw"][i] != null &&
          listStdDetail[index]["hw"][i] > -1) {
        temp += listStdDetail[index]["hw"][i];
        count++;
      }
    }
    return count == 0 ? null : temp / count;
  }

  loadStudentInfo(Object student) {
    students!.add(student as StudentModel);
    if (students!.length == listStdClass!.length) {
      emit(state + 1);
    }
  }

  loadStdLesson(Object stdLessons) {
    this.stdLessons = stdLessons as List<StudentLessonModel>;
  }

  loadLessonResult(Object lessonResults) {
    this.lessonResults = lessonResults as List<LessonResultModel>;
  }

  loadLessonInClass(Object lessons) {
    this.lessons = lessons as List<LessonModel>;
  }
}
