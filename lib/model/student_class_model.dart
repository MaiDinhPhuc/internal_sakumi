import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';

class StudentClassModel {
  final int activeStatus, classId, id, learningStatus, moveTo, userId;
  final String classStatus, date;
  String? _status;
  StudentClassModel(
      {required this.id,
      required this.classId,
      required this.activeStatus,
      required this.learningStatus,
      required this.moveTo,
      required this.userId,
      required this.classStatus,
      required this.date});


  String get status => _status ?? classStatus;
  set status(String value){
    _status = value;
  }

  Color get color {
    switch (status) {
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
    switch (status) {
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


  factory StudentClassModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return StudentClassModel(
        id: data['id'],
        classId: data['class_id'],
        activeStatus: data['active_status'],
        learningStatus: data['learning_status'],
        moveTo: data['move_to'],
        userId: data['user_id'],
        classStatus: data['class_status'] ?? '',
        date: data['date'] ?? '');
  }
}
