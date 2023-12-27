import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/survey_model.dart';
import 'package:internal_sakumi/model/survey_result_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

class AlertAddSurveyCubit extends Cubit<int> {
  AlertAddSurveyCubit() : super(0);

  List<SurveyModel>? listSurvey;

  List<SurveyModel> listSurveyCheck = [];

  loadSurvey(List<SurveyResultModel> listSurveyResult)async{
    if(listSurveyResult.isEmpty){
      listSurvey = await FireBaseProvider.instance.getSurveyEnable();
    }else{
      var listId = listSurveyResult.map((e) => e.surveyId).toList();
      listSurvey = (await FireBaseProvider.instance.getSurveyEnable()).where((e) => !listId.contains(e.id)).toList();
    }

    emit(state+1);
  }

  addSurveyResult(SurveyModel survey, int classId, int id) async{
    await FireBaseProvider.instance.addSurveyToClass(survey, classId, id);
  }

}