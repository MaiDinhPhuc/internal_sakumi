import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/CRUD/create.dart';
import 'package:internal_sakumi/features/admin/manage_general/manage_general_cubit.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/student_class_log.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/model/user_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';


class AlertAddStudentCubit extends Cubit<int> {
  AlertAddStudentCubit() : super(0);

  List<StudentModel>? listAllStudent, listStd, listSelectedStudent = [];
  bool? checkCreate, checkAdd;
  bool active = false;
  ClassModel? classModel;
  final TextEditingController searchTextController = TextEditingController();
  loadAllUser(ManageGeneralCubit cubit) async {
    listAllStudent = await FireBaseProvider.instance.getAllStudent();
    listStd = [];
    for (var i in listAllStudent!) {
      var count = 0;
      for (var j in cubit.listStudent!) {
        if (i.userId != j.userId) {
          count++;
        }
      }
      if (count == cubit.listStudent!.length) {
        listStd!.add(i);
      }
    }
    emit(state + 1);
  }

  search(String text, ManageGeneralCubit cubit) {
    if (text != "") {
      listStd = [];
      for (var i in listAllStudent!) {
        var count = 0;
        for (var j in cubit.listStudent!) {
          if (i.userId != j.userId) {
            count++;
          }
        }
        if (count == cubit.listStudent!.length) {
          listStd!.add(i);
        }
      }
      List<StudentModel> listTemp = [];
      for (var i in listStd!) {
        if (i.name.toUpperCase().contains(text.toUpperCase()) ||
            i.studentCode.toUpperCase().contains(text.toUpperCase()) ||  i.email.toUpperCase().contains(text.toUpperCase())) {
          listTemp.add(i);
        }
      }
      listStd = null;
      listStd = listTemp;
      emit(state + 1);
    } else {
      listStd = [];
      for (var i in listAllStudent!) {
        var count = 0;
        for (var j in cubit.listStudent!) {
          if (i.userId != j.userId) {
            count++;
          }
        }
        if (count == cubit.listStudent!.length) {
          listStd!.add(i);
        }
      }
      emit(state + 1);
    }
  }

  isInJapan() {
    active = !active;
    emit(state + 1);
  }

  addStudentToClass( StudentClassModel model) async {
    //FireBaseProvider.instance.addStudentToClass(model);

    Create.addStudentToClass(model);

    classModel ??= await FireBaseProvider.instance.getClassById(model.classId);

    StudentClassLogModel stdClassLog = StudentClassLogModel(
        id: DateTime.now().millisecondsSinceEpoch,
        classId: model.classId,
        courseId: classModel!.courseId,
        from: 'none',
        to: model.classStatus,
        userId: model.userId,
        classType: classModel!.classType);

    Create.addNewLog(stdClassLog);
  }

  createStudent( StudentModel model, UserModel userModel) async {
    checkCreate = await Create.createNewStudent(model, userModel);
  }
}
