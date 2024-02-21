import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum FilterBillStatus { check, notCheck }

extension FilterBillStatusEx on FilterBillStatus {
  String get status {
    switch (this) {
      case FilterBillStatus.check:
        return "check";
      case FilterBillStatus.notCheck:
        return "notCheck";
    }
  }

  String get title {
    switch (this) {
      case FilterBillStatus.check:
        return "Đã đối xoát";
      case FilterBillStatus.notCheck:
        return "Chưa đối xoát";
    }
  }
}

enum FilterBillType {
  sale1Term,
  saleFull,
  saleDeposit1,
  saleDepositFull,
  saleBSHP1,
  saleBSHPFull,
  combo,
  saleDeposit1And1,
  upSaleFull,
  upSale1Term,
  upSaleTo1And1,
  upSaleDeposit1,
  upSaleDepositFull,
  upSaleBSHP1,
  upSaleBSHPFull,
  renew1Term,
  renew2Term,
  renewDeposit1,
  renewDeposit2,
  renewBSHP1,
  renewBSHP2
}

extension FilterBillTypeEx on FilterBillType {
  String get status {
    switch (this) {
      case FilterBillType.sale1Term:
        return "SALE - 1 KÌ";
      case FilterBillType.saleFull:
        return "SALE - FULL KHOÁ";
      case FilterBillType.saleDeposit1:
        return "SALE - CỌC 1 KÌ";
      case FilterBillType.saleDepositFull:
        return "SALE - CỌC FULL KHOÁ";
      case FilterBillType.saleBSHP1:
        return "SALE - BSHP 1 KÌ";
      case FilterBillType.saleBSHPFull:
        return "SALE - BSHP FULL KHOÁ";
      case FilterBillType.combo:
        return "COMBO";
      case FilterBillType.saleDeposit1And1:
        return "SALE - CỌC 1:1";
      case FilterBillType.upSaleFull:
        return "UPSALE - FULL KHOÁ";
      case FilterBillType.upSale1Term:
        return "UPSALE - 1 KÌ";
      case FilterBillType.upSaleTo1And1:
        return "UPSALE - TỪ NHÓM QUA 1:1";
      case FilterBillType.upSaleDeposit1:
        return "UPSALE - CỌC 1 KÌ";
      case FilterBillType.upSaleDepositFull:
        return "UPSALE - CỌC FULL KHOÁ";
      case FilterBillType.upSaleBSHP1:
        return "UPSALE - BSHP 1 KÌ";
      case FilterBillType.upSaleBSHPFull:
        return "UPSALE - BSHP FULL KHOÁ";
      case FilterBillType.renew1Term:
        return "RENEW - 1 KÌ";
      case FilterBillType.renew2Term:
        return "RENEW - 2 KÌ";
      case FilterBillType.renewDeposit1:
        return "RENEW - CỌC 1 KÌ";
      case FilterBillType.renewDeposit2:
        return "RENEW - CỌC 2 KÌ";
      case FilterBillType.renewBSHP1:
        return "RENEW - BSHP 1 KÌ";
      case FilterBillType.renewBSHP2:
        return "RENEW - BSHP 2 KÌ";
    }
  }

  String get title {
    switch (this) {
      case FilterBillType.sale1Term:
        return "SALE - 1 KÌ";
      case FilterBillType.saleFull:
        return "SALE - FULL KHOÁ";
      case FilterBillType.saleDeposit1:
        return "SALE - CỌC 1 KÌ";
      case FilterBillType.saleDepositFull:
        return "SALE - CỌC FULL KHOÁ";
      case FilterBillType.saleBSHP1:
        return "SALE - BSHP 1 KÌ";
      case FilterBillType.saleBSHPFull:
        return "SALE - BSHP FULL KHOÁ";
      case FilterBillType.combo:
        return "COMBO";
      case FilterBillType.saleDeposit1And1:
        return "SALE - CỌC 1:1";
      case FilterBillType.upSaleFull:
        return "UPSALE - FULL KHOÁ";
      case FilterBillType.upSale1Term:
        return "UPSALE - 1 KÌ";
      case FilterBillType.upSaleTo1And1:
        return "UPSALE - TỪ NHÓM QUA 1:1";
      case FilterBillType.upSaleDeposit1:
        return "UPSALE - CỌC 1 KÌ";
      case FilterBillType.upSaleDepositFull:
        return "UPSALE - CỌC FULL KHOÁ";
      case FilterBillType.upSaleBSHP1:
        return "UPSALE - BSHP 1 KÌ";
      case FilterBillType.upSaleBSHPFull:
        return "UPSALE - BSHP FULL KHOÁ";
      case FilterBillType.renew1Term:
        return "RENEW - 1 KÌ";
      case FilterBillType.renew2Term:
        return "RENEW - 2 KÌ";
      case FilterBillType.renewDeposit1:
        return "RENEW - CỌC 1 KÌ";
      case FilterBillType.renewDeposit2:
        return "RENEW - CỌC 2 KÌ";
      case FilterBillType.renewBSHP1:
        return "RENEW - BSHP 1 KÌ";
      case FilterBillType.renewBSHP2:
        return "RENEW - BSHP 2 KÌ";
    }
  }
}

