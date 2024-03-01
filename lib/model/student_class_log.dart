import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/Material.dart';

class StudentClassLogModel {
  final int classId, id, userId, courseId, classType;
  final String from, to;

  Color get color {
    switch (to) {
      case 'Completed':
      case 'Moved':
        return const Color(0xffF57F17);
      case 'Retained':
      case 'UpSale':
        return const Color(0xffE65100);
      case 'ReNew':
      case 'Dropped':
      case 'Remove':
        return const Color(0xffB71C1C);
      case 'Viewer':
        return const Color(0xff757575);
      case 'Deposit':
        return Colors.black;
      case 'Force':
        return Colors.blue;
      default:
        return const Color(0xff33691e);
    }
  }

  String get icon {
    switch (to) {
      case 'Completed':
        return 'check';
      case 'Moved':
        return 'moved';
      case 'Retained':
        return 'retained';
      case 'Dropped':
      case 'Deposit':
      case 'Remove':
        return 'dropped';
      case 'Viewer':
        return 'viewer';
      case 'UpSale':
      case "Force":
        return 'up_sale';
      case 'ReNew':
        return 're_new';
      default:
        return 'in_progress';
    }
  }

  StudentClassLogModel(
      {required this.id,
      required this.classId,
      required this.courseId,
      required this.from,
      required this.to,
      required this.userId,
      required this.classType});

  factory StudentClassLogModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return StudentClassLogModel(
        id: data['id'],
        classId: data['class_id'],
        courseId: data['course_id'],
        from: data['from'],
        to: data['to'],
        userId: data['user_id'],
        classType: data['class_type']);
  }
}
