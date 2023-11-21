import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String email;
  final String role;
  final int id;

  const UserModel({
    required this.email,
    required this.role,
    required this.id,
  });

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
      email: data["email"]??"",
      role: data["roles"]??"",
      id: data['user_id']??999999999999999,
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
        email: json["email"],
        role: json["roles"],
        id: json['user_id'],
      );
}
