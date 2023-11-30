import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/model/user_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

class TeacherInfoCubit extends Cubit<int>{
  TeacherInfoCubit():super(0);

  TeacherModel? teacher;
  UserModel? user;

  String name = "";
  String teacherCode = "";
  String phone = "";
  String note = "";



  loadStudent(int teacherId) async{
    teacher = await FireBaseProvider.instance.getTeacherById(teacherId);
    user = await FireBaseProvider.instance.getUserById(teacherId);
    name = teacher!.name;
    teacherCode = teacher!.teacherCode;
    phone = teacher!.phone;
    note = teacher!.note;
    emit(state+1);
  }

  changeNote(String newValue){
    note = newValue;
    emit(state+1);
  }

  changePhone(String newValue){
    phone = newValue;
    emit(state+1);
  }

  changeTeacherCode(String newValue){
    teacherCode = newValue;
    emit(state+1);
  }

  changeName(String newValue){
    name = newValue;
    emit(state+1);
  }

}