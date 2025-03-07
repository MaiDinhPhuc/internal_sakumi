import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/model/answer_model.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/course_model.dart';
import 'package:internal_sakumi/model/detail_grading_data_model.dart';
import 'package:internal_sakumi/model/question_model.dart';
import 'package:internal_sakumi/model/student_lesson_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/model/student_test_model.dart';
import 'package:internal_sakumi/providers/cache/cached_data_provider.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/utils/text_utils.dart';

import '../../../services/custom_firebase_firestore.dart';
import 'detail_grading_cubit.dart';
import 'detail_grading_view.dart';

class DetailGradingCubitV2 extends Cubit<int> {
  DetailGradingCubitV2() : super(-1);

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
  List<StudentLessonModel>? stdLessons;
  List<StudentTestModel>? stdTests;

  bool isAll = true;
  int analysis = 1;
  double submitPercent = 0;

  getAveragePoint(){
    var list = listAnswer!.where((e)=>e.score != -1).toList();
    double sum = 0;
    for(var i in list){
      sum = sum + i.newScore;
    }
    if(list.isEmpty) return 0;
    return sum/list.length;
  }

  List<RadarEntryCustom> getDataChart(){
    List<RadarEntryCustom> dataChart = [];
    if(analysis == 1 && gradingType == "test"){
      dataChart = AnalysisTestUtils.createChartData(listQuestions!, listAnswer!);
    }
    return dataChart;
  }

  initCustom(String type) async {
    if (type == "type=test") {
      gradingType = "test";
    } else {
      gradingType = "btvn";
    }
    data = await FireBaseProvider.instance.getDataForDetailGradingCustom(
        int.parse(TextUtils.getName(position: 1)),
        int.parse(TextUtils.getName()),
        int.parse(TextUtils.getName(position: 3)),
        type);
    listQuestions = data!.listQuestions;
    classModel = data!.classModel;
    courseModel = data!.courseModel;
    token = courseModel!.btvnToken;
    listAnswer = data!.listAnswer;
    analysis = data!.analysis;
    if (listAnswer!.isEmpty) {
      emit(0);
    } else {
      listState = data!.listState;
      listStudentId = data!.listStudentId;
      listStudent = data!.listStudent;
      checkDone(true);
      await loadPercent();
      if (listQuestions!.isNotEmpty) {
        now = listQuestions!.first.id;
        emit(listQuestions!.first.id);
        await DataProvider.stdLessonByClassId(
            classModel!.classId, loadStdLesson);

        await DataProvider.stdTestByClassId(classModel!.classId, loadStdTest);
      } else {
        emit(0);
      }
    }
  }

  loadPercent()async{
    var stdClass = await FireBaseProvider.instance.getStudentClassInClass(int.parse(TextUtils.getName(position: 1)));
    var stdLesson = [];
    var stdTest = [];
    if(gradingType == "test"){
      stdTest = await FireBaseProvider.instance.getStudentTestInTest( int.parse(TextUtils.getName(position: 1)),
          int.parse(TextUtils.getName()));
      if(stdClass.isEmpty){
        submitPercent = 0;
      }else{
        submitPercent = stdTest.length / stdClass.length;
      }
    }else{
      stdLesson = await FireBaseProvider.instance.getStudentLessonInLesson(int.parse(TextUtils.getName(position: 1)),
          int.parse(TextUtils.getName()));
      if(stdClass.isEmpty){
        submitPercent = 0;
      }else{
        submitPercent = stdLesson.length / stdClass.length;
      }
    }
  }

  loadStdTest(Object stdTest) {
    stdTests = stdTest as List<StudentTestModel>;
  }

  loadStdLesson(Object stdLessons) {
    this.stdLessons = stdLessons as List<StudentLessonModel>;
  }

  String getStudentName(AnswerModel answerModel) {
    for (var i in listStudent!) {
      if (i.userId == answerModel.studentId) {
        return i.name;
      }
    }
    return "";
  }


  update(){

    List<int> listQuestionId = getListQuestion().map((e)=>e.id).toList();

    if(!listQuestionId.contains(now) && listQuestionId.isNotEmpty){
      now = getListQuestion().first.id;
    }

    emit(state+1);
  }

  List<QuestionModel> getListQuestion(){
    if(isAll) return listQuestions!;
    return listQuestions!.where((e)=>!checkGrading(e.id)).toList();
  }

  bool checkGrading(int questionId){

    bool check = false;

    int count = 0;
    for (var j in getAnswerById(questionId)) {
      if (j.newScore != -1) {
        count++;
      }
    }
    if (count == getAnswerById(questionId).length) {
      check = true;
    }

    return check;
  }

