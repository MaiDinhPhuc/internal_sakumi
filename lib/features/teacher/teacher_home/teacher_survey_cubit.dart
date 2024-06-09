import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/prefKey_configs.dart';
import 'package:internal_sakumi/model/teacher_survey_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeacherSurveyCubit extends Cubit<int>{
  TeacherSurveyCubit():super(0){
    loadData();
  }

  List<TeacherSurveyModel>? listTeacherSurvey;
  int count = 0;

  loadData()async{
    if(listTeacherSurvey == null){
      SharedPreferences localData = await SharedPreferences.getInstance();
      int userId = localData.getInt(PrefKeyConfigs.userId)!;
      listTeacherSurvey = await FireBaseProvider.instance.getTeacherSurveyByTeacherId(userId);
      count = listTeacherSurvey!.length;
      emit(state+1);
    }
  }

}