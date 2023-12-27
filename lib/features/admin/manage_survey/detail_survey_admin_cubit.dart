import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/survey_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

class DetailSurveyAdminCubit extends Cubit<int>{
  DetailSurveyAdminCubit():super(0);

  int selector = -1;
  SurveyModel? surveyModel;
  int index = 0;

  load(int surveyId)async{
    surveyModel = await FireBaseProvider.instance.getSurveyById(surveyId);
    selector =
    surveyModel!.detail.isEmpty ? -1 : surveyModel!.detail.first["id"];
    emit(state+1);
  }

  select(int select) {
    selector = select;
    index = surveyModel!.detail
        .indexOf(surveyModel!.detail.firstWhere((e) => e["id"] == selector));
    emit(state + 1);
  }

}