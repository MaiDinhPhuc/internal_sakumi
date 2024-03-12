import 'package:cloud_firestore/cloud_firestore.dart';

class ReportModel {
  final int id, teacherId;
  final String status, createName, title, content;
  final bool delete;
  final List images;

  ReportModel(
      {required this.id,
      required this.teacherId,
      required this.status,
      required this.createName,
      required this.title,
      required this.content,
      required this.delete,
      required this.images});
  factory ReportModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return ReportModel(
        id: data['id'],
        teacherId: data['teacher_id'],
        status: data['status'] ?? 'Tốt',
        title: data['title'] ?? '',
        content: data['content'] ?? '',
        delete: data['delete'] ?? false,
        createName: data['create_name'] ?? '',
        images: data['images'] ?? []);
  }
}
