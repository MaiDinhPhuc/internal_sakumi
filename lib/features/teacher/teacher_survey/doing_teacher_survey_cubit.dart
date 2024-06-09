import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/prefKey_configs.dart';
import 'package:internal_sakumi/model/survey_model.dart';
import 'package:internal_sakumi/model/teacher_survey_answer_model.dart';
import 'package:internal_sakumi/model/teacher_survey_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoingTeacherSurveyCubit extends Cubit<int>{
  DoingTeacherSurveyCubit():super(0);

  int selector = -1;
  SurveyModel? surveyModel;
  TeacherSurveyModel? teacherSurveyModel;
  int index = 0;
  TeacherSurveyAnswerModel? surveyAnswer;
  List<String> listVote = ["1","2","3","4","5"];

  load(int surveyId)async{
    SharedPreferences localData = await SharedPreferences.getInstance();
    var userId = localData.getInt(PrefKeyConfigs.userId);
    surveyModel = await FireBaseProvider.instance.getSurveyById(surveyId);
    selector = surveyModel!.detail.isEmpty ? -1 : surveyModel!.detail.first["id"];
    teacherSurveyModel = await FireBaseProvider.instance.getTeacherSurveyByTeacherAndSurveyId(userId!,surveyId);
    var detail = [];
    for(var i in surveyModel!.detail){
      detail.add({
        'answer' : [],
        'id': i['id']
      });
    }
    surveyAnswer = TeacherSurveyAnswerModel(teacherId: userId, surveyId: surveyId, id: DateTime.now().millisecondsSinceEpoch, detail: detail, dateAssign: teacherSurveyModel!.dateAssign);
    emit(state+1);
  }

  select(int select) {
    selector = select;
    index = surveyModel!.detail
        .indexOf(surveyModel!.detail.firstWhere((e) => e["id"] == selector));
    emit(state + 1);
  }

  checkChooseType12(String e){
    if(surveyAnswer!.detail[index]['answer'].contains(e)){
      return true;
    }
    return false;
  }

  checkDone(int index){
    if(surveyAnswer!.detail[index]['answer'].isEmpty){
      return false;
    }
    return true;
  }

  checkVote(String value){
    if(surveyAnswer!.detail[index]['answer'].isEmpty){
      return false;
    }else{
      if(int.parse(surveyAnswer!.detail[index]['answer'].first) < int.parse(value)){
        return false;
      }
    }

    return true;
  }

  String getTextType3(int type){
    if(type != 3) return "";
    if(surveyAnswer!.detail[index]['answer'].isEmpty){
      return "";
    }
    return surveyAnswer!.detail[index]['answer'].first;
  }

  chooseAnswerType12(int type , String answer){
    if(type == 1){
      surveyAnswer!.detail[index]['answer'] = [answer];
    }
    if(type == 2){
      if(checkChooseType12(answer)){
        surveyAnswer!.detail[index]['answer'].remove(answer);
      }else{
        surveyAnswer!.detail[index]['answer'].add(answer);
      }
    }
    emit(state+1);
  }

  inputAnswerType3(String value){
    surveyAnswer!.detail[index]['answer'] = [value];
  }

  chooseAnswerType4(String value){
    surveyAnswer!.detail[index]['answer'] = [value];
    emit(state+1);
  }
}