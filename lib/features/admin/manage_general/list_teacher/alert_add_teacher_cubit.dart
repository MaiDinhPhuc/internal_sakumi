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
  int? teacherClassCount;
  List<TeacherModel>? listAllTeacher, listSensei, listSelectedTeacher = [];
  bool? checkCreate, checkAdd;

  loadAllUser(BuildContext context, ManageGeneralCubit cubit) async {
    teacherClassCount = (await FireStoreDb.instance.getCount("teacher_class")).count;
    listAllTeacher = await FireBaseProvider.instance.getAllTeacher();
    userCount = (await FireStoreDb.instance.getCount("users")).count;
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
  search(String text, ManageGeneralCubit cubit){
    if(text!=""){
      listSensei = [];
      for(var i in listAllTeacher!){
        var count = 0;
        for(var j in cubit.listStudent!){
          if(i.userId != j.userId){
            count++;
          }
        }
        if(count == cubit.listStudent!.length){
          listSensei!.add(i);
        }
      }
      List<TeacherModel> listTemp = [];
      for(var i in listSensei!){
        if(i.name.toUpperCase().contains(text.toUpperCase()) || i.teacherCode.toUpperCase().contains(text.toUpperCase())){
          listTemp.add(i);
        }
      }
      listSensei = null;
      listSensei = listTemp;
      emit(state + 1);
    }else{
      listSensei = [];
      for(var i in listAllTeacher!){
        var count = 0;
        for(var j in cubit.listStudent!){
          if(i.userId != j.userId){
            count++;
          }
        }
        if(count == cubit.listStudent!.length){
          listSensei!.add(i);
        }
      }
      emit(state + 1);
    }
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
