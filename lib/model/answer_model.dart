import 'package:cloud_firestore/cloud_firestore.dart';

class AnswerModel {
  final int  studentId, questionId, questionType, parentId, score;
  final String teacherNote, type;
  final List answer, images, records;
  int? _newScore;

  AnswerModel({
    required this.studentId,
    required this.questionId,
    required this.answer,
    required this.score,
    required this.questionType,
    required this.parentId,
    required this.teacherNote,
    required this.type,
    required this.images,
    required this.records
  });


  int get newScore => _newScore ?? score;

  set newScore(int values) {
    _newScore = values;
  }


  List<String> get convertAnswer => convert(answer,questionType);
  List<String> convert(List answerList, int questionType){
    List<String> listCv = [];
    if (questionType == 1 || questionType == 5 || questionType == 6 || questionType == 11 || questionType == 4) {
      listCv = [answerList.first];
    } else if (questionType == 3 || questionType == 10 || questionType == 2) {
      for(var i in answerList){
        listCv.add(i);
      }
    } else if (questionType == 7 ) {
      String joinedString = answerList.join(' ');
      listCv = [joinedString];
    } else if(questionType == 8) {
      for(var i in answerList){
        listCv.add(i.toString().replaceAll("|", "-"));
      }
      String joinedString = listCv.join('\n');
      listCv = [joinedString];
    }
    return listCv;
  }

  factory AnswerModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return AnswerModel(
      studentId: data['student_id'],
      questionId: data['question_id'],
      answer: data['answer'],
      score: data['score'],
      questionType: data['question_type'],
      teacherNote: data['teacher_note'],
      parentId: data['parent_id'],
      type: data['type'],
      images: data['teacher_images_note'],
      records: data['teacher_records_vote']
    );
  }
}
