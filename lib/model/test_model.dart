import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';

class TestModel {
  final String title, description;
  final int id, courseId, difficulty;

  const TestModel(
      {required this.id,
      required this.title,
      required this.difficulty,
      required this.courseId,
      required this.description});

  static Future<bool> check(String jsonData)async{
    final data = json.decode(jsonData);
    for(var i in data){
      int testCount = await FireBaseProvider.instance.getCountWithCondition(
          "test", "id", i['id']);
      if(testCount != 0){
        return false;
      }
    }
    return true;
  }

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
