import 'package:cloud_firestore/cloud_firestore.dart';

class TestModel {
  final String title, description;
  final int id, courseId, difficulty;

  const TestModel(
      {required this.id,
      required this.title,
      required this.difficulty,
      required this.courseId,
      required this.description});

  factory TestModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return TestModel(
      id: data["id"],
      title: data["title"]??"",
      difficulty: data['difficulty']??0,
      courseId: data["course_id"]??0,
      description: data['description']??"",
    );
  }
}
