import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/prefKey_configs.dart';
import 'package:internal_sakumi/model/survey_model.dart';
import 'package:internal_sakumi/utils/text_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManageSurveyCubit extends Cubit<int>{
  ManageSurveyCubit():super(0);

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

    if(int.tryParse(TextUtils.getName()) != null) return;

    if (role == 'teacher' || role == "admin") return;

    if (role == 'master') {
      getDataFromFirebase();
    }
  }

  getDataFromFirebase(){
    listSurvey = [];
    emit(state+1);
  }

}