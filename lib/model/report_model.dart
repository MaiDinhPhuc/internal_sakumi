import 'package:cloud_firestore/cloud_firestore.dart';

class ReportModel {
  final int id, teacherId, classId;
  final String status, createName, title, content, type, range;
  final bool delete;
  final List files;

  ReportModel(
      {required this.id,
      required this.teacherId,
      required this.status,
      required this.createName,
      required this.title,
      required this.content,
      required this.delete,
      required this.files,
      required this.type,
      required this.classId, required this.range});
  factory ReportModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return ReportModel(
        id: data['id'],
        teacherId: data['teacher_id'],
        status: data['status'] ?? 'Tốt',
        range: data['range'] ?? "Quan trọng",
        title: data['title'] ?? '',
        content: data['content'] ?? '',
        delete: data['delete'] ?? false,
        createName: data['create_name'] ?? '',
        files: data['files'] ?? [],
        type: data['type'], classId: data['class_id'] ?? 0);
  }
}
