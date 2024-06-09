import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/prefKey_configs.dart';
import 'package:internal_sakumi/features/CRUD/update.dart';
import 'package:internal_sakumi/model/survey_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManageTeacherSurveyCubit extends Cubit<int>{
  ManageTeacherSurveyCubit():super(0);

  int? userID;

  List<SurveyModel>? listSurvey;


  loadSurvey()async{
    SharedPreferences localData = await SharedPreferences.getInstance();
    var userId = localData.getInt(PrefKeyConfigs.userId);

    var role = localData.getString(PrefKeyConfigs.role);

    if (userId == null || userId == -1) return;

    if(userId != -1){
      userID = userId;
    }

    if(listSurvey != null) return;

    if (role == 'teacher' || role == "admin") return;

    if (role == 'master') {
      getDataFromFirebase();
    }
    debugPrint("==========>loadSurvey");
  }

  getDataFromFirebase()async{
    listSurvey = await FireBaseProvider.instance.getAllTeacherSurvey();
    emit(state+1);
  }

  addNewSurvey(SurveyModel surveyModel){
    listSurvey!.add(surveyModel);
    emit(state+1);
  }

  deleteSurvey(int id){
    listSurvey!.remove(listSurvey!.firstWhere((e) => e.id == id));
    emit(state+1);
  }

  updateSurvey(SurveyModel newSurvey){
    var index = listSurvey!.indexOf(listSurvey!.firstWhere((e) => e.id == newSurvey.id));
    listSurvey![index] = newSurvey;
  }

  updateActive(List<int> listId){
    for(var i in listId){
      var survey = listSurvey!.firstWhere((e) => e.id == i);
      if(survey.active == false){
        Update.activeSurvey(i);
        var index = listSurvey!.indexOf(survey);
        listSurvey![index] = survey.copyWith(active: true);
      }
    }
    emit(state+1);
  }
}