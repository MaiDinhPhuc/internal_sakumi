import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/survey_answer_model.dart';
import 'package:internal_sakumi/model/survey_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

class DetailSurveyAdminCubit extends Cubit<int>{
  DetailSurveyAdminCubit():super(0);

  int selector = -1;
  SurveyModel? surveyModel;
  int index = 0;
  List<SurveyAnswerModel>? listSurveyAnswer;
  List<StudentClassModel>? stdClasses;

  load(int surveyId, int classId)async{
    surveyModel = await FireBaseProvider.instance.getSurveyById(surveyId);
    selector =
    surveyModel!.detail.isEmpty ? -1 : surveyModel!.detail.first["id"];
    listSurveyAnswer = await FireBaseProvider.instance.getSurveyAnswerByClassId(classId, surveyId);
    stdClasses = (await FireBaseProvider.instance.getStudentClassInClass(classId)).where((e) => !["Remove","Dropped","Deposit","Moved"].contains(e.classStatus)).toList();
    emit(state+1);
  }

  select(int select) {
    selector = select;
    index = surveyModel!.detail
        .indexOf(surveyModel!.detail.firstWhere((e) => e["id"] == selector));
    emit(state + 1);
  }

  int getNumberAnswer(){
    int x = 0;
    for(var i in listSurveyAnswer!){
      if(i.detail[index]["answer"] != ""){
        x++;
      }
    }
    return x == 0 ? 1 : x;
  }

  int getNumberAnswerByAnswerId(int id, String answer){
    int x = 0;
    for(var i in listSurveyAnswer!){
      if(i.detail[index]["id"] == id && i.detail[index]["answer"] == answer){
        x++;
      }
    }
    return x;
  }

  String getAnswerInput(int id){
    var answer = listSurveyAnswer!.firstWhere((e) => e.detail[index]["id"] == id);
    return answer.detail[index]["answer"];
  }

  List<dynamic> getInfo(int id,String answer){

    var listInfo = [];

    for(var i in listSurveyAnswer!){
      if(i.detail[index]["id"] == id && i.detail[index]["answer"] == answer){
        listInfo.add({"name": i.studentName,"avt" :i.studentAvt});
      }
    }

    return listInfo;
  }
}

