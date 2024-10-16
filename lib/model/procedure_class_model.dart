import 'package:cloud_firestore/cloud_firestore.dart';

class ProcedureClassModel {
  final int id, procedureId, classId;
  final String type;
  final List info;


  ProcedureClassModel copyWith(
      {int? id,
        int? procedureId,
        int? classId,
        String? type,
        List? info}) {
    return ProcedureClassModel(
        id: id ?? this.id,
        procedureId: procedureId ?? this.procedureId,
        classId: classId ?? this.classId,
        type: type ?? this.type,
        info: info ?? this.info);
  }


  ProcedureClassModel(
      {required this.id,
        required this.procedureId,
        required this.info,
        required this.type, required this.classId});

  factory ProcedureClassModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return ProcedureClassModel(
        id: data['id'] ?? 0,
        procedureId: data['procedureId'] ?? 0,
        info: data['info'] ?? [],
        type: data['type'] ?? 'checklist',
        classId: data['classId'] ?? 0);
  }
}