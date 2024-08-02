import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:intl/intl.dart';

class VoucherAppModel {
  final int id;
  final String recipientCode,
      voucherCode,
      createDate,
      usedDate,
      expiredDate,
      noted,
      price;
  final List<dynamic> usedUserCode;

  const VoucherAppModel(
      {required this.id,
        required this.recipientCode,
        required this.usedUserCode,
        required this.voucherCode,
        required this.createDate,
        required this.usedDate,
        required this.expiredDate,
        required this.noted,
        required this.price});

  factory VoucherAppModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return VoucherAppModel(
      id: data["id"],
      recipientCode: data['recipient_code'] ?? '',
      usedUserCode: data['used_user_code'] ?? [],
      voucherCode: data['voucher_code'],
      createDate: data['create_date'] ??
          DateFormat('dd/MM/yyyy').format(DateTime.now()),
      usedDate:
      data['used_date'] ?? DateFormat('dd/MM/yyyy').format(DateTime.now()),
      expiredDate: data['expired_date'] ??
          DateFormat('dd/MM/yyyy').format(DateTime(DateTime.now().year,
              DateTime.now().month + 1, DateTime.now().day)),
      noted: data['noted'] ?? '',
      price: data['price'] ?? '256.000',
    );
  }
}
