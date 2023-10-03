import 'package:internal_sakumi/model/question_model.dart';
import 'package:internal_sakumi/model/student_model.dart';

import 'answer_model.dart';
import 'class_model.dart';
import 'course_model.dart';

class DetailGradingDataModel {
  List<QuestionModel> listQuestions;
  List<AnswerModel> listAnswer;
  List<StudentModel> listStudent;
  ClassModel classModel;
  CourseModel courseModel;
  List<int> listStudentId;
  List<bool> listState;

  DetailGradingDataModel(
      {required this.classModel,
      required this.listQuestions,
      required this.listAnswer,
      required this.listStudent,
      required this.courseModel,
      required this.listStudentId,
      required this.listState});

  factory DetailGradingDataModel.fromData(
      List<QuestionModel> listQuestions,
      List<AnswerModel> listAnswer,
      List<StudentModel> listStudent,
      ClassModel classModel,
      CourseModel courseModel,
      List<int> listStudentId,
      List<bool> listState) {
    return DetailGradingDataModel(
        classModel: classModel,
        listQuestions: listQuestions,
        listAnswer: listAnswer,
        listStudent: listStudent,
        courseModel: courseModel,
        listStudentId: listStudentId,
        listState: listState);
  }
}
