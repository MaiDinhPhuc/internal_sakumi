import 'package:cloud_firestore/cloud_firestore.dart';

class BrowseDownloadModel {
  final int id,
      lessonId,
      classId,
      teacherId,
      submitTime,
      downloadTime,
      acceptTime,
      supportId,
      parentId;
  final String status;

  BrowseDownloadModel(
      {required this.lessonId,
      required this.classId,
      required this.teacherId,
      required this.submitTime,
      required this.downloadTime,
      required this.acceptTime,
      required this.status,
      required this.supportId,
      required this.id,
      required this.parentId});

  BrowseDownloadModel copyWith({
    int? lessonId,
    int? classId,
    int? teacherId,
    int? submitTime,
    int? downloadTime,
    int? acceptTime,
    int? supportId,
    int? parentId,
    String? status,
  }) {
    return BrowseDownloadModel(
        lessonId: lessonId ?? this.lessonId,
        classId: classId ?? this.classId,
        teacherId: teacherId ?? this.teacherId,
        submitTime: submitTime ?? this.submitTime,
        downloadTime: downloadTime ?? this.downloadTime,
        status: status ?? this.status,
        acceptTime: acceptTime ?? this.acceptTime,
        supportId: supportId ?? this.supportId,
        parentId: parentId ?? this.parentId,
        id: id);
  }

  factory BrowseDownloadModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return BrowseDownloadModel(
        classId: data['class_id'] ?? 0,
        lessonId: data['lesson_id'] ?? 0,
        teacherId: data['teacher_id'] ?? 0,
        submitTime: data['submit_time'] ?? 0,
        downloadTime: data['download_time'] ?? 0,
        acceptTime: data['accept_time'] ?? 0,
        supportId: data['support_id'] ?? 0,
        id: data['id'] ?? 0,
        status: data['status'] ?? "waiting",
        parentId: data['parent_id'] ?? 0);
  }
}
