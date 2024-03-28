import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/admin/manage_general/manage_general_cubit.dart';
import 'package:internal_sakumi/model/student_class_log.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/model/user_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/providers/firebase/firestore_db.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

class AlertAddStudentCubit extends Cubit<int> {
  AlertAddStudentCubit() : super(0);

  List<StudentModel>? listAllStudent, listStd, listSelectedStudent = [];
  bool? checkCreate, checkAdd;
  bool active = false;
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
            i.studentCode.toUpperCase().contains(text.toUpperCase())) {
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

  addStudentToClass(BuildContext context, StudentClassModel model) async {
    await FireBaseProvider.instance.addStudentToClass(model);
    var classModel =
        await FireBaseProvider.instance.getClassById(model.classId);
    await FireBaseProvider.instance.addNewLog(StudentClassLogModel(
        id: DateTime.now().millisecondsSinceEpoch,
        classId: model.classId,
        courseId: classModel.courseId,
        from: 'none',
        to: model.classStatus,
        userId: model.userId,
        classType: classModel.classType));
  }

  createStudent(StudentModel model, UserModel userModel) async {
    checkCreate =
        await FireBaseProvider.instance.createNewStudent(model, userModel);
  }
}
