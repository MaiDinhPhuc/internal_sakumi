import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/model/survey_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

import 'manage_survey_cubit.dart';

class DetailSurveyCubit extends Cubit<int> {
  DetailSurveyCubit() : super(0);

  SurveyModel? surveyModel;

  int selector = -1;
  int index = 0;

  List<TextEditingController> quesCon = [];

  List<List<TextEditingController>> answerCon = [];

  loadSurvey(int id, ManageSurveyCubit surveyCubit) {
    if (surveyCubit.listSurvey == null) {
      surveyCubit.loadSurvey();
    } else {
      var temp = surveyCubit.listSurvey!.where((e) => e.id == id).toList();
      surveyModel = temp.first;
      if (surveyModel!.detail.isNotEmpty) {
        for (var i in surveyModel!.detail) {
          var newQuesCon = TextEditingController(text: i["question"]);
          quesCon.add(newQuesCon);
          List<TextEditingController> listAns = [];
          for (var j in i["answer"]) {
            var newAnsCon = TextEditingController(text: j);
            listAns.add(newAnsCon);
          }
          answerCon.add(listAns);
        }
      }
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

  String convertType(int type) {
    if (type == 1) return AppText.txtSurveyType1.text;
    if (type == 2) return AppText.txtSurveyType2.text;
    if (type == 3) return AppText.txtSurveyType3.text;
    if (type == 4) return AppText.txtSurveyType4.text;
    return "";
  }

  changeAnswer() {
    List<String> answerList = [];
    for (var i in answerCon[index]) {
      answerList.add(i.text);
    }
    Map question = {
      "id": selector,
      "type": surveyModel!.detail[index]["type"],
      "question": surveyModel!.detail[index]["question"],
      "answer": answerList,
      "force": surveyModel!.detail[index]["force"],
      "another": surveyModel!.detail[index]["another"]
    };
    surveyModel!.detail[index] = question;
    emit(state + 1);
  }

  changeForce(bool value) {
    Map question = {
      "id": selector,
      "type": surveyModel!.detail[index]["type"],
      "question": surveyModel!.detail[index]["question"],
      "answer": surveyModel!.detail[index]["answer"],
      "force": value,
      "another": surveyModel!.detail[index]["another"]
    };
    surveyModel!.detail[index] = question;
    emit(state + 1);
  }

  changeAnother(bool value) {
    Map question = {
      "id": selector,
      "type": surveyModel!.detail[index]["type"],
      "question": surveyModel!.detail[index]["question"],
      "answer": surveyModel!.detail[index]["answer"],
      "force": surveyModel!.detail[index]["force"],
      "another": value
    };
    surveyModel!.detail[index] = question;
    emit(state + 1);
  }

  deleteAnswer(int index) {
    answerCon[this.index].remove(answerCon[this.index][index]);
    emit(state + 1);
  }

  changeQuestionType(String value) {
    var temp = (value == AppText.txtSurveyType1.text
        ? 1
        : value == AppText.txtSurveyType2.text
            ? 2
            : value == AppText.txtSurveyType3.text
                ? 3
                : 4);
    Map question = {
      "id": selector,
      "type": temp,
      "question": surveyModel!.detail[index]["question"],
      "answer": temp > 2  ? [] : surveyModel!.detail[index]["answer"],
      "force": surveyModel!.detail[index]["force"],
      "another": temp > 2 ? false : surveyModel!.detail[index]["another"]
    };
    if (temp > 2) {
      answerCon[index] = [];
    }
    surveyModel!.detail[index] = question;
    emit(state + 1);
  }

  changeQuestion() {
    Map question = {
      "id": selector,
      "type": surveyModel!.detail[index]["type"],
      "question": quesCon[index].text,
      "answer": surveyModel!.detail[index]["answer"],
      "force": surveyModel!.detail[index]["force"],
      "another": surveyModel!.detail[index]["another"]
    };
    surveyModel!.detail[index] = question;
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
      "another": false
    };
    List<dynamic> list = surveyModel!.detail;
    list.add(question);
    surveyModel!.copyWith(detail: list);
    selector = millisecondsSinceEpoch;
    var newQuesCon = TextEditingController();
    quesCon.add(newQuesCon);
    answerCon.add([]);
    index = surveyModel!.detail
        .indexOf(surveyModel!.detail.firstWhere((e) => e["id"] == selector));
    emit(state + 1);
  }

  addNewAnswer() {
    var newAnswerCon = TextEditingController();
    answerCon[index].add(newAnswerCon);
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
    quesCon.remove(quesCon[index]);
    answerCon.remove(answerCon[index]);
    emit(state + 1);
  }
}
