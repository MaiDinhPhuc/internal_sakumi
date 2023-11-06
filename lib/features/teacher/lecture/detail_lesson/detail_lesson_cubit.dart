import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/prefKey_configs.dart';
import 'package:internal_sakumi/features/teacher/cubit/teacher_data_cubit.dart';
import 'package:internal_sakumi/model/home_teacher/class_model2.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
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

  checkLessonResult(ClassModel2 model, DataCubit dataCubit) async {
    if(model.lessonResults == null){
      dataCubit.loadLessonInfoOfClass(model.classModel);
    }else{
      SharedPreferences localData = await SharedPreferences.getInstance();
      teacherId = int.parse(localData.getInt(PrefKeyConfigs.userId).toString());

      var lessonModel = model.listLesson!.firstWhere((e) => e.lessonId ==  int.parse(TextUtils.getName()));
      title = lessonModel.title;

      check = model.lessonResults!.any((e) => e.lessonId == int.parse(TextUtils.getName()));


      debugPrint('=============> addLessonResult $check');
      if(check == false) {
        emit(
            LessonResultModel(
                id: 1000,
                classId: int.parse(TextUtils.getName(position: 1)),
                lessonId: int.parse(TextUtils.getName()),
                teacherId: teacherId!,
                status: 'Pending',
                date: DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now()),
                noteForStudent: '',
                noteForSupport: '',
                noteForTeacher: '')
        );
      }
      if(check == true){
        var lessonResult = model.lessonResults!.firstWhere((e) => e.lessonId == int.parse(TextUtils.getName()));
        emit(lessonResult);
      }
    }
  }

  addLessonResult(LessonResultModel model)async{

    await FireBaseProvider.instance.addLessonResult(model);

    emit(model);
  }

  updateStatus(String status, DataCubit dataCubit) async {
    await FireBaseProvider.instance.changeStatusLesson(int.parse(TextUtils.getName()),
        int.parse(TextUtils.getName(position: 1)), status);
    dataCubit.updateLessonResults(int.parse(TextUtils.getName(position: 1)), LessonResultModel(
        id: state!.id,
        classId: state!.classId,
        lessonId: state!.lessonId,
        teacherId: state!.teacherId,
        status: status,
        date: state!.date,
        noteForStudent: state!.noteForStudent,
        noteForSupport: state!.noteForSupport,
        noteForTeacher: state!.noteForTeacher));
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

  noteForStudents(String note, DataCubit dataCubit) async {
    await FireBaseProvider.instance.noteForAllStudentInClass(
        int.parse(TextUtils.getName()),
        int.parse(TextUtils.getName(position: 1)),
        note);
    await FireBaseProvider.instance.updateTeacherInLessonResult(
        int.parse(TextUtils.getName()),
        int.parse(TextUtils.getName(position: 1)),teacherId!
        );
    dataCubit.updateLessonResults(int.parse(TextUtils.getName(position: 1)), LessonResultModel(
        id: state!.id,
        classId: state!.classId,
        lessonId: state!.lessonId,
        teacherId: teacherId!,
        status: state!.status,
        date: state!.date,
        noteForStudent: note,
        noteForSupport: state!.noteForSupport,
        noteForTeacher: state!.noteForTeacher));
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

  noteForSupport(String note, DataCubit dataCubit) async {
    await FireBaseProvider.instance.noteForSupport(
        int.parse(TextUtils.getName()),
        int.parse(TextUtils.getName(position: 1)),
        note);
    dataCubit.updateLessonResults(int.parse(TextUtils.getName(position: 1)), LessonResultModel(
        id: state!.id,
        classId: state!.classId,
        lessonId: state!.lessonId,
        teacherId: state!.teacherId,
        status: state!.status,
        date: state!.date,
        noteForStudent: state!.noteForStudent,
        noteForSupport: note,
        noteForTeacher: state!.noteForTeacher));
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

  noteForAnotherSensei(String note, DataCubit dataCubit) async {

    await FireBaseProvider.instance.noteForAnotherSensei(
        int.parse(TextUtils.getName()),
        int.parse(TextUtils.getName(position: 1)),
        note);
    dataCubit.updateLessonResults(int.parse(TextUtils.getName(position: 1)), LessonResultModel(
        id: state!.id,
        classId: state!.classId,
        lessonId: state!.lessonId,
        teacherId: state!.teacherId,
        status: state!.status,
        date: state!.date,
        noteForStudent: state!.noteForStudent,
        noteForSupport: state!.noteForSupport,
        noteForTeacher: note));
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