enum BillFilter { status, type }

class BillFilterCubit extends Cubit<int> {
  BillFilterCubit() : super(0) {
    _init();
  }

  static const Map<BillFilter, List> defaultFilter = {
    BillFilter.status: [FilterBillStatus.check, FilterBillStatus.notCheck],
    BillFilter.type: [FilterBillType.sale1Term, FilterBillType.saleFull]
  };

  Map<BillFilter, List> _filter = {};

  Map<BillFilter, List> get filter => _filter;

  Future<void> _saveToPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = json.encode(convertFilterEncode());
    prefs.setString('filterBill', jsonString);
  }

  Map<String, dynamic> convertFilterEncode() {
    var listStatus = filter[BillFilter.status]!
        .map((e) => (e as FilterBillStatus).title)
        .toList();
    var listType = filter[BillFilter.type]!
        .map((e) => (e as FilterBillType).title)
        .toList();

    return {"status": listStatus, "type": listType};
  }

  Map<BillFilter, List> convertFilterDecode(dynamic json) {
    var listStatus = [];
    for (var i in json["status"]) {
      switch (i) {
        case "Đã đối xoát":
          listStatus.add(FilterBillStatus.check);
          break;
        case "Chưa đối xoát":
          listStatus.add(FilterBillStatus.notCheck);
          break;
      }
    }

    var listType = [];
    for (var i in json["type"]) {
      switch (i) {
        case "SALE - 1 KÌ":
          listType.add(FilterBillType.sale1Term);
          break;
        case "SALE - FULL KHOÁ":
          listType.add(FilterBillType.saleFull);
          break;
        case "SALE - CỌC 1 KÌ":
          listType.add(FilterBillType.saleDeposit1);
          break;
        case "SALE - CỌC FULL KHOÁ":
          listType.add(FilterBillType.saleDepositFull);
          break;
        case "SALE - BSHP 1 KÌ":
          listType.add(FilterBillType.saleBSHP1);
          break;
        case "SALE - BSHP FULL KHOÁ":
          listType.add(FilterBillType.saleBSHPFull);
          break;
        case "COMBO":
          listType.add(FilterBillType.combo);
          break;
        case "SALE - CỌC 1:1":
          listType.add(FilterBillType.saleDeposit1And1);
          break;
        case "UPSALE - FULL KHOÁ":
          listType.add(FilterBillType.upSaleFull);
          break;
        case "UPSALE - 1 KÌ":
          listType.add(FilterBillType.upSale1Term);
          break;
        case "UPSALE - TỪ NHÓM QUA 1:1":
          listType.add(FilterBillType.upSaleTo1And1);
          break;
        case "UPSALE - CỌC 1 KÌ":
          listType.add(FilterBillType.upSaleDeposit1);
          break;
        case "UPSALE - CỌC FULL KHOÁ":
          listType.add(FilterBillType.upSaleDepositFull);
          break;
        case "UPSALE - BSHP 1 KÌ":
          listType.add(FilterBillType.upSaleBSHP1);
          break;
        case "UPSALE - BSHP FULL KHOÁ":
          listType.add(FilterBillType.upSaleBSHPFull);
          break;
        case "RENEW - 1 KÌ":
          listType.add(FilterBillType.renew1Term);
          break;
        case "RENEW - 2 KÌ":
          listType.add(FilterBillType.renew2Term);
          break;
        case "RENEW - CỌC 1 KÌ":
          listType.add(FilterBillType.renewDeposit1);
          break;
        case "RENEW - CỌC 2 KÌ":
          listType.add(FilterBillType.renewDeposit2);
          break;
        case "RENEW - BSHP 1 KÌ":
          listType.add(FilterBillType.renewBSHP1);
          break;
        case "RENEW - BSHP 2 KÌ":
          listType.add(FilterBillType.renewBSHP2);
          break;
      }
    }
    return {BillFilter.status: listStatus, BillFilter.type: listType};
  }

  Future<Map<BillFilter, List>?> _fromPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('filterBill');
    if (jsonString != null) {
      return convertFilterDecode(json.decode(jsonString));
    }
    return null;
  }

  _init() async {
    _filter = await _fromPref() ??
        defaultFilter.keys.fold({}, (pre, key) {
          pre[key] = defaultFilter[key]!;
          return pre;
        });
    emit(state + 1);
  }

  update(BillFilter billFilter, List selectedList) async {
    bool areListsEqual =
        const ListEquality().equals(_filter[billFilter], selectedList);
    if (!areListsEqual) {
      _filter[billFilter] = selectedList;
      _saveToPref();
      emit(state + 1);
    }
  }
}
