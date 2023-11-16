import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/app_configs.dart';
import 'package:internal_sakumi/features/teacher/cubit/data_cubit.dart';
import 'package:internal_sakumi/model/answer_model.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/model/detail_grading_data_model.dart';
import 'package:internal_sakumi/model/question_model.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/utils/text_utils.dart';

import 'detail_grading_view.dart';

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

  Future<void> submit(DetailGradingCubit cubit, context,
      CheckActiveCubit checkCubit, String type, DataCubit dataCubit) async {
    cubit.loadingState();
    for (var i in cubit.answers) {
      if (i.listImagePicker.isNotEmpty) {
        List<String> list = [];
        for (var j in i.listImagePicker) {
          if (i.checkIsUrl(j)) {
            list.add(j);
          } else {
            final url = await FireBaseProvider.instance
                .uploadImageAndGetUrl(j, 'teacher_note_for_student');
            list.add(url);
          }
        }
        i.listImageUrl = list;
      }
    }

    for (var i in cubit.answers) {
      FirebaseFirestore.instance
          .collection('answer')
          .doc(type == "test"
          ? 'student_${i.studentId}_test_question_${i.questionId}_class_${TextUtils.getName(position: 1)}'
          : 'student_${i.studentId}_homework_question_${i.questionId}_lesson_${TextUtils.getName()}_class_${TextUtils.getName(position: 1)}')
          .update({
        'score': cubit.listAnswer![cubit.listAnswer!.indexOf(i)].newScore,
        'teacher_note':
        cubit.listAnswer![cubit.listAnswer!.indexOf(i)].newTeacherNote,
        'teacher_images_note':
        cubit.listAnswer![cubit.listAnswer!.indexOf(i)].listImageUrl
      });
    }
    bool isDone = true;
    for (var i in cubit.answers) {
      if (i.newScore == -1) {
        isDone = false;
      }
    }
    if (isDone == true) {
      cubit.listState![cubit.listQuestions!.indexOf(cubit.listQuestions!
          .firstWhere((element) => element.id == cubit.now))] = true;
    } else {
      cubit.listState![cubit.listQuestions!.indexOf(cubit.listQuestions!
          .firstWhere((element) => element.id == cubit.now))] = false;
    }
    cubit.updateAfterGrading(cubit.now);
    cubit.isGeneralComment = false;
    checkCubit.changeActive(false);
    if (cubit.checkDone(false)) {
      for (var i in cubit.listStudent!) {
        double temp = 0;
        for (var j in cubit.listAnswer!) {
          if (i.userId == j.studentId) {
            if (j.newScore == -1) {
              temp = temp;
            } else {
              temp = temp + j.newScore;
            }
          }
        }
        int submitScore = (temp / cubit.listQuestions!.length).round();
        if (type == "test") {
          FirebaseFirestore.instance
              .collection('student_test')
              .doc(
              'student_${i.userId}_test_${TextUtils.getName()}_class_${TextUtils.getName(position: 1)}')
              .update({
            'score': temp == 0 ? -1 : submitScore,
          });
          dataCubit.updateStudentTestAfterGrading(
              int.parse(TextUtils.getName(position: 1)),
              int.parse(TextUtils.getName()),
              i.userId,
              temp == 0 ? -1 : submitScore);
        } else {
          FirebaseFirestore.instance
              .collection('student_lesson')
              .doc(
              'student_${i.userId}_lesson_${TextUtils.getName()}_class_${TextUtils.getName(position: 1)}')
              .update({
            'hw': temp == 0 ? -1 : submitScore,
          });
          dataCubit.updateStudentLessonAfterGrading(
              int.parse(TextUtils.getName(position: 1)),
              int.parse(TextUtils.getName()),
              i.userId,
              temp == 0 ? -1 : submitScore);
        }
      }
    }
  }
}
