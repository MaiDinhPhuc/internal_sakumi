import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/repository/admin_repository.dart';

class ManageGeneralCubit extends Cubit<int> {
  ManageGeneralCubit() : super(-1);
  List<ClassModel>? listAllClass;
  List<TeacherModel>? listTeacher;
  List<StudentModel>? listStudent;
  int selector = 0;

  loadAllClass(context) async {
    AdminRepository adminRepository = AdminRepository.fromContext(context);
    listAllClass = await adminRepository.getListClass();
    emit(listAllClass!.first.classId);
    loadTeacherInClass(context, selector);
    loadStudentInClass(context, selector);
  }

  selectedClass(int index, context) {
    selector = index;
    emit(selector);
    loadTeacherInClass(context, index);
    loadStudentInClass(context, index);
  }

  loadTeacherInClass(BuildContext context, int selector)async{
    listTeacher = null;
    var adminRepo = AdminRepository.fromContext(context);
    var listAllTeacher = await adminRepo.getAllTeacher();
    var listAllTeacherInClass = await adminRepo.getAllTeacherInClassByClassId(selector);

    listTeacher = [];
    for(var i in listAllTeacher){
      for(var j in listAllTeacherInClass){
        if(i.userId == j.userId){
          listTeacher!.add(i);
        }
      }
    }
    emit(state+2);
  }

  loadStudentInClass(context, int selector)async{
    listStudent = null;

    var adminRepo = AdminRepository.fromContext(context);
    var listAllStudent = await adminRepo.getAllStudent();
    var listAllStudentInClass = await adminRepo.getStudentClassByClassId(selector);

    listStudent = [];
    for(var i in listAllStudent){
      for(var j in listAllStudentInClass){
        if(i.userId == j.userId){
          listStudent!.add(i);
        }
      }
    }
    debugPrint('============> loadStudentInClass ${listStudent!.length}');
    emit(state+2);
  }
}