  QuestionModel getQuestion() {
    var question = listQuestions!.firstWhere((e) => e.id == now);
    return question;
  }

  updateAnswerView(int questionId) async {
    now = questionId;
    emit(0);
    emit(questionId);
  }

  loadingState() {
    emit(-2);
  }

  updateAfterGrading(int questionId) async {
    now = questionId;
    emit(questionId);
  }

  List<AnswerModel> get answers => isAll? listAnswer!
      .where((answer) =>
  answer.questionId == now && listStudentId!.contains(answer.studentId))
      .toList() :listAnswer!
      .where((answer) =>
  answer.questionId == now && listStudentId!.contains(answer.studentId) && answer.score == -1)
      .toList() ;


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

  double getCorrectPercent(int questionId){
    var listAnswer = getAnswerById(questionId);
    int count  = 0;
    for(var i in listAnswer){
      if(i.newScore >= 5){
        count++;
      }
    }

    if(count == 0 || listAnswer.isEmpty) return 0;

    return count/listAnswer.length;
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

  doneGrading(String type){
    int lessonId = int.parse(TextUtils.getName());
    int classId = int.parse(TextUtils.getName(position: 1));
    int customId = int.parse(TextUtils.getName(position: 3));
    for (var i in listStudent!) {
      double temp = 0;
      double total = 0;
      for (var j in listAnswer!) {
        if (i.userId == j.studentId) {
          if (j.newScore != -1) {
            temp = temp + j.newScore;
            total++;
          }
        }
      }
      double submitScore = (temp / (total == 0 ? 1 : total));
      if (type == "test") {
        CustomFirebaseFireStore.database
            .collection('student_test')
            .doc(
            'student_${i.userId}_test_${TextUtils.getName(position: 3)}_class_${TextUtils.getName(position: 1)}')
            .update({
          'score': temp == 0 ? -1 : submitScore,
        });
        var index = stdTests!.indexOf(stdTests!.firstWhere((e) =>
        e.studentId == i.userId &&
            e.testID == int.parse(TextUtils.getName(position: 3))));
        stdTests![index] = StudentTestModel(
            classId: stdTests![index].classId,
            score: temp == 0 ? -1 : submitScore,
            studentId: stdTests![index].studentId,
            testID: stdTests![index].testID,
            time: stdTests![index].time);
        DataProvider.updateStudentTest(stdTests![index].classId, stdTests!);
      } else {
        var index = stdLessons!.indexOf(stdLessons!.firstWhere((e) =>
        e.studentId == i.userId &&
            e.lessonId == customId));

        List<dynamic> listHws = stdLessons![index].hws;

        if(listHws.isEmpty){
          listHws.add({
            'lesson_id' : lessonId,
            'hw': submitScore
          });
        }

        for(int i = 0; i<listHws.length; i++){
          if(listHws[i]['lesson_id'] == lessonId){
            listHws[i] = {
              'lesson_id' : lessonId,
              'hw': submitScore
            };
          }
        }

        CustomFirebaseFireStore.database
            .collection('student_lesson')
            .doc(
            'student_${i.userId}_lesson_${customId}_class_$classId')
            .update({
          'hws': listHws,
        });


        stdLessons![index] = StudentLessonModel(
            grammar: stdLessons![index].grammar,
            hw: stdLessons![index].hw,
            id: stdLessons![index].id,
            classId: stdLessons![index].classId,
            kanji: stdLessons![index].kanji,
            lessonId: stdLessons![index].lessonId,
            listening: stdLessons![index].listening,
            studentId: stdLessons![index].studentId,
            timekeeping: stdLessons![index].timekeeping,
            vocabulary: stdLessons![index].vocabulary,
            teacherNote: stdLessons![index].teacherNote,
            supportNote: stdLessons![index].supportNote,
            time: stdLessons![index].time,
            hws: listHws);
        DataProvider.updateStdLesson(stdLessons![index].classId, stdLessons!);
      }
    }
  }

  Future<void> submit(context, CheckActiveCubit checkCubit, String type) async {
    int lessonId = int.parse(TextUtils.getName());
    int classId = int.parse(TextUtils.getName(position: 1));
    int customId = int.parse(TextUtils.getName(position: 3));

    loadingState();
    for (var i in answers) {
      if (i.listImagePicker.isNotEmpty) {
        List<String> list = [];
        for (var j in i.listImagePicker) {
          if (i.checkIsUrl(j)) {
            list.add(j);
          } else {
            final url = await FireBaseProvider.instance
                .uploadImageAndGetUrl(j, 'teacher_note_for_student','teacher_note_for_student');
            list.add(url);
          }
        }
        i.listImageUrl = list;
      }
    }

    if(type == 'test'){
      for (var i in answers) {
        CustomFirebaseFireStore.database
            .collection('answer')
            .doc('student_${i.studentId}_test_question_${i.questionId}_class_$classId')
            .update({
          'score': listAnswer![listAnswer!.indexOf(i)].newScore,
          'teacher_note': listAnswer![listAnswer!.indexOf(i)].newTeacherNote,
          'teacher_images_note': listAnswer![listAnswer!.indexOf(i)].listImageUrl,
          'teacher_records_note':
          listAnswer![listAnswer!.indexOf(i)].listRecordUrl,
        });
      }
    }else{
      for (var i in answers) {
        CustomFirebaseFireStore.database
            .collection('answer_v2')
            .doc(
            'student_${i.studentId}_homework_question_${i.questionId}_custom_lesson_${customId}_lesson_${lessonId}_class_$classId')
            .update({
          'score': listAnswer![listAnswer!.indexOf(i)].newScore,
          'teacher_note': listAnswer![listAnswer!.indexOf(i)].newTeacherNote,
          'teacher_images_note': listAnswer![listAnswer!.indexOf(i)].listImageUrl,
          'teacher_records_note':
          listAnswer![listAnswer!.indexOf(i)].listRecordUrl,
        });
      }
    }

    bool isDone = true;
    for (var i in answers) {
      if (i.newScore == -1) {
        isDone = false;
      }
    }
    if (isDone == true) {
      listState![listQuestions!.indexOf(
          listQuestions!.firstWhere((element) => element.id == now))] = true;
    } else {
      listState![listQuestions!.indexOf(
          listQuestions!.firstWhere((element) => element.id == now))] = false;
    }
    updateAfterGrading(now);
    isGeneralComment = false;
    checkCubit.changeActive(false);
    if (checkDone(false)) {
      for (var i in listStudent!) {
        double temp = 0;
        for (var j in listAnswer!) {
          if (i.userId == j.studentId) {
            if (j.newScore != -1) {
              temp = temp + j.newScore;
            }
          }
        }
        dynamic submitScore = (temp / listQuestions!.length);

        if (type == "test") {
          CustomFirebaseFireStore.database
              .collection('student_test')
              .doc(
              'student_${i.userId}_test_${customId}_class_$classId')
              .update({
            'score': temp == 0 ? -1 : submitScore,
          });
          var index = stdTests!.indexOf(stdTests!.firstWhere((e) =>
          e.studentId == i.userId &&
              e.testID == customId));
          stdTests![index] = StudentTestModel(
              classId: stdTests![index].classId,
              score: temp == 0 ? -1 : submitScore,
              studentId: stdTests![index].studentId,
              testID: stdTests![index].testID,
              time: stdTests![index].time);
          DataProvider.updateStudentTest(stdTests![index].classId, stdTests!);
        } else {
          var index = stdLessons!.indexOf(stdLessons!.firstWhere((e) =>
          e.studentId == i.userId &&
              e.lessonId == customId));

          List<dynamic> listHws = stdLessons![index].hws;

          if(listHws.isEmpty){
            listHws.add({
              'lesson_id' : lessonId,
              'hw': submitScore
            });
          }

          for(int i = 0; i<listHws.length; i++){
            if(listHws[i]['lesson_id'] == lessonId){
              listHws[i] = {
                'lesson_id' : lessonId,
                'hw': submitScore
              };
            }
          }
          CustomFirebaseFireStore.database
              .collection('student_lesson')
              .doc(
              'student_${i.userId}_lesson_${customId}_class_$classId')
              .update({
            'hws': listHws,
          });


          stdLessons![index] = StudentLessonModel(
              grammar: stdLessons![index].grammar,
              hw: stdLessons![index].hw,
              id: stdLessons![index].id,
              classId: stdLessons![index].classId,
              kanji: stdLessons![index].kanji,
              lessonId: stdLessons![index].lessonId,
              listening: stdLessons![index].listening,
              studentId: stdLessons![index].studentId,
              timekeeping: stdLessons![index].timekeeping,
              vocabulary: stdLessons![index].vocabulary,
              teacherNote: stdLessons![index].teacherNote,
              supportNote: stdLessons![index].supportNote,
              time: stdLessons![index].time,
              hws: listHws);
          DataProvider.updateStdLesson(stdLessons![index].classId, stdLessons!);
        }
      }
    }
  }
}
