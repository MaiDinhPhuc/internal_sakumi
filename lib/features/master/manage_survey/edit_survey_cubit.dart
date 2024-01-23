import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';

import 'detail_survey_cubit.dart';

class EditSurveyCubit extends Cubit<int> {
  EditSurveyCubit(this.detailSurveyCubit) : super(0) {
    loadData();
  }
  TextEditingController? quesCon;

  List<TextEditingController> answerCon = [];

  final DetailSurveyCubit detailSurveyCubit;

  List<String> listQuestion = [];
  List<int> listQuestionId = [];
  List<int> listType = [];
  List<String> listAnswer = [];

  int optionId = -1;

  bool? force;
  bool? another;
  bool? option;

  loadData() {
    if (detailSurveyCubit.surveyModel!.detail.isNotEmpty) {
      quesCon = TextEditingController(
          text: detailSurveyCubit.surveyModel!.detail[detailSurveyCubit.index]
              ["question"]);
      for (var j in detailSurveyCubit
          .surveyModel!.detail[detailSurveyCubit.index]["answer"]) {
        var newAnsCon = TextEditingController(text: j);
        answerCon.add(newAnsCon);
      }
      force = detailSurveyCubit.surveyModel!.detail[detailSurveyCubit.index]
          ["force"];
      another = detailSurveyCubit.surveyModel!.detail[detailSurveyCubit.index]
          ["another"];
      List listOption = detailSurveyCubit
          .surveyModel!.detail[detailSurveyCubit.index]["option"];
      option = listOption.isNotEmpty;
      List<dynamic> listQuestion = detailSurveyCubit.surveyModel!.detail
          .where((e) => e["type"] == 1 || e["type"] == 4)
          .toList();
      for (var i in listQuestion) {
        if (i["id"] != detailSurveyCubit.selector) {
          if (i["question"] != "") {
            this.listQuestion.add(i["question"] as String);
            listQuestionId.add(i["id"] as int);
            listType.add(i["type"] as int);
          }
        }
      }
      if (option == true && listOption.first["question"] != "empty") {
        var index = this.listQuestion.indexOf(listOption.first["question"]);
        optionId = listQuestionId[index];
        if (listType[index] == 4) {
          listAnswer = ["1", "2", "3", "4", "5"];
        } else {
          listAnswer = [];
          var list = detailSurveyCubit.surveyModel!.detail
              .firstWhere((e) => e["id"] == listQuestionId[index])["answer"];
          for (var i in list) {
            listAnswer.add(i.toString());
          }
        }
      }
    }
  }

  chooseOption(String value) {
    var index = listQuestion.indexOf(value);
    Map question = {
      "id": detailSurveyCubit.selector,
      "type": detailSurveyCubit.surveyModel!.detail[detailSurveyCubit.index]
          ["type"],
      "question": detailSurveyCubit.surveyModel!.detail[detailSurveyCubit.index]
          ["question"],
      "answer": detailSurveyCubit.surveyModel!.detail[detailSurveyCubit.index]
          ["answer"],
      "force": detailSurveyCubit.surveyModel!.detail[detailSurveyCubit.index]
          ["force"],
      "another": detailSurveyCubit.surveyModel!.detail[detailSurveyCubit.index]
          ["another"],
      "option": [
        {
          "id": listQuestionId[index],
          "answer": "empty",
          "question": listQuestion[index]
        }
      ]
    };
    detailSurveyCubit.surveyModel!.detail[detailSurveyCubit.index] = question;
    optionId = listQuestionId[index];
    if (listType[index] == 4) {
      listAnswer = ["1", "2", "3", "4", "5"];
    } else {
      listAnswer = [];
      var list = detailSurveyCubit.surveyModel!.detail
          .firstWhere((e) => e["id"] == listQuestionId[index])["answer"];
      for (var i in list) {
        listAnswer.add(i.toString());
      }
    }
    emit(state + 1);
  }

