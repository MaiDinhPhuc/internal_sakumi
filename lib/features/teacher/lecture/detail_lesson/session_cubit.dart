import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/prefKey_configs.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/repository/admin_repository.dart';
import 'package:internal_sakumi/repository/teacher_repository.dart';
import 'package:internal_sakumi/utils/text_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionCubit extends Cubit<int> {
  SessionCubit() : super(0);

  List<StudentModel>? listStudent;
  List<StudentLessonModel>? listStudentLesson;
  List<StudentClassModel>? listStudentClass;
  int totalAttendance = 0, teacherId = -1;
  ClassModel? classModel;
  bool? isNoteStudent = false;
  bool? isNoteSupport = false;
  bool? isNoteSensei = false;
  String noteStudent = '';
  String noteSupport = '';
  String noteSensei = '';

  static SessionCubit fromContext(BuildContext context) =>
      BlocProvider.of<SessionCubit>(context);

  init(context) async {
    await getTeacherId();
    debugPrint('===============> init session $teacherId');
    await loadStudentInClass(context);
    await loadStudentLesson(context);
    totalAttendance = listStudentLesson!
        .fold(0, (pre, e) => e.timekeeping > 0 ? (pre + 1) : pre);
  }

  getTeacherId() async {
    SharedPreferences localData = await SharedPreferences.getInstance();

    teacherId = int.parse(localData.getInt(PrefKeyConfigs.userId).toString());
  }

  inputStudent(String text){
    noteStudent = text;
    emit(state+1);
  }

  inputSupport(String text){
    noteSupport = text;
    emit(state+1);
  }

  inputSensei(String text){
    noteSensei = text;
    emit(state+1);
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

  updateTimekeeping(int attendId) {
    debugPrint('============> totalAttendance000 $totalAttendance -- $attendId');
    if (attendId > 0 && totalAttendance < listStudent!.length) {
      totalAttendance++;
    }
    if(attendId <= 0 && totalAttendance > 0) {
      totalAttendance--;
    }

    debugPrint('============> totalAttendance1111 $totalAttendance -- $attendId');
    emit(state + 1);
  }

  loadStudentInClass(context) async {
    AdminRepository adminRepository = AdminRepository.fromContext(context);
    List<StudentModel> listAllStudent = await adminRepository.getAllStudent();

    List<StudentClassModel>? list = await adminRepository
        .getStudentClassByClassId(int.parse(TextUtils.getName(position: 2)));

    listStudentClass = [];
    listStudentClass!.addAll(list);

    listStudent = [];
    for (var i in listAllStudent) {
      for (var j in listStudentClass!) {
        if (i.userId == j.userId) {
          listStudent!.add(i);
          break;
        }
      }
    }
    debugPrint('================> listStudent ${listStudent!.length}');
    emit(state + 1);
  }

  loadStudentLesson(context) async {
    TeacherRepository teacherRepository =
    TeacherRepository.fromContext(context);

    var list = await teacherRepository.getAllStudentLessonInLesson(
        int.parse(TextUtils.getName(position: 2)),
        int.parse(TextUtils.getName()));

    debugPrint(
        '=============> loadStudentLesson loadStudentLesson ${list.length}');
    listStudentLesson = [];
    listStudentLesson!.addAll(list);

    debugPrint(
        '=============> loadStudentLesson loadStudentLesson loadStudentLesson');
    emit(state + 1);
  }
}