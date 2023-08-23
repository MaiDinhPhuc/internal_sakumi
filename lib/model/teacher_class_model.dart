import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:internal_sakumi/configs/text_configs.dart';

class TeacherClassModel {
  final String classStatus, date;
  final int userId, classId, id;

  const TeacherClassModel(
      {required this.id,
      required this.userId,
      required this.classId,
      required this.classStatus,
      required this.date});

  static String fromString(String s) {
    switch (s) {
      case 'Đang diễn ra':
        return 'InProgress';
      case 'Đã kết thúc':
        return 'Complete';
      default:
        return '';
    }
  }
  factory TeacherClassModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return TeacherClassModel(
        id: data["id"],
        classId: data["class_id"],
        userId: data['user_id'],
        date: data["date"],
        classStatus: data['class_status']);
  }
}
