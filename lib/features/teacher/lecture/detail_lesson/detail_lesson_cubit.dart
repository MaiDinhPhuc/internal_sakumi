import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/prefKey_configs.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/repository/teacher_repository.dart';
import 'package:internal_sakumi/utils/text_utils.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DropdownCubit extends Cubit<int> {
  DropdownCubit() : super(0);

  update() {
    emit(state + 1);
  }
}

class DetailLessonCubit extends Cubit<LessonResultModel?> {
  DetailLessonCubit() : super(null);

  String? title;
  bool? check;
  int? teacherId;

  checkLessonResult(context) async {
    TeacherRepository teacherRepository =
        TeacherRepository.fromContext(context);

    SharedPreferences localData = await SharedPreferences.getInstance();
    teacherId = int.parse(localData.getInt(PrefKeyConfigs.userId).toString());
    var classModel = await teacherRepository
        .getClass(int.parse(TextUtils.getName(position: 2)));
    var lessonModel = await teacherRepository.getLesson(
        classModel.courseId, int.parse(TextUtils.getName()));
    title = lessonModel.title;

    check = await teacherRepository.checkLessonResult(int.parse(TextUtils.getName()), int.parse(
        TextUtils.getName(position: 2)));

    debugPrint('=============> addLessonResult $check');
    if(check == false) {
      emit(
        LessonResultModel(
            id: 1000,
            classId: int.parse(TextUtils.getName(position: 2)),
            lessonId: int.parse(TextUtils.getName()),
            teacherId: teacherId!,
            status: 'Pending',
            date: DateFormat('dd/MM/yyyy').format(DateTime.now()),
            noteForStudent: '',
            noteForSupport: '',
            noteForTeacher: '')
    );
    }

    if(check == true){
      emit(await teacherRepository.getLessonResultByLessonId(
          int.parse(TextUtils.getName()),
          int.parse(TextUtils.getName(position: 2))));
    }
  }

  addLessonResult(context, LessonResultModel model)async{
    TeacherRepository teacherRepository =
    TeacherRepository.fromContext(context);

    await teacherRepository.addLessonResult(model);

    emit(model);
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
  }

  noteForStudents(context, String note) async {
    TeacherRepository teacherRepository =
        TeacherRepository.fromContext(context);

    await teacherRepository.noteForAllStudentInClass(
        int.parse(TextUtils.getName()),
        int.parse(TextUtils.getName(position: 2)),
        note);
    await teacherRepository.updateTeacherInLessonResult(
        int.parse(TextUtils.getName()),
        int.parse(TextUtils.getName(position: 2)),teacherId!
        );
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

  noteForSupport(context, String note) async {
    TeacherRepository teacherRepository =
    TeacherRepository.fromContext(context);

    await teacherRepository.noteForSupport(
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
        noteForStudent: state!.noteForStudent,
        noteForSupport: note,
        noteForTeacher: state!.noteForTeacher));
  }

  noteForAnotherSensei(context, String note) async {
    TeacherRepository teacherRepository =
    TeacherRepository.fromContext(context);

    await teacherRepository.noteForAnotherSensei(
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
        noteForStudent: state!.noteForStudent,
        noteForSupport: state!.noteForSupport,
        noteForTeacher: note));
  }
}
