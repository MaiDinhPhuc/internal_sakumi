import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';

class SearchCubit extends Cubit<int>{
  SearchCubit():super(0);

  String type = AppText.txtClass.text;

  String typeQuery = "class";

  String searchValue = "";

  changeType(String? value)async{
    type = value!;
    if(value == AppText.txtClass.text){
      typeQuery = "class";
    }
    if(value == AppText.txtStudent.text){
      typeQuery = "students";
    }
    if(value == AppText.txtTeacher.text){
      typeQuery = "teacher";
    }
    emit(state+1);
  }

  updateSearchValue(String newValue){
    searchValue = newValue;
    emit(state+1);
  }
}