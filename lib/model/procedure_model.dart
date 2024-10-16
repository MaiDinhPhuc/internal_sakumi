import 'package:cloud_firestore/cloud_firestore.dart';

class ProcedureModel {
  final int id;
  final String des, title, type;
  final List items;
  final bool status, isCustom;

  ProcedureModel(
      {required this.id,
      required this.des,
      required this.title,
      required this.items,
      required this.type,
      required this.status,
      required this.isCustom});

  factory ProcedureModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return ProcedureModel(
        id: data['id'] ?? 0,
        title: data['title'] ?? "",
        des: data['des'] ?? "",
        items: data['items'] ?? [],
        type: data['type'] ?? "checklist",
        status: data['status'] ?? true,
        isCustom: data['isCustom'] ?? false);
  }
}