  chooseAnswer(String value) {
    var index = listAnswer.indexOf(value);
    Map question = {
      "id": detailSurveyCubit.selector,
      "type": detailSurveyCubit.surveyModel!.detail[detailSurveyCubit.index]
          ["type"],
      "question": detailSurveyCubit.surveyModel!.detail[detailSurveyCubit.index]
          ["question"],
      "answer": detailSurveyCubit.surveyModel!.detail[detailSurveyCubit.index]
          ["answer"],
      "force": detailSurveyCubit.surveyModel!.detail[detailSurveyCubit.index]
          ["force"],
      "another": detailSurveyCubit.surveyModel!.detail[detailSurveyCubit.index]
          ["another"],
      "option": [
        {
          "id": detailSurveyCubit.surveyModel!.detail[detailSurveyCubit.index]
              ["option"][0]["id"],
          "answer": listAnswer[index],
          "question": detailSurveyCubit.surveyModel!
              .detail[detailSurveyCubit.index]["option"][0]["question"]
        }
      ]
    };
    detailSurveyCubit.surveyModel!.detail[detailSurveyCubit.index] = question;
    optionId = -1;
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
    for (var i in answerCon) {
      answerList.add(i.text);
    }
    Map question = {
      "id": detailSurveyCubit.selector,
      "type": detailSurveyCubit.surveyModel!.detail[detailSurveyCubit.index]
          ["type"],
      "question": detailSurveyCubit.surveyModel!.detail[detailSurveyCubit.index]
          ["question"],
      "answer": answerList,
      "force": detailSurveyCubit.surveyModel!.detail[detailSurveyCubit.index]
          ["force"],
      "another": detailSurveyCubit.surveyModel!.detail[detailSurveyCubit.index]
          ["another"],
      "option": detailSurveyCubit.surveyModel!.detail[detailSurveyCubit.index]
          ["option"]
    };
    detailSurveyCubit.surveyModel!.detail[detailSurveyCubit.index] = question;
    emit(state + 1);
  }

  changeForce(bool value) {
    Map question = {
      "id": detailSurveyCubit.selector,
      "type": detailSurveyCubit.surveyModel!.detail[detailSurveyCubit.index]
          ["type"],
      "question": detailSurveyCubit.surveyModel!.detail[detailSurveyCubit.index]
          ["question"],
      "answer": detailSurveyCubit.surveyModel!.detail[detailSurveyCubit.index]
          ["answer"],
      "force": value,
      "another": detailSurveyCubit.surveyModel!.detail[detailSurveyCubit.index]
          ["another"],
      "option": detailSurveyCubit.surveyModel!.detail[detailSurveyCubit.index]
          ["option"]
    };
    detailSurveyCubit.surveyModel!.detail[detailSurveyCubit.index] = question;
    emit(state + 1);
  }

  changeAnother(bool value) {
    Map question = {
      "id": detailSurveyCubit.selector,
      "type": detailSurveyCubit.surveyModel!.detail[detailSurveyCubit.index]
          ["type"],
      "question": detailSurveyCubit.surveyModel!.detail[detailSurveyCubit.index]
          ["question"],
      "answer": detailSurveyCubit.surveyModel!.detail[detailSurveyCubit.index]
          ["answer"],
      "force": detailSurveyCubit.surveyModel!.detail[detailSurveyCubit.index]
          ["force"],
      "another": value,
      "option": detailSurveyCubit.surveyModel!.detail[detailSurveyCubit.index]
          ["option"]
    };
    detailSurveyCubit.surveyModel!.detail[detailSurveyCubit.index] = question;
    emit(state + 1);
  }

  deleteOption() {
    listAnswer = [];
    optionId = -1;
    Map question = {
      "id": detailSurveyCubit.selector,
      "type": detailSurveyCubit.surveyModel!.detail[detailSurveyCubit.index]
          ["type"],
      "question": detailSurveyCubit.surveyModel!.detail[detailSurveyCubit.index]
          ["question"],
      "answer": detailSurveyCubit.surveyModel!.detail[detailSurveyCubit.index]
          ["answer"],
      "force": detailSurveyCubit.surveyModel!.detail[detailSurveyCubit.index]
          ["force"],
      "another": detailSurveyCubit.surveyModel!.detail[detailSurveyCubit.index]
          ["another"],
      "option": []
    };
    detailSurveyCubit.surveyModel!.detail[detailSurveyCubit.index] = question;
    emit(state + 1);
  }

