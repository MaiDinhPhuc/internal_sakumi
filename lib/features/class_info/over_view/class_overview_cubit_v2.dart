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
  List<StudentModel> students = [];
  List<double> listAttendance = [], listHomework = [];
  int countAvailable = 0;
  List<LessonResultModel>? lessonResults;
  List<StudentLessonModel>? stdLessons;
  List<LessonModel>? lessons;
  List<StudentClassModel>? listStdClass;
  double percentHw = 0;

  bool loaded = false;


  update() async {
    await DataProvider.stdClassByClassId(classId, loadStudentClass);

    if(classModel!.customLessons.isEmpty){
      await DataProvider.lessonByCourseId(
          classModel!.courseId, loadLessonInClass);
    }else{

      await DataProvider.lessonByCourseAndClassId(
          classModel!.courseId,classId, loadLessonInClass);

      var lessonId = lessons!.map((e) => e.lessonId).toList();

      if(classModel!.customLessons.isNotEmpty){
        for(var i in classModel!.customLessons){
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


    await DataProvider.stdLessonByClassId(classId, loadStdLesson);

    await DataProvider.lessonResultByClassId(classId, loadLessonResult);

    var listStdId = listStdClass!.map((e) => e.userId).toList();
    students = [];
    for (var i in listStdId) {
      DataProvider.studentById(i, loadStudentInfo);
    }

    loadListPercent();

    emit(state + 1);
  }

  loadData() async {
    classModel = await FireBaseProvider.instance.getClassById(classId);

    emit(state + 1);

    DataProvider.stdClassByClassId(classId, loadStudentClass);

    DataProvider.stdLessonByClassId(classId, loadStdLesson);

    if(classModel!.customLessons.isEmpty){
      DataProvider.lessonByCourseId(classModel!.courseId,loadLessonInClass);
    }else{
      DataProvider.lessonByCourseAndClassId(classModel!.courseId,classId,loadLessonInClass);

      var lessonId = lessons!.map((e) => e.lessonId).toList();

      if(classModel!.customLessons.isNotEmpty){
        for(var i in classModel!.customLessons){
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



    DataProvider.lessonResultByClassId(classId, loadLessonResult);

    await Future.delayed(const Duration(milliseconds: 500));

    var listStdId = listStdClass!.map((e) => e.userId).toList();
    students = [];
    for (var i in listStdId) {
      DataProvider.studentById(i, loadStudentInfo);
    }

    loadListPercent();

    loaded = true;

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

    List<LessonModel> lessonTemp =
    lessons!.where((element) => element.btvn == 0).toList();
    List<int> lessonExceptionIds = [];
    for (var i in lessonTemp) {
      lessonExceptionIds.add(i.lessonId);
    }
    double count1 = 0;
    double total1 = 0;
    for (var i in stdLessons!) {
      if (listStdIdsEnable.contains(i.studentId) && i.timekeeping != 0) {
        if (lessonExceptionIds.contains(i.lessonId) == false) {
          total1++;
          if (getPoint(i.lessonId, i.studentId) != -2) {
            count1++;
          }
        }
      }
    }
    percentHw = count1 / (total1 == 0 ? 1 : total1);
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
      if ((i.classStatus != "Remove" &&
          i.classStatus != "Moved" &&
          i.classStatus != "Viewer")) {
        temp++;
      }
    }
    return ((upNumber / temp) * 100).roundToDouble();
  }



  loadStudentInfo(Object student) {
    students.add(student as StudentModel);
    if(students.length == listStdClass!.length){
      emit(state+1);
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
