import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/survey_model.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/model/teacher_survey_answer_model.dart';
import 'package:internal_sakumi/providers/cache/cached_data_provider.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

class DetailAnswerTeacherSurveyCubit extends Cubit<int>{
  DetailAnswerTeacherSurveyCubit():super(0);

  TeacherModel? teacher;
  TeacherSurveyAnswerModel? surveyAnswer;
  SurveyModel? surveyModel;
  int selector = -1;
  List<String> listVote = ["1","2","3","4","5"];
  int index = 0;


  load(int surveyId, int teacherId, int date)async{
    await DataProvider.teacherById(teacherId, loadTeacherInfo);
    surveyModel = await FireBaseProvider.instance.getSurveyById(surveyId);
    selector = surveyModel!.detail.first['id'];
    surveyAnswer = await FireBaseProvider.instance.getTeacherSurveyAnswerByTeacherAndSurveyId(teacherId, surveyId, date);
    emit(state+1);
  }
  loadTeacherInfo(Object student) {
    teacher = student as TeacherModel;
  }

  checkDone(int index){
    if(surveyAnswer!.detail[index]['answer'].isEmpty){
      return false;
    }
    return true;
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
}