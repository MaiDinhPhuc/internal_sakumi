import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/admin/manage_general/manage_general_cubit.dart';
import 'package:internal_sakumi/firebase_service/auth_service.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/model/user_model.dart';
import 'package:internal_sakumi/repository/admin_repository.dart';
import 'package:internal_sakumi/repository/user_repository.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

class AlertNewStudentCubit extends Cubit<int> {
  AlertNewStudentCubit() : super(0);

  List<UserModel>? allUser;
  List<StudentClassModel>? listStudentClass;
  List<StudentModel>? listAllStudent, listStd, listSelectedStudent = [];
  bool? checkCreate, checkAdd;
  bool active = false;

  loadAllUser(BuildContext context, ManageGeneralCubit cubit) async {
    UserRepository userRepository = UserRepository.fromContext(context);
    AdminRepository adminRepository = AdminRepository.fromContext(context);
    listStudentClass = await adminRepository.getAllStudentInClass();
    listAllStudent = await adminRepository.getAllStudent();
    allUser = await userRepository.getAllUser();

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
    AdminRepository adminRepository = AdminRepository.fromContext(context);
    //Navigator.pop(context);
    //waitingDialog(context);
    //checkAdd =
    await adminRepository.addStudentToClass(model);
  }

  createStudent(
      BuildContext context, StudentModel model, UserModel userModel) async {
    UserRepository userRepository = UserRepository.fromContext(context);
    Navigator.pop(context);
    waitingDialog(context);
    checkCreate =
        await userRepository.createNewStudent(context, model, userModel);
  }
}
