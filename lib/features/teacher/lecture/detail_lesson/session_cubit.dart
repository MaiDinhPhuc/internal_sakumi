import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/prefKey_configs.dart';
import 'package:internal_sakumi/features/teacher/cubit/teacher_data_cubit.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/home_teacher/class_model2.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
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

  load(ClassModel2 classModel, DataCubit dataCubit) async {
    await getTeacherId();
    debugPrint('===============> init session $teacherId');
    totalAttendance = 0;
    if(classModel.stdClasses == null){
      dataCubit.loadLessonInfoOfClass(classModel.classModel);
      emit(state+1);
    }else{
      listStudentClass = classModel.stdClasses;
      List<int> listStudentId = [];
      for (var i in listStudentClass!) {
        if (i.classStatus != "Remove" &&
            i.classStatus != "Dropped" &&
            i.classStatus != "Deposit" &&
            i.classStatus != "Retained" &&
            i.classStatus != "Moved") {
          listStudentId.add(i.userId);
        }
      }
      listStudent = await FireBaseProvider.instance.getAllStudentInFoInClass(listStudentId);
      listStudentLesson = classModel.stdLessons!.where((e) => e.lessonId == int.parse(TextUtils.getName())).toList();
      totalAttendance = listStudentLesson!
          .fold(0, (pre, e) => e.timekeeping > 0 ? (pre + 1) : pre);
      emit(state+1);
    }
  }

  updateUI() {
    emit(state + 1);
  }

  getTeacherId() async {
    SharedPreferences localData = await SharedPreferences.getInstance();

    teacherId = int.parse(localData.getInt(PrefKeyConfigs.userId).toString());
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

  updateTimekeeping(int attendId) {
    debugPrint(
        '============> totalAttendance000 $totalAttendance -- $attendId');
    if (attendId > 0 && totalAttendance < listStudent!.length) {
      totalAttendance++;
    }
    if (attendId <= 0 && totalAttendance > 0) {
      totalAttendance--;
    }

    debugPrint(
        '============> totalAttendance1111 $totalAttendance -- $attendId');
    emit(state + 1);
  }
}
