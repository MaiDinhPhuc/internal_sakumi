import 'package:cloud_firestore/cloud_firestore.dart';

class FeedBackModel {
  final int userId, classId, date;
  final List note;
  final String category, content, status, role;

  FeedBackModel(
      {required this.userId,
      required this.classId,
      required this.date,
      required this.note,
      required this.status,
      required this.content,
      required this.category,
      required this.role});
  factory FeedBackModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return FeedBackModel(
        userId: data['user_id'],
        classId: data['class_id'],
        note: data['note'],
        category: data['category'],
        status: data['status'],
        content: data['content'],
        date: data['date'],
        role: data['role'] ?? 'student');
  }
}
