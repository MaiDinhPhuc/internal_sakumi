import 'package:cloud_firestore/cloud_firestore.dart';

class CSOption {
  final int id , type, csId;
  final List<dynamic> parents;
  const CSOption({
    required this.id,
    required this.type,
    required this.csId,
    required this.parents,
  });
  CSOption copyWith({
    int? id,
    int? type,
    int? csId,
    List<dynamic>? parents,

  }) {
    return CSOption(
      id: id ?? this.id,
      type: type ?? this.type,
      csId: csId ?? this.csId,
      parents: parents ?? this.parents,
    );
  }
  factory CSOption.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return CSOption(
      id: data["id"] ?? 0,
      type: data["type"] ?? 0,
      csId: data["cs_id"] ?? 0,
      parents: data['parents'] ?? [],);
  }

  factory CSOption.fromMap(
      Map<String, dynamic> data) {
    return CSOption(
      id: data["id"] ?? 0,
      type: data["type"] ?? 0,
      csId: data["cs_id"] ?? 0,
      parents: data['parents'] ?? [],);
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'cs_id': csId,
      'parents': parents,
    };
  }
}