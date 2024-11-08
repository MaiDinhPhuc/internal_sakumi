import 'package:cloud_firestore/cloud_firestore.dart';

class ProcedureGroupModel {
  final int id;
  final String title, des, type;
  final bool status;

  ProcedureGroupModel(
      {required this.id,
        required this.title,
        required this.des,
        required this.type,
        required this.status});

  ProcedureGroupModel copyWith(
      {int? id,
        String? title,
        String? des,
        String? content,
        String? type,
        List? group,
        bool? status, bool? isProgress}) {
    return ProcedureGroupModel(
        id: id ?? this.id,
        des: des ?? this.des,
        title: title ?? this.title,
        type: type ?? this.type,
        status: status ?? this.status);
  }

  factory ProcedureGroupModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return ProcedureGroupModel(
        id: data['id'] ?? 0,
        des: data['des'] ?? "",
        title: data['title'] ?? "",
        type: data['type'] ?? 'checklist',
        status: data['status'] ?? true,);
  }
}