import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
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
      case 'Remove':
        return 'dropped';
      case 'Viewer':
        return 'viewer';
      case 'UpSale':
        return 'up_sale';
      case 'ReNew':
        return 're_new';
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
      case 'ReNew':
        return AppText.stsRenew.text;
      case 'Remove':
        return AppText.stsRemove.text;
      case 'UpSale':
        return AppText.stsUpSale.text;
      default:
        return AppText.stsInProgress.text;
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
