import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
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
  List<StudentLessonModel>? stdLessons;
  List<StudentTestModel>? stdTests;
  bool isAll = true;
  int analysis = 1;

  double submitPercent = 0;

  loading(){
    emit(-1);
  }

  update(){

    // List<int> listQuestionId = getListQuestion().map((e)=>e.id).toList();
    //
    // if(!listQuestionId.contains(now)){
    //   now = getListQuestion().first.id;
    // }

    emit(state+1);
  }

  List<QuestionModel> getListQuestion(){
    if(isAll) return listQuestions!;
    return listQuestions!.where((e)=>!checkGrading(e.id)).toList();
  }

  List<RadarEntryCustom> getDataChart(){
    List<RadarEntryCustom> dataChart = [];
    if(analysis == 1 && gradingType == "test"){
      dataChart = AnalysisTestUtils.createChartData(listQuestions!, listAnswer!);
    }
    return dataChart;
  }

  init(String type) async {
    if (type == "type=test") {
      gradingType = "test";
    } else {
      gradingType = "btvn";
    }

    data = await FireBaseProvider.instance.getDataForDetailGrading(
        int.parse(TextUtils.getName(position: 1)),
        int.parse(TextUtils.getName()),
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
      await loadPercent();
      listState = data!.listState;
      listStudentId = data!.listStudentId;
      listStudent = data!.listStudent;
      checkDone(true);
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

  loadStdTest(Object stdTest) {
    stdTests = stdTest as List<StudentTestModel>;
  }

  loadStdLesson(Object stdLessons) {
    this.stdLessons = stdLessons as List<StudentLessonModel>;
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

  String getStudentName(AnswerModel answerModel) {
    for (var i in listStudent!) {
      if (i.userId == answerModel.studentId) {
        return i.name;
      }
    }
    return "";
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

  getAveragePoint(){
    var list = listAnswer!.where((e)=>e.score != -1).toList();
    double sum = 0;
    for(var i in list){
      sum = sum + i.newScore;
    }
    if(list.isEmpty || sum < 0) return 0;
    return sum/list.length;
  }

  List<AnswerModel> get answers => listAnswer!
      .where((answer) =>
          answer.questionId == now && listStudentId!.contains(answer.studentId))
      .toList();

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
            'student_${i.userId}_test_${TextUtils.getName()}_class_${TextUtils.getName(position: 1)}')
            .set({
          'score': total == 0 ? -1 : submitScore,
          'student_id': i.userId,
          'test_id':int.parse(TextUtils.getName()),
          'class_id': int.parse(TextUtils.getName(position: 1))
        });

        var index = stdTests!.indexOf(stdTests!.firstWhere((e) =>
        e.studentId == i.userId &&
            e.testID == int.parse(TextUtils.getName())));
        stdTests![index] = StudentTestModel(
            classId: stdTests![index].classId,
            score: total == 0 ? -1 : submitScore,
            studentId: stdTests![index].studentId,
            testID: stdTests![index].testID,
            time: stdTests![index].time);
        DataProvider.updateStudentTest(stdTests![index].classId, stdTests!);
      } else {
        CustomFirebaseFireStore.database
            .collection('student_lesson')
            .doc(
            'student_${i.userId}_lesson_${TextUtils.getName()}_class_${TextUtils.getName(position: 1)}')
            .update({
          'hw': temp == 0 ? -1 : submitScore,
        });
        var index = stdLessons!.indexOf(stdLessons!.firstWhere((e) =>
        e.studentId == i.userId &&
            e.lessonId == int.parse(TextUtils.getName())));
        stdLessons![index] = StudentLessonModel(
            grammar: stdLessons![index].grammar,
            hw: temp == 0 ? -1 : submitScore,
            id: stdLessons![index].id,
            classId: stdLessons![index].classId,
            kanji:stdLessons![index].kanji,
            lessonId: stdLessons![index].lessonId,
            listening: stdLessons![index].listening,
            studentId: stdLessons![index].studentId,
            timekeeping: stdLessons![index].timekeeping,
            vocabulary: stdLessons![index].vocabulary,
            teacherNote: stdLessons![index].teacherNote,
            supportNote: stdLessons![index].supportNote,
            time: stdLessons![index].time, hws: stdLessons![index].hws);
        DataProvider.updateStdLesson(stdLessons![index].classId, stdLessons!);
      }
    }
  }

  Future<void> submit(context, CheckActiveCubit checkCubit, String type) async {
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

    for (var i in answers) {
        CustomFirebaseFireStore.database
          .collection('answer')
          .doc(type == "test"
              ? 'student_${i.studentId}_test_question_${i.questionId}_class_${TextUtils.getName(position: 1)}'
              : 'student_${i.studentId}_homework_question_${i.questionId}_lesson_${TextUtils.getName()}_class_${TextUtils.getName(position: 1)}')
          .update({
        'score': listAnswer![listAnswer!.indexOf(i)].newScore,
        'teacher_note': listAnswer![listAnswer!.indexOf(i)].newTeacherNote,
        'teacher_images_note': listAnswer![listAnswer!.indexOf(i)].listImageUrl,
        'teacher_records_note':
            listAnswer![listAnswer!.indexOf(i)].listRecordUrl,
      });
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
        double submitScore = (temp.toDouble() / listQuestions!.length.toDouble());
        if (type == "test") {
          CustomFirebaseFireStore.database
              .collection('student_test')
              .doc(
                  'student_${i.userId}_test_${TextUtils.getName()}_class_${TextUtils.getName(position: 1)}')
              .update({
            'score': temp == 0 ? -1 : submitScore,
          });
          var index = stdTests!.indexOf(stdTests!.firstWhere((e) =>
              e.studentId == i.userId &&
              e.testID == int.parse(TextUtils.getName())));
          stdTests![index] = StudentTestModel(
              classId: stdTests![index].classId,
              score: temp == 0 ? -1 : submitScore,
              studentId: stdTests![index].studentId,
              testID: stdTests![index].testID,
              time: stdTests![index].time);
          DataProvider.updateStudentTest(stdTests![index].classId, stdTests!);
        } else {
          CustomFirebaseFireStore.database
              .collection('student_lesson')
              .doc(
                  'student_${i.userId}_lesson_${TextUtils.getName()}_class_${TextUtils.getName(position: 1)}')
              .update({
            'hw': temp == 0 ? -1 : submitScore,
          });
          var index = stdLessons!.indexOf(stdLessons!.firstWhere((e) =>
              e.studentId == i.userId &&
              e.lessonId == int.parse(TextUtils.getName())));
          stdLessons![index] = StudentLessonModel(
              grammar: stdLessons![index].grammar,
              hw: temp == 0 ? -1 : submitScore,
              id: stdLessons![index].id,
              classId: stdLessons![index].classId,
              kanji:stdLessons![index].kanji,
              lessonId: stdLessons![index].lessonId,
              listening: stdLessons![index].listening,
              studentId: stdLessons![index].studentId,
              timekeeping: stdLessons![index].timekeeping,
              vocabulary: stdLessons![index].vocabulary,
              teacherNote: stdLessons![index].teacherNote,
              supportNote: stdLessons![index].supportNote,
              time: stdLessons![index].time, hws: stdLessons![index].hws);
          DataProvider.updateStdLesson(stdLessons![index].classId, stdLessons!);
        }
      }
    }
  }
}

