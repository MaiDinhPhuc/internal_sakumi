import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
  static saveUser(String email, String role, int uid) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc("user_${uid}_$role")
        .set({'email': email, 'roles': role, 'user_id': uid});
  }

  static addSensei(
    String name,
    String note,
    String phone,
    int uid,
    String teacherCode,
    String url,
  ) async {
    await FirebaseFirestore.instance
        .collection('teacher')
        .doc("teacher_user_$uid")
        .set({
      'name': name,
      'note': note,
      'phone': phone,
      'teacher_code': teacherCode,
      'url': url,
      'user_id': uid,
    });
  }

  static addStudent(
    int uid,
    String name,
    String note,
    String phone,
    String studentCode,
    String url,
    bool inJapan,
  ) async {
    await FirebaseFirestore.instance
        .collection('students')
        .doc("student_user_$uid")
        .set({
      'in_jp': inJapan,
      'name': name,
      'note': note,
      'phone': phone,
      'student_code': studentCode,
      'url': url,
      'user_id': uid,
      'status': 'progress'
    });
  }

  static addNewClass(int classId, int cid, String classCode, String description,
      String start, String end, String note) async {
    await FirebaseFirestore.instance
        .collection('class')
        .doc("class_${classId}_course_$cid")
        .set({
      'class_id': classId,
      'course_id': cid,
      'class_code': classCode,
      'description': description,
      'start_time': start,
      'end_time': end,
      'note': note,
      'status': 'progress',
      'list_student': [],
      'list_teacher': []
    });
  }
}
