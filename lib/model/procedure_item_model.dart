import 'package:cloud_firestore/cloud_firestore.dart';

class ProcedureItemModel {
  final int id,group;
  final String title, des, content, type;
  final bool status, isProgress;

  ProcedureItemModel(
      {required this.id,
      required this.title,
      required this.des,
      required this.content,
      required this.group,
      required this.type,
      required this.status,
      required this.isProgress});

  ProcedureItemModel copyWith(
      {int? id,
      String? title,
      String? des,
      String? content,
      String? type,
      int? group,
      bool? status, bool? isProgress}) {
    return ProcedureItemModel(
        id: id ?? this.id,
        group: group ?? this.group,
        content: content ?? this.content,
        des: des ?? this.des,
        title: title ?? this.title,
        type: type ?? this.type,
        status: status ?? this.status,
        isProgress: isProgress ?? this.isProgress);
  }

  factory ProcedureItemModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return ProcedureItemModel(
        id: data['id'] ?? 0,
        group: data['group'] ?? 0,
        content: data['content'] ?? "",
        des: data['des'] ?? "",
        title: data['title'] ?? "",
        type: data['type'] ?? 'checklist',
        status: data['status'] ?? true,
        isProgress: data['isProgress'] ?? false);
  }
}