class AnalysisTestModel {
  final int right;
  final int max;

  AnalysisTestModel(this.right, this.max);

  AnalysisTestModel copyWith({int? right, int? max}) {
    return AnalysisTestModel(
      right ?? this.right, // Nếu right là null, giữ nguyên giá trị cũ
      max ?? this.max, // Nếu max là null, giữ nguyên giá trị cũ
    );
  }

  double get radarValue => max == 0 ? 0 : ((right / max) * 10).roundToDouble();
}

class AnalysisTestUtils {
  static List<RadarEntryCustom> createChartData(
      List<QuestionModel> questions, List<AnswerModel> answers) {

    Map<int, AnalysisTestModel> maps = {};
    for (var item in answers) {
      final ques = questions.where((e) => e.id == item.questionId).firstOrNull;


      if (ques != null &&
          ques.skill >= 1 &&
          ques.skill <= 8 &&
          item.score > -1) {


        var res = maps[ques.skill];
        var isRight = item.score >= 5;
        if (res == null) {
          maps[ques.skill] = AnalysisTestModel(isRight ? 1 : 0, 1);
        } else {
          maps[ques.skill] = res.copyWith(
              right: isRight ? (res.right) + 1 : res.right, max: res.max + 1);
        }
      }
    }

    List<RadarEntryCustom> data = [];
    for(int i = 1; i<= 8; i++) {
      var res = maps[i];
      if(res != null) {
        data.add(RadarEntryCustom(i - 1, RadarEntry(value: res.radarValue)));
      }
    }

    if(data.length < 3) {
      for(int i = 1; i<= 8; i++) {
        var res = maps[i];
        if(res == null) {
          data.add(RadarEntryCustom(i - 1, const RadarEntry(value: 0)));
          if(data.length == 3) break;
        }
      }
    }
    return data;
  }
}


class RadarEntryCustom {
  final int index;
  final RadarEntry entry;

  RadarEntryCustom(this.index, this.entry);

  String get title {
    switch (index) {
      case 0:
        return "Từ vựng"; // Vocabulary
      case 1:
        return "Ngữ pháp"; // Grammar
      case 2:
        return "Kanji"; // Kanji
      case 3:
        return "Nghe"; // Listening
      case 4:
        return 'Kaiwa'; // Kaiwa (Conversation)
      case 5:
        return "Đọc"; // Reading
      case 6:
        return "Bảng chữ"; // Alphabet
      case 7:
        return 'JLPT'; // JLPT
      default:
        return 'Unknown';
    }

  }

}