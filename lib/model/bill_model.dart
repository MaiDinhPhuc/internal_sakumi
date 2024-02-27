import 'package:cloud_firestore/cloud_firestore.dart';

class BillModel {
  final int classId,
      userId,
      paymentDate,
      renewDate,
      payment,
      refund,
      createDate,
      courseId, classType;
  final String type, status, note, check, creator, currency;
  final bool delete;

  BillModel(
      {required this.classId,
      required this.userId,
      required this.paymentDate,
      required this.renewDate,
      required this.payment,
      required this.note,
      required this.refund,
      required this.type,
      required this.status,
      required this.check,
      required this.createDate,
      required this.delete,
      required this.creator,
      required this.currency,
      required this.courseId, required this.classType});
  factory BillModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return BillModel(
        classId: data['class_id'] ?? -1,
        userId: data['user_id'] ?? -1,
        paymentDate: data['payment_date'] ?? 0,
        renewDate: data['renew_date'] ?? 0,
        payment: data['payment'] ?? 0,
        note: data['note'] ?? '',
        refund: data['refund'] ?? 0,
        type: data['type'] ?? 'sale_full',
        status: data['status'] ?? "notRefund",
        check: data['check'] ?? "notCheck",
        createDate: data['create_date'] ?? 0,
        delete: data['delete'] ?? false,
        creator: data["creator"] ?? "Empty",
        currency: data["currency"] ?? "Tiền Việt(vnđ)",
        courseId: data['courseId'] ?? -1, classType: data['class_type'] ?? 0);
  }
}
