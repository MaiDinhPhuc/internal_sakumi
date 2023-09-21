import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/model/user_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

class EditStudentProfileCubit extends Cubit<int>{
  EditStudentProfileCubit(): super(0);

  String email = "";
  String name = "";
  String phone = "";
  String studentCode = "";
  String note = "";
  bool active = false;
  UserModel? userModel;
  bool changed = false;

  init(context, StudentModel studentModel)async{
    name = studentModel.name;
    phone = studentModel.phone;
    studentCode = studentModel.studentCode;
    note = studentModel.note;
    userModel = await FireBaseProvider.instance.getUserById(studentModel.userId);
    email = userModel!.email;
    emit(state+1);
  }

  bool checkChange(StudentModel student){
    if(phone == student.phone && name == student.name && studentCode == student.studentCode && note == student.note && active == student.inJapan){
      return false;
    }
    return true;
  }

  isInJapan() {
    active = !active;
    emit(state + 1);
  }

}

class UpdateCubit extends Cubit<bool>{
  UpdateCubit():super(false);
  bool changed = false;
  update(EditStudentProfileCubit cubit, StudentModel student){
    emit(cubit.checkChange(student));
  }
}