import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';

class StudentModel {
  final String name, note, phone, studentCode, url, status;
  final int userId;
  final bool inJapan;

  const StudentModel(
      {required this.name,
      required this.url,
      required this.note,
      required this.userId,
      required this.inJapan,
      required this.phone,
      required this.studentCode,
      required this.status});

  Color get color {
    switch (status) {
      case 'Completed':
      case 'Moved':
        return const Color(0xffF57F17);
      case 'Retained':
        return const Color(0xffE65100);
      case 'Dropped':
        return const Color(0xffB71C1C);
      case 'Viewer':
        return const Color(0xff757575);
      default:
        return const Color(0xff33691e);
    }
  }

  String get icon {
    switch (status) {
      case 'Completed':
        return 'check';
      case 'Moved':
        return 'moved';
      case 'Retained':
        return 'retained';
      case 'Dropped':
        return 'dropped';
      case 'Viewer':
        return 'viewer';
      default:
        return 'in_progress';
    }
  }

  String get title {
    switch (status) {
      case 'Completed':
        return AppText.stsCompleted.text;
      case 'Moved':
        return AppText.stsMoved.text;
      case 'Retained':
        return AppText.stsRetained.text;
      case 'Dropped':
        return AppText.stsDropped.text;
      case 'Viewer':
        return AppText.stsViewer.text;
      default:
        return AppText.stsInProgress.text;
    }
  }

  factory StudentModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return StudentModel(
        name: data["name"] ?? '',
        note: data["note"] ?? '',
        userId: data['user_id'] ?? 0,
        phone: data["phone"] ?? '',
        studentCode: data["student_code"] ?? '',
        url: data['url'] ?? '',
        inJapan: data['in_jp'] ?? false,
        status: data['status'] ?? '');
  }
}
