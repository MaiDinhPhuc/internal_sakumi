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

class AttendanceCubit extends Cubit<int> {
  AttendanceCubit() : super(0);

  List<StudentModel>? listStudent;
  List<StudentLessonModel>? listStudentLesson;
  List<StudentClassModel>? listStudentClass;
  //bool isShow = false;

  init(context) async {
    await loadStudentInClass(context);
    await loadStudentLesson(context);
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

    var list = await teacherRepository.getAllStudentLessonInLesson(
        int.parse(TextUtils.getName(position: 2)),
        int.parse(TextUtils.getName()));

    //isShow = list.fold(true, (pre, e) => pre && (e.timekeeping > 0));

    listStudentLesson = [];
    listStudentLesson!.addAll(list);

    emit(state + 1);
  }
}
