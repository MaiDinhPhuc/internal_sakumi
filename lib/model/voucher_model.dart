import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:intl/intl.dart';

class SocialInfoModel {
  String image;
  String name;
  String link;

  SocialInfoModel(this.image, this.name, this.link);
}

class VoucherModel {
  final int id;
  final String recipientCode,
      usedUserCode,
      voucherCode,
      createDate,
      usedDate,
      expiredDate,
      noted,
      price,
      type;
  final bool isFullCourse;

  const VoucherModel(
      {required this.id,
      required this.recipientCode,
      required this.usedUserCode,
      required this.voucherCode,
      required this.createDate,
      required this.usedDate,
      required this.expiredDate,
      required this.noted,
      required this.price,
      required this.type, required this.isFullCourse});

  factory VoucherModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return VoucherModel(
      id: data["id"],
      recipientCode: data['recipient_code'] ?? '',
      usedUserCode: data['used_user_code'] ?? '',
      voucherCode: data['voucher_code'],
      createDate: data['create_date'] ??
          DateFormat('dd/MM/yyyy').format(DateTime.now()),
      usedDate:
          data['used_date'] ?? DateFormat('dd/MM/yyyy').format(DateTime.now()),
      expiredDate: data['expired_date'] ??
          DateFormat('dd/MM/yyyy').format(DateTime(DateTime.now().year,
              DateTime.now().month + 3, DateTime.now().day)),
      noted: data['noted'] ?? '',
      price: data['price'] ?? '50.000',
      type: data['type'] ?? AppText.txtAllCourse.text,
      isFullCourse: data['full_course'] ?? false,
    );
  }
}
