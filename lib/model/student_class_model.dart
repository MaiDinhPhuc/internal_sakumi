import 'package:cloud_firestore/cloud_firestore.dart';

class StudentClassModel {
  final int activeStatus, classId, id, learningStatus, moveTo, userId;
  final String classStatus, date;
  const StudentClassModel(
      {required this.id,
      required this.classId,
      required this.activeStatus,
      required this.learningStatus,
      required this.moveTo,
      required this.userId,
      required this.classStatus,
      required this.date});

  factory StudentClassModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return StudentClassModel(
        id: data['id'],
        classId: data['class_id'],
        activeStatus: data['active_status'],
        learningStatus: data['learning_status'],
        moveTo: data['move_to'],
        userId: data['user_id'],
        classStatus: data['class_status'] ?? '',
        date: data['date'] ?? '');
  }
}
