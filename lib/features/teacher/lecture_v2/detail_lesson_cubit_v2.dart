import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/prefKey_configs.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/providers/cache/cached_data_provider.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailLessonCubitV2 extends Cubit<int> {
  DetailLessonCubitV2(this.classId, this.lessonId) : super(0) {
    loadData();
  }

  final int classId;
  final int lessonId;

  ClassModel? classModel;

  List<LessonResultModel>? listLessonResult;
  LessonResultModel? lessonResult;
  LessonResultModel? lastLessonResult;
  List<StudentClassModel>? stdClasses;
  List<StudentModel> students = [];
  List<StudentLessonModel>? stdLessons;
  LessonModel? lesson;
  int? teacherId;
  bool loading = false;
  int totalAttendance = 0;
  bool? isNoteStudent = false;
  bool? isNoteSupport = false;
  bool? isNoteSensei = false;
  String noteStudent = '';
  String noteSupport = '';
  String noteSensei = '';

  bool check1 = false;
  bool check2 = false;
  bool check3 = false;
  String? teacherNote;
  String? supportNote;
  List<String> listNoteForEachStudent = List.generate(1000, (index) => "");
  load() {
    if (lessonResult == null && lastLessonResult == null) {
      supportNote = "";
      teacherNote = "";
    } else {
      supportNote = lastLessonResult!.supportNoteForTeacher;
      teacherNote = lastLessonResult!.noteForTeacher;
    }

    if (supportNote == "") {
      check2 = true;
    }

    if (teacherNote == "") {
      check3 = true;
    }

    loading = false;
    emit(state + 1);
  }

  updateCheck1() {
    check1 = !check1;
    emit(state + 1);
  }

  updateCheck2() {
    check2 = !check2;
    emit(state + 1);
  }

  updateCheck3() {
    check3 = !check3;
    emit(state + 1);
  }

  inputStudent(String text) {
    noteStudent = text;
    emit(state + 1);
  }

  inputSupport(String text) {
    noteSupport = text;
    emit(state + 1);
  }

  inputSensei(String text) {
    noteSensei = text;
    emit(state + 1);
  }

  checkNoteStudent() {
    if (isNoteStudent != null) {
      if (isNoteStudent == false) {
        isNoteStudent = true;
      } else {
        isNoteStudent = false;
      }
    }
    debugPrint('================> checkNoteStudent $isNoteStudent');
    emit(state + 1);
  }

  checkNoteSupport() {
    if (isNoteSupport != null) {
      if (isNoteSupport == false) {
        isNoteSupport = true;
      } else {
        isNoteSupport = false;
      }
    }
    emit(state + 1);
  }

  checkNoteSensei() {
    if (isNoteSensei != null) {
      if (isNoteSensei == false) {
        isNoteSensei = true;
      } else {
        isNoteSensei = false;
      }
    }
    emit(state + 1);
  }

  addLessonResult(LessonResultModel newLessonResult) {
    lessonResult = newLessonResult;
    listLessonResult!.add(newLessonResult);
    DataProvider.updateLessonResult(classId, listLessonResult!);
    loadWhenTeaching();
    emit(state + 1);
    FireBaseProvider.instance.addLessonResult(newLessonResult);
  }

  StudentLessonModel? getStdLesson(int stdId) {
    var stdLesson = stdLessons!
        .where((e) => e.studentId == stdId && e.lessonId == lessonId)
        .toList();
    if (stdLesson.isEmpty) {
      return null;
    }
    return stdLesson.first;
  }

  loadData() async {
    loading = true;

    SharedPreferences localData = await SharedPreferences.getInstance();
    var userId = localData.getInt(PrefKeyConfigs.userId);

    teacherId = userId;

    classModel = await FireBaseProvider.instance.getClassById(classId);

    if (classModel!.customLessons.isEmpty) {
      lesson = await FireBaseProvider.instance.getLessonById(lessonId);
    } else {
      for (var i in classModel!.customLessons) {
        if (i['custom_lesson_id'] == lessonId) {
          lesson = LessonModel(
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
              isCustom: true);
          break;
        }
      }
    }

    lesson ??= await FireBaseProvider.instance.getLessonById(lessonId);

    emit(state + 1);

    DataProvider.lessonResultByClassId(classId, loadLessonResult);

    if (lessonResult == null || lessonResult!.status == "Pending") {
      load();
    } else if (lessonResult!.status == "Teaching") {
      loadWhenTeaching();
    } else {
      loadWhenWaiting();
    }
  }

  loadWhenWaiting() async {
    loading = true;

    await DataProvider.stdClassByClassId(classId, loadStudentClass);

    await DataProvider.stdLessonByClassId(classId, loadStdLesson);

    List<int> listStdId = [];
    for (var i in stdClasses!) {
      if (i.classStatus != "Remove" &&
          i.classStatus != "Dropped" &&
          i.classStatus != "Deposit" &&
          i.classStatus != "Retained" &&
          i.classStatus != "Moved" &&
          i.classStatus != "Viewer") {
        listStdId.add(i.userId);
      }
    }
    for (var i in listStdId) {
      DataProvider.studentById(i, loadStudentInfo);
    }

    loading = false;
    emit(state + 1);
  }

  loadWhenTeaching() async {
    loading = true;

    await DataProvider.stdClassByClassId(classId, loadStudentClass);

    await DataProvider.stdLessonByClassId(classId, loadStdLesson);

    List<int> listStdId = [];
    for (var i in stdClasses!) {
      if (i.classStatus != "Remove" &&
          i.classStatus != "Dropped" &&
          i.classStatus != "Deposit" &&
          i.classStatus != "Retained" &&
          i.classStatus != "Moved" &&
          i.classStatus != "Viewer") {
        listStdId.add(i.userId);
      }
    }
    for (var i in listStdId) {
      DataProvider.studentById(i, loadStudentInfo);
    }

    var listStdLesson =
        stdLessons!.where((e) => e.lessonId == lessonId).toList();

    totalAttendance =
        listStdLesson.fold(0, (pre, e) => e.timekeeping > 0 ? (pre + 1) : pre);

    loading = false;
    emit(state + 1);
  }

  updateStatus(String status) async {
    await FireBaseProvider.instance
        .changeStatusLesson(lessonId, classId, status);

    var index = listLessonResult!.indexOf(lessonResult!);

    lessonResult = LessonResultModel(
        id: lessonResult!.id,
        classId: lessonResult!.classId,
        lessonId: lessonResult!.lessonId,
        teacherId: lessonResult!.teacherId,
        status: status,
        date: lessonResult!.date,
        noteForStudent: lessonResult!.noteForStudent,
        noteForSupport: lessonResult!.noteForSupport,
        noteForTeacher: lessonResult!.noteForTeacher,
        supportNoteForTeacher: lessonResult!.supportNoteForTeacher);

    listLessonResult![index] = lessonResult!;

    DataProvider.updateLessonResult(classId, listLessonResult!);

    emit(state + 1);
  }

  updateStudentLesson(int stdId, StudentLessonModel stdLesson) async {
    var index = stdLessons!.indexOf(stdLessons!
        .firstWhere((e) => e.studentId == stdId && e.lessonId == lessonId));

    stdLessons![index] = stdLesson;

    DataProvider.updateStdLesson(classId, stdLessons!);

    emit(state + 1);
  }

  updateTimekeeping(int attendId) {
    debugPrint(
        '============> totalAttendance000 $totalAttendance -- $attendId');
    if (attendId > 0 && totalAttendance < students.length) {
      totalAttendance++;
    }
    if (attendId <= 0 && totalAttendance > 0) {
      totalAttendance--;
    }

    debugPrint(
        '============> totalAttendance1111 $totalAttendance -- $attendId');
    emit(state + 1);
  }

  loadStdLesson(Object stdLessons) {
    this.stdLessons = stdLessons as List<StudentLessonModel>;
  }

  loadStudentInfo(Object student) {
    students.add(student as StudentModel);
    if (students.length == stdClasses!.length) {
      emit(state + 1);
    }
  }

  loadStudentClass(Object studentClass) {
    stdClasses = studentClass as List<StudentClassModel>;
  }

  loadLessonResult(Object lessonResults) {
    var listLessonResult = lessonResults as List<LessonResultModel>;
    this.listLessonResult = listLessonResult;
    if (listLessonResult.isEmpty) {
      lessonResult = null;
      lastLessonResult = null;
    } else {
      if (listLessonResult.last.lessonId != lessonId) {
        lastLessonResult = listLessonResult.last;
      } else {
        lastLessonResult = listLessonResult.last;
      }
      var temp = listLessonResult.where((e) => e.lessonId == lessonId).toList();
      if (temp.isEmpty) {
        lessonResult = null;
      } else {
        lessonResult = temp.first;
      }
    }

    emit(state + 1);
  }

  noteForStudents(String note) async {
    await FireBaseProvider.instance
        .noteForAllStudentInClass(lessonId, classId, note);
    await FireBaseProvider.instance
        .updateTeacherInLessonResult(lessonId, classId, teacherId!);
    var index = listLessonResult!.indexOf(lessonResult!);
    lessonResult = LessonResultModel(
        id: lessonResult!.id,
        classId: lessonResult!.classId,
        lessonId: lessonResult!.lessonId,
        teacherId: lessonResult!.teacherId,
        status: lessonResult!.status,
        date: lessonResult!.date,
        noteForStudent: note,
        noteForSupport: lessonResult!.noteForSupport,
        noteForTeacher: lessonResult!.noteForTeacher,
        supportNoteForTeacher: lessonResult!.supportNoteForTeacher);

    listLessonResult![index] = lessonResult!;

    DataProvider.updateLessonResult(classId, listLessonResult!);
    emit(state + 1);
  }

  inputNoteForEachStudent(String text, int stdId) {
    var std = students.firstWhere((e) => e.userId == stdId);
    var index = students.indexOf(std);
    listNoteForEachStudent[index] = text;
  }

  noteForSupport(String note) async {
    await FireBaseProvider.instance.noteForSupport(lessonId, classId, note);
    var index = listLessonResult!.indexOf(lessonResult!);
    lessonResult = LessonResultModel(
        id: lessonResult!.id,
        classId: lessonResult!.classId,
        lessonId: lessonResult!.lessonId,
        teacherId: lessonResult!.teacherId,
        status: lessonResult!.status,
        date: lessonResult!.date,
        noteForStudent: lessonResult!.noteForStudent,
        noteForSupport: note,
        noteForTeacher: lessonResult!.noteForTeacher,
        supportNoteForTeacher: lessonResult!.supportNoteForTeacher);

    listLessonResult![index] = lessonResult!;

    DataProvider.updateLessonResult(classId, listLessonResult!);
  }

  noteForAnotherSensei(String note) async {
    await FireBaseProvider.instance
        .noteForAnotherSensei(lessonId, classId, note);
    var index = listLessonResult!.indexOf(lessonResult!);
    lessonResult = LessonResultModel(
        id: lessonResult!.id,
        classId: lessonResult!.classId,
        lessonId: lessonResult!.lessonId,
        teacherId: lessonResult!.teacherId,
        status: lessonResult!.status,
        date: lessonResult!.date,
        noteForStudent: lessonResult!.noteForStudent,
        noteForSupport: lessonResult!.noteForSupport,
        noteForTeacher: note,
        supportNoteForTeacher: lessonResult!.supportNoteForTeacher);

    listLessonResult![index] = lessonResult!;

    DataProvider.updateLessonResult(classId, listLessonResult!);
  }

  updateDataAttendance() async {
    await DataProvider.stdLessonByClassId(classId, loadStdLesson);
  }
}
