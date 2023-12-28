import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/Material.dart';

class ClassModel {
  final int classId, courseId, classType;
  final String description, endTime, startTime, note, classCode, classStatus, link;

  Color getColor() {
    switch (classStatus) {
      case 'InProgress':
        return const Color(0xff33691e);
      case 'Cancel':
        return const Color(0xffB71C1C);
      case 'Completed':
      case 'Preparing':
        return const Color(0xff757575);
      default:
        return const Color(0xff33691e);
    }
  }

  String getIcon() {
    switch (classStatus) {
      case 'InProgress':
      case 'Preparing':
        return "in_progress";
      case 'Cancel':
        return "dropped";
      case 'Completed':
        return "check";
      default:
        return "in_progress";
    }
  }

  ClassModel(
      {required this.classId,
      required this.courseId,
      required this.description,
      required this.endTime,
      required this.startTime,
      required this.note,
      required this.classCode,
      required this.classStatus,
      required this.classType, required this.link});
  factory ClassModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return ClassModel(
        classId: data['class_id'] ?? -1,
        courseId: data['course_id'] ?? -1,
        description: data['description'] ?? '',
        endTime: data['end_time'] ?? '',
        startTime: data['start_time'] ?? '',
        note: data['note'] ?? '',
        classCode: data['class_code'] ?? '',
        classStatus: data['class_status'] ?? '',
        classType: data['class_type']??0, link: data['link'] ?? '');
  }
}
