import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/app_configs.dart';
import 'package:internal_sakumi/model/answer_model.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/model/detail_grading_data_model.dart';
import 'package:internal_sakumi/model/question_model.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/utils/text_utils.dart';

class DetailGradingCubit extends Cubit<int> {
  DetailGradingCubit() : super(-1);

  DetailGradingDataModel? data;

  List<QuestionModel>? listQuestions;
  List<AnswerModel>? listAnswer;
  List<StudentModel>? listStudent;
  ClassModel? classModel;
  CourseModel? courseModel;
  int now = 0;
  bool isShowName = true;
  bool isGeneralComment = false;
  List<int>? listStudentId;
  List<bool>? listState;
  String token = "";
  String gradingType = "";

  init(String type) async {
    if(type == "type=test"){
      gradingType = "test";
    }else{
      gradingType = "btvn";
    }

    data = await FireBaseProvider.instance.getDataForDetailGrading(int.parse(TextUtils.getName(position: 1)),
        int.parse(TextUtils.getName()), type);
    listQuestions = data!.listQuestions;
    classModel = data!.classModel;
    courseModel = data!.courseModel;
    token = courseModel!.token;
    listAnswer = data!.listAnswer;

    if(listAnswer!.isEmpty){
      emit(0);
    }else{
      listState = data!.listState;
      listStudentId = data!.listStudentId;
      listStudent = data!.listStudent;
      checkDone(true);
      if (listQuestions!.isNotEmpty) {
        now = listQuestions!.first.id;
        emit(listQuestions!.first.id);
      } else {
        emit(0);
      }
    }
  }

  String getStudentName(AnswerModel answerModel) {
    for (var i in listStudent!) {
      if (i.userId == answerModel.studentId) {
        return i.name;
      }
    }
    return "";
  }

  QuestionModel getQuestion(){
    var question = listQuestions!.firstWhere((e) => e.id == now);
    return question;
  }

  updateAnswerView(int questionId) async {
    now = questionId;
    emit(0);
    emit(questionId);
  }

  loadingState(){
    emit(-2);
  }

  updateAfterGrading(int questionId) async {
    now = questionId;
    emit(questionId);
  }

  List<AnswerModel> get answers => listAnswer!
      .where((answer) =>
          answer.questionId == now &&
          listStudentId!.contains(answer.studentId))
      .toList();

  bool checkDone(bool isFirst) {
    if (isFirst) {
      for (var i in listQuestions!) {
        bool check = false;
        int count = 0;
        for (var j in getAnswerById(i.id)) {
          if (j.newScore != -1) {
            count++;
          }
        }
        if (count == getAnswerById(i.id).length) {
          check = true;
        }
        listState!.add(check);
      }
    }
    bool isDone = listState!.every((element) => element == true);
    return isDone;
  }

  List<AnswerModel> getAnswerById(int questionId) {
    List<AnswerModel> list =
        listAnswer!.where((answer) => answer.questionId == questionId).toList();
    return list;
  }

  change(int questionId) async {
    now = questionId;
    emit(questionId);
  }
}
