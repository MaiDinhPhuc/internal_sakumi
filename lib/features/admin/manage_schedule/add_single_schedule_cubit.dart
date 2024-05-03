import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddSingleScheduleCubit extends Cubit<int>{
  AddSingleScheduleCubit(): super(0);
  int? teacherId;
  TextEditingController teacherSearch = TextEditingController();
  String teacherSearchValue = "";
  chooseTeacher(String teacher, int userId) {
    teacherId = userId;
    teacherSearch.text = teacher;
    emit(state + 1);
  }
  searchTeacher(String newValue) {
    teacherSearchValue = newValue;
    emit(state + 1);
  }

  deleteTeacher() {
    teacherId = null;
    teacherSearch.text = "";
    teacherSearchValue = "";
    emit(state + 1);
  }
}