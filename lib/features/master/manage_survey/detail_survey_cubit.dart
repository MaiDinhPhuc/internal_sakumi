import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/survey_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

import 'manage_survey_cubit.dart';

class DetailSurveyCubit extends Cubit<int> {
  DetailSurveyCubit() : super(0);

  SurveyModel? surveyModel;

  int selector = -1;
  int index = 0;

  loadSurvey(int id, ManageSurveyCubit surveyCubit) {
    if (surveyCubit.listSurvey == null) {
      surveyCubit.loadSurvey();
    } else {
      var temp = surveyCubit.listSurvey!.where((e) => e.id == id).toList();
      surveyModel = temp.first;
      selector =
          surveyModel!.detail.isEmpty ? -1 : surveyModel!.detail.first["id"];
      emit(state + 1);
    }
  }

  select(int select) {
    selector = select;
    index = surveyModel!.detail
        .indexOf(surveyModel!.detail.firstWhere((e) => e["id"] == selector));
    emit(state + 1);
  }

  changeActive() async {
    surveyModel = SurveyModel(
        surveyCode: surveyModel!.surveyCode,
        title: surveyModel!.title,
        description: surveyModel!.description,
        id: surveyModel!.id,
        detail: surveyModel!.detail,
        enable: surveyModel!.enable,
        active: true);
    await FireBaseProvider.instance.activeSurvey(surveyModel!.id);
    emit(state + 1);
  }

  save() async {
    await FireBaseProvider.instance.saveSurvey(surveyModel!.id, surveyModel!);
    emit(state + 1);
  }

  addNewQuestion() {
    int millisecondsSinceEpoch = DateTime.now().millisecondsSinceEpoch;
    Map question = {
      "id": millisecondsSinceEpoch,
      "type": 1,
      "question": "",
      "answer": [],
      "force": false,
      "another": false,
      "option": []
    };
    List<dynamic> list = surveyModel!.detail;
    list.add(question);
    surveyModel!.copyWith(detail: list);
    selector = millisecondsSinceEpoch;
    index = surveyModel!.detail
        .indexOf(surveyModel!.detail.firstWhere((e) => e["id"] == selector));
    emit(state + 1);
  }

  deleteQuestion(int number) {
    Map question = surveyModel!.detail.firstWhere((e) => e["id"] == number);
    List<dynamic> list = surveyModel!.detail;
    list.remove(question);
    surveyModel!.copyWith(detail: list);
    if (number == selector) {
      selector = -1;
    }
    emit(state + 1);
  }
}
