import 'package:cloud_firestore/cloud_firestore.dart';

class AdviseModel {
  final String phone, email, type, status;
  final int date, typeId, userId;

  const AdviseModel(
      {required this.phone,
      required this.status,
      required this.date,
      required this.typeId,
      required this.userId,
      required this.email,
      required this.type});

  Map<String, dynamic> toJson() {
    return {
      "phone": phone,
      "date": date,
      "type_id": typeId,
      "user_id": userId,
      "email": email,
      "type": type,
      "status": status
    };
  }

  factory AdviseModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return AdviseModel(
        phone: data['phone'],
        date: data['date'],
        typeId: data['type_id'],
        userId: data['user_id'],
        email: data['email'],
        type: data['type'],
        status: data['status']);
  }
}
