import 'package:cloud_firestore/cloud_firestore.dart';

class ClassModel {
  final int classId, courseId;
  final String description, endTime, startTime, note, classCode;

  ClassModel(
      {required this.classId,
      required this.courseId,
      required this.description,
      required this.endTime,
      required this.startTime,
      required this.note,
      required this.classCode});
  factory ClassModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return ClassModel(
      classId: data['class_id']??-1,
      courseId: data['course_id']??-1,
      description: data['description']??'',
      endTime: data['end_time']??'',
      startTime: data['start_time']??'',
      note: data['note']??'',
      classCode: data['class_code']??'',
    );
  }
}
// class_id
// course_id
// class_code
// description
// start_time
// end_time
// note
