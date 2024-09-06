import 'package:cloud_firestore/cloud_firestore.dart';

class AdminModel {
  final String name, note, phone, adminCode, url, status;
  final int userId;

  const AdminModel(
      {required this.name,
      required this.url,
      required this.note,
      required this.userId,
      required this.phone,
      required this.adminCode,
      required this.status});

  factory AdminModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return AdminModel(
        name: data["name"],
        note: data["note"],
        userId: data['user_id'],
        phone: data["phone"],
        adminCode: data["admin_code"],
        url: data['url'],
        status: data['status']);
  }
}

class EnableGiftModel {
  final bool enable;
  final int id;
  final String title, des, banner;

  const EnableGiftModel(
      {required this.enable,
      required this.id,
      required this.title,
      required this.des,
      required this.banner});

  factory EnableGiftModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return EnableGiftModel(
        enable: data["enable"],
        id: data["id"],
        title: data['title'] ?? "",
        des: data['des'] ?? "",
        banner: data['banner'] ?? "");
  }
}
