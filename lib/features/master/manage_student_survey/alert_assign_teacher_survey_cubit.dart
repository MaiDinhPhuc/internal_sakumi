import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/survey_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

class AlertAssignTeacherSurveyCubit extends Cubit<int>{
  AlertAssignTeacherSurveyCubit():super(0){
    loadSurvey();
  }

  String teacherSearchValue = "";
  TextEditingController teacherCon = TextEditingController();

  List<SurveyModel>? listSurvey;

  List<int> listSurveyId = [];
  List<int> listTeacherId = [];

  addTeacher(int teacherId){
    listTeacherId.add(teacherId);

  }

  removeTeacher(int teacherId){
    listTeacherId.remove(teacherId);

  }

  addSurvey(int surveyId){
    listSurveyId.add(surveyId);

  }

  removeSurvey(int surveyId){
    listSurveyId.remove(surveyId);

  }

  loadSurvey()async{
    listSurvey = await FireBaseProvider.instance.getAllTeacherSurvey();
    emit(state+1);
  }

  searchClass(String newValue) {
    teacherSearchValue = newValue;
    emit(state + 1);
  }

  bool checkTeacher(int teacherId){
    if(listTeacherId.contains(teacherId)) return true;
    return false;
  }

  bool checkSurvey(int surveyId){
    if(listSurveyId.contains(surveyId)) return true;
    return false;
  }

}

class CheckStateCubit extends Cubit<bool>{
  CheckStateCubit(state):super(state);

  change(){
    emit(!state);
  }
}