  changeOption(bool value) {
    option = value;
    if (value == true) {
      Map question = {
        "id": detailSurveyCubit.selector,
        "type": detailSurveyCubit.surveyModel!.detail[detailSurveyCubit.index]
            ["type"],
        "question": detailSurveyCubit
            .surveyModel!.detail[detailSurveyCubit.index]["question"],
        "answer": detailSurveyCubit.surveyModel!.detail[detailSurveyCubit.index]
            ["answer"],
        "force": detailSurveyCubit.surveyModel!.detail[detailSurveyCubit.index]
            ["force"],
        "another": detailSurveyCubit
            .surveyModel!.detail[detailSurveyCubit.index]["another"],
        "option": [
          {"id": -1, "answer": "empty", "question": "empty"}
        ]
      };
      detailSurveyCubit.surveyModel!.detail[detailSurveyCubit.index] = question;
    } else {
      Map question = {
        "id": detailSurveyCubit.selector,
        "type": detailSurveyCubit.surveyModel!.detail[detailSurveyCubit.index]
            ["type"],
        "question": detailSurveyCubit
            .surveyModel!.detail[detailSurveyCubit.index]["question"],
        "answer": detailSurveyCubit.surveyModel!.detail[detailSurveyCubit.index]
            ["answer"],
        "force": detailSurveyCubit.surveyModel!.detail[detailSurveyCubit.index]
            ["force"],
        "another": detailSurveyCubit
            .surveyModel!.detail[detailSurveyCubit.index]["another"],
        "option": []
      };
      listAnswer = [];
      detailSurveyCubit.surveyModel!.detail[detailSurveyCubit.index] = question;
    }
    emit(state + 1);
  }

  deleteAnswer(int index) {
    for (int i = 1; i < detailSurveyCubit.surveyModel!.detail.length; i++) {
      if (detailSurveyCubit.surveyModel!.detail[i]["option"].length != 0) {
        if (detailSurveyCubit.surveyModel!.detail[i]["option"][0]["id"] ==
                detailSurveyCubit.selector &&
            detailSurveyCubit.surveyModel!.detail[i]["option"][0]["answer"] ==
                answerCon[index].text) {
          detailSurveyCubit.surveyModel!.detail[i]["option"] = [];
        }
      }
    }
    answerCon.remove(answerCon[index]);
    changeAnswer();
    emit(state + 1);
  }

  String convertQuestion(Map item) {
    String value = item["question"];
    return value;
  }

  addNewAnswer() {
    var newAnswerCon = TextEditingController();
    answerCon.add(newAnswerCon);
    emit(state + 1);
  }

  changeQuestion() {
    Map question = {
      "id": detailSurveyCubit.selector,
      "type": detailSurveyCubit.surveyModel!.detail[detailSurveyCubit.index]
          ["type"],
      "question": quesCon!.text,
      "answer": detailSurveyCubit.surveyModel!.detail[detailSurveyCubit.index]
          ["answer"],
      "force": detailSurveyCubit.surveyModel!.detail[detailSurveyCubit.index]
          ["force"],
      "another": detailSurveyCubit.surveyModel!.detail[detailSurveyCubit.index]
          ["another"],
      "option": detailSurveyCubit.surveyModel!.detail[detailSurveyCubit.index]
          ["option"]
    };
    detailSurveyCubit.surveyModel!.detail[detailSurveyCubit.index] = question;
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
    int oldType =
        detailSurveyCubit.surveyModel!.detail[detailSurveyCubit.index]["type"];
    if (oldType != temp) {
      for (int i = 1; i < detailSurveyCubit.surveyModel!.detail.length; i++) {
        if (detailSurveyCubit.surveyModel!.detail[i]["option"].length != 0) {
          if (detailSurveyCubit.surveyModel!.detail[i]["option"][0]["id"] ==
              detailSurveyCubit.selector) {
            detailSurveyCubit.surveyModel!.detail[i]["option"] = [];
          }
        }
      }
    }
    Map question = {
      "id": detailSurveyCubit.selector,
      "type": temp,
      "question": detailSurveyCubit.surveyModel!.detail[detailSurveyCubit.index]
          ["question"],
      "answer": temp > 2
          ? []
          : detailSurveyCubit.surveyModel!.detail[detailSurveyCubit.index]
              ["answer"],
      "force": detailSurveyCubit.surveyModel!.detail[detailSurveyCubit.index]
          ["force"],
      "another": temp > 2
          ? false
          : detailSurveyCubit.surveyModel!.detail[detailSurveyCubit.index]
              ["another"],
      "option": detailSurveyCubit.surveyModel!.detail[detailSurveyCubit.index]
          ["option"]
    };
    if (temp > 2) {
      answerCon = [];
    }
    detailSurveyCubit.surveyModel!.detail[detailSurveyCubit.index] = question;
    emit(state + 1);
  }
}
