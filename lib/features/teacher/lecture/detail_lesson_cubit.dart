import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/repository/admin_repository.dart';
import 'package:internal_sakumi/repository/teacher_repository.dart';
import 'package:internal_sakumi/utils/text_utils.dart';

class DropdownCubit extends Cubit<int> {
  DropdownCubit() : super(0);

  update() {
    emit(state + 1);
  }
}

class DetailLessonCubit extends Cubit<LessonResultModel?> {
  DetailLessonCubit() : super(null) {
    //load();
  }

  load(context) async {
    TeacherRepository teacherRepository =
        TeacherRepository.fromContext(context);

    emit(await teacherRepository.getLessonResultByLessonId(
        int.parse(TextUtils.getName()),
        int.parse(TextUtils.getName(position: 2))));
  }

  updateStatus(context, String status) async {
    TeacherRepository teacherRepository =
        TeacherRepository.fromContext(context);

    await teacherRepository.changeStatusLesson(int.parse(TextUtils.getName()),
        int.parse(TextUtils.getName(position: 2)), status);

    emit(LessonResultModel(
        id: state!.id,
        classId: state!.classId,
        lessonId: state!.lessonId,
        teacherId: state!.teacherId,
        status: status,
        date: state!.date,
        noteForStudent: state!.noteForStudent,
        noteForSupport: state!.noteForSupport,
        noteForTeacher: state!.noteForTeacher));
    //load(context);
  }

  noteForStudents(context, String note) async {
    TeacherRepository teacherRepository =
        TeacherRepository.fromContext(context);

    await teacherRepository.noteForAllStudentInClass(
        int.parse(TextUtils.getName()),
        int.parse(TextUtils.getName(position: 2)),
        note);
    emit(LessonResultModel(
        id: state!.id,
        classId: state!.classId,
        lessonId: state!.lessonId,
        teacherId: state!.teacherId,
        status: state!.status,
        date: state!.date,
        noteForStudent: note,
        noteForSupport: state!.noteForSupport,
        noteForTeacher: state!.noteForTeacher));
  }
}

class SessionCubit extends Cubit<int> {
  SessionCubit() : super(0);

  List<StudentModel>? listStudent;
  List<StudentLessonModel>? listStudentLesson;
  List<StudentClassModel>? listStudentClass;
  int totalAttendance = 0;
  bool? isNoteStudent = false;
  bool? isNoteSupport = false;
  bool? isNoteSensei = false;

  static SessionCubit fromContext(BuildContext context) =>
      BlocProvider.of<SessionCubit>(context);

  init(context) async {
    await loadStudentInClass(context);
    await loadStudentLesson(context);
    totalAttendance = listStudentLesson!
        .fold(0, (pre, e) => e.timekeeping > 0 ? (pre + 1) : pre);
  }

  _updateUI() {
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
    _updateUI();
  }

  checkNoteSupport() {
    if (isNoteSupport != null) {
      if (isNoteSupport == false) {
        isNoteSupport = true;
      } else {
        isNoteSupport = false;
      }
    }
    _updateUI();
  }

  checkNoteSensei() {
    if (isNoteSensei != null) {
      if (isNoteSensei == false) {
        isNoteSensei = true;
      } else {
        isNoteSensei = false;
      }
    }
    _updateUI();
  }

  updateTimekeeping(int attendId) {
    if (attendId! > 0) {
      totalAttendance++;
    } else {
      totalAttendance--;
    }

    debugPrint('============> totalAttendance $totalAttendance -- $attendId');
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
    for (var i in listStudentClass!) {
      for (var j in listAllStudent) {
        if (i.userId == j.userId) {
          listStudent!.add(j);
          break;
        }
      }
    }
    emit(state + 1);
  }

  loadStudentLesson(context) async {
    TeacherRepository teacherRepository =
        TeacherRepository.fromContext(context);

    var list = await teacherRepository.getStudentLessonInLesson(
        int.parse(TextUtils.getName(position: 2)),
        int.parse(TextUtils.getName()));

    listStudentLesson = [];
    listStudentLesson!.addAll(list);

    emit(state + 1);
  }
}
