import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/admin/manage_general/manage_general_cubit.dart';
import 'package:internal_sakumi/model/teacher_class_model.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/model/user_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/providers/firebase/firestore_db.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';


class AlertAddTeacherCubit extends Cubit<int> {
  AlertAddTeacherCubit() : super(0);

  int? userCount;
  List<TeacherClassModel>? listTeacherClass;
  List<TeacherModel>? listAllTeacher, listSensei, listSelectedTeacher = [];
  bool? checkCreate, checkAdd;

  loadAllUser(BuildContext context, ManageGeneralCubit cubit) async {
    listTeacherClass = await FireBaseProvider.instance.getAllTeacherInClass();
    listAllTeacher = await FireBaseProvider.instance.getAllTeacher();
    userCount = (await FireStoreDb.instance.getCount("user")).count;

    listSensei = [];
    for(var i in listAllTeacher!){
      var count = 0;
      for(var j in cubit.listTeacher!){
        if(i.userId != j.userId){
          count++;
        }
      }
      if(count == cubit.listTeacher!.length){
        listSensei!.add(i);
      }
    }
    emit(state + 1);
  }

  addTeacherToClass(BuildContext context, TeacherClassModel model) async {
    await FireBaseProvider.instance.addTeacherToClass(model);
    debugPrint('==============> addStudentToClass ${model.userId}');
  }

  createTeacher(
      BuildContext context, TeacherModel model, UserModel userModel) async {
    Navigator.pop(context);
    waitingDialog(context);
    checkCreate =
    await FireBaseProvider.instance.createNewTeacher(model, userModel);
  }
}
