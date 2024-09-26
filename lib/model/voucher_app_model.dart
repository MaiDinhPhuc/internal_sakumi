import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:googleapis/cloudsearch/v1.dart';
import 'package:intl/intl.dart';

class VoucherAppModel {
  final int id, limit,expiredDate,createDate, usingTime;
  final String recipientCode,
      voucherCode,
      noted,
      price;
  final List<dynamic> usedData;

  const VoucherAppModel(
      {required this.id,
        required this.limit,
        required this.recipientCode,
        required this.usedData,
        required this.voucherCode,
        required this.createDate,
        required this.expiredDate,
        required this.noted,
        required this.price,
        required this.usingTime
      });

  factory VoucherAppModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return VoucherAppModel(
      id: data["id"],
      recipientCode: data['recipient_code'] ?? '',
      usedData: data['used_data'] ?? [],
      voucherCode: data['voucher_code'],
      createDate: data['create_date'] ??DateTime.now().millisecondsSinceEpoch,
      expiredDate: data['expired_date'] ??DateTime.now().millisecondsSinceEpoch,
      noted: data['noted'] ?? '',
      price: data['price'] ?? '256.000',
      limit: data['limit'] ?? 1,
        usingTime: data['using_time']??1
    );
  }
}
