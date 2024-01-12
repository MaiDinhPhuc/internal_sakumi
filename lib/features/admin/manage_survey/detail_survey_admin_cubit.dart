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
      if(i.detail[index]["answer"] != []){
        x++;
      }
    }
    return x == 0 ? 1 : x;
  }

  int getNumberAnswerByAnswerId(int id, String answer){
    int x = 0;
    for(var i in listSurveyAnswer!){
      if(i.detail[index]["id"] == id && i.detail[index]["answer"].contains(answer)){
        x++;
      }
    }
    return x;
  }

  int getNumberAnotherAnswerByAnswerId(int id){
    int x = 0;
    List<dynamic> listAnswer = surveyModel!.detail[index]['answer'].map((e)=>e.toString()).toList();
    for(var i in listSurveyAnswer!){
      List<dynamic> listSurveyAnswer = i.detail[index]["answer"].map((e)=>e.toString()).toList();
      if(i.detail[index]["id"] == id && !listSurveyAnswer.every((element) => listAnswer.contains(element))){
        x++;
      }
    }
    return x;
  }

  String getAnswerInput(int id){
    var answer = listSurveyAnswer!.firstWhere((e) => e.detail[index]["id"] == id);
    return answer.detail[index]["answer"].first;
  }

  List<dynamic> getInfo(int id,String answer){

    var listInfo = [];

    for(var i in listSurveyAnswer!){
      if(i.detail[index]["id"] == id && i.detail[index]["answer"].contains(answer)){
        listInfo.add({"name": i.studentName,"avt" :i.studentAvt});
      }
    }

    return listInfo;
  }

  List<dynamic> getInfoWithAnotherAnswer(int id){

    var listInfo = [];

    List<dynamic> listAnswer = surveyModel!.detail[index]['answer'].map((e)=>e.toString()).toList();

    for(var i in listSurveyAnswer!){
      List<dynamic> listSurveyAnswer = i.detail[index]["answer"].map((e)=>e.toString()).toList();
      if(i.detail[index]["id"] == id && !listSurveyAnswer.every((element) => listAnswer.contains(element))){
        var answer = listSurveyAnswer.firstWhere((e) => !listAnswer.contains(e)).toString();
        listInfo.add({"name": i.studentName,"avt" :i.studentAvt, "answer" : answer});
      }
    }

    return listInfo;
  }
}

