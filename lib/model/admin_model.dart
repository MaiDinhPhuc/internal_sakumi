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
  final bool enableIOS, enableAndroid, enableGift;
  final int id, type, force247, forceSakumi;
  final String title, des, banner1, banner2, banner3;

  const EnableGiftModel(
      {required this.enableIOS,
      required this.enableGift,
      required this.id,
      required this.title,
      required this.des,
      required this.banner1,
      required this.enableAndroid,
      required this.banner2,
      required this.banner3,
      required this.force247,
      required this.forceSakumi,
      required this.type});

  factory EnableGiftModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return EnableGiftModel(
        enableIOS: data["enableIOS"],
        enableAndroid: data["enableAndroid"],
        id: data["id"],
        title: data['title'] ?? "",
        des: data['des'] ?? "",
        banner1: data['banner1'],
        banner2: data['banner2'],
        banner3: data['banner3'],
        force247: data['force247'],
        forceSakumi: data['forceSakumi'],
        type: data['type'],
        enableGift: data["enable_gift"]);
  }
}
