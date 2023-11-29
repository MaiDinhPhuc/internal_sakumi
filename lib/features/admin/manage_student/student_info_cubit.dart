import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/model/user_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

class StudentInfoCubit extends Cubit<int>{
  StudentInfoCubit():super(0);

  StudentModel? student;
  UserModel? user;

  bool inJapan = false;
  String name = "";
  String stdCode = "";
  String phone = "";
  String note = "";
  loadStudent(int studentId) async{
    student = await FireBaseProvider.instance.getStudentById(studentId);
    user = await FireBaseProvider.instance.getUserById(studentId);
    inJapan = student!.inJapan;
    name = student!.name;
    stdCode = student!.studentCode;
    phone = student!.phone;
    note = student!.note;
    emit(state+1);
  }

  resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: user!.email);
      print('Password reset email sent successfully.');
    } catch (e) {
      print('Error sending password reset email: $e');
    }
  }

  updateCheck(){
    inJapan = !inJapan;
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

  changeStdCode(String newValue){
    stdCode = newValue;
    emit(state+1);
  }

  changeName(String newValue){
    name = newValue;
    emit(state+1);
  }

}