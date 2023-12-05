import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/model/user_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

class SearchCubit extends Cubit<int>{
  SearchCubit():super(0){
    // load();
  }


  // load();
  String type = AppText.txtClass.text;


  List<ClassModel>? classes;
  List<StudentModel>? students;
  List<TeacherModel>? teachers;
  List<UserModel>? users;

  List<StudentModel> studentsNow = [];
  List<TeacherModel> teachersNow = [];
  List<ClassModel> classesNow = [];

  load() async{
    classes = await FireBaseProvider.instance.getListClassNotRemove();
    emit(state+1);
    users = await FireBaseProvider.instance.getAllUser();
    students = await FireBaseProvider.instance.getAllStudent();
    teachers = await FireBaseProvider.instance.getAllTeacher();
    emit(state+1);
  }

  search(String value){
    if(value == ""){
      studentsNow = [];
      teachersNow = [];
      classesNow = [];
      emit(state+1);
    }
    if(type == AppText.txtStudent.text){
      var studentIds = (users!.where((e) => e.email.toUpperCase().contains(value.toUpperCase())).toList()).map((e) => e.id).toList();
      studentsNow = students!.where((e) => studentIds.contains(e.userId) || e.studentCode.toUpperCase().contains(value.toUpperCase())).toList();
      emit(state+1);
    }
    if(type == AppText.txtTeacher.text){
      var teacherIds = (users!.where((e) => e.email.toUpperCase().contains(value.toUpperCase())).toList()).map((e) => e.id).toList();
      teachersNow = teachers!.where((e) => teacherIds.contains(e.userId) || e.teacherCode.toUpperCase().contains(value.toUpperCase())).toList();
      emit(state+1);
    }
    if(type == AppText.txtClass.text){
      var classIds = (classes!.where((e) => e.classCode.toUpperCase().contains(value.toUpperCase())).toList()).map((e) => e.classId).toList();
      classesNow = classes!.where((e) => classIds.contains(e.classId)).toList();
      emit(state+1);
    }
  }


  changeType(String? value){
    type = value!;
    emit(state+1);
  }
}