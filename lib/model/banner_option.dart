import 'package:cloud_firestore/cloud_firestore.dart';

class BannerOption {
  final int id , type, bannerId;
  final List<dynamic> parents;
  const BannerOption({
    required this.id,
    required this.type,
    required this.bannerId,
    required this.parents,
  });
  BannerOption copyWith({
    int? id,
    int? type,
    int? bannerId,
    List<dynamic>? parents,

  }) {
    return BannerOption(
      id: id ?? this.id,
      type: type ?? this.type,
      bannerId: bannerId ?? this.bannerId,
      parents: parents ?? this.parents,
    );
  }
  factory BannerOption.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return BannerOption(
        id: data["id"] ?? 0,
        type: data["type"] ?? 0,
      bannerId: data["banner_id"] ?? 0,
      parents: data['parents'] ?? [],);
  }

  factory BannerOption.fromMap(
      Map<String, dynamic> data) {
    return BannerOption(
      id: data["id"] ?? 0,
      type: data["type"] ?? 0,
      bannerId: data["banner_id"] ?? 0,
      parents: data['parents'] ?? [],);
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'banner_id': bannerId,
      'parents': parents,
    };
  }
}

