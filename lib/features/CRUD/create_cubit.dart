import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/student_class_log.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/model/user_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

class CreateCubit extends Cubit<int>{
  CreateCubit(): super(0);


  createSingleSchedule()async{

  }

  addStudentToClass(StudentClassModel model){
    FireBaseProvider.instance.addStudentToClass(model);
  }

  addNewLog(StudentClassLogModel stdClassLog){
    FireBaseProvider.instance.addNewLog(stdClassLog);
  }

  Future<bool> createNewStudent(StudentModel model, UserModel userModel)async{
    var result =  await FireBaseProvider.instance.createNewStudent(model, userModel);
    return result;
  }

  Future<bool> createNewClass(ClassModel model)async{
    var result = await FireBaseProvider.instance.createNewClass(model);
    return result;
  }

}