import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/admin/manage_general/manage_general_cubit.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/model/user_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

class AlertAddStudentCubit extends Cubit<int> {
  AlertAddStudentCubit() : super(0);

  List<UserModel>? allUser;
  List<StudentClassModel>? listStudentClass;
  List<StudentModel>? listAllStudent, listStd, listSelectedStudent = [];
  bool? checkCreate, checkAdd;
  bool active = false;

  loadAllUser(BuildContext context, ManageGeneralCubit cubit) async {
    listStudentClass = await FireBaseProvider.instance.getAllStudentInClass();
    listAllStudent = await FireBaseProvider.instance.getAllStudent();
    allUser = await FireBaseProvider.instance.getAllUser();

    listStd = [];
    for(var i in listAllStudent!){
     var count = 0;
      for(var j in cubit.listStudent!){
        if(i.userId != j.userId){
          count++;
        }
      }
      if(count == cubit.listStudent!.length){
        listStd!.add(i);
      }
    }
    debugPrint('============> loadAllUser 3 ${listStd!.length}');
    emit(state + 1);
  }

  isInJapan() {
    active = !active;
    emit(state + 1);
  }

  addStudentToClass(BuildContext context, StudentClassModel model) async {
    await FireBaseProvider.instance.addStudentToClass(model);
    debugPrint('==============> addStudentToClass ${model.userId}');
  }

  createStudent(
      BuildContext context, StudentModel model, UserModel userModel) async {
    Navigator.pop(context);
    waitingDialog(context);
    checkCreate =
        await FireBaseProvider.instance.createNewStudent(model, userModel);
  }
}
