import 'package:cloud_firestore/cloud_firestore.dart';

class AnswerModel {
  final int  studentId, questionId, questionType, parentId, score;
  final String teacherNote, type;
  final List answer, images, records;

